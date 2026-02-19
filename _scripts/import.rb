#!/usr/bin/env ruby
require 'rexml/document'
require 'yaml'
require 'fileutils'
require 'date'

PROJECT_ROOT = File.expand_path('..', __dir__)
XML_PATH = File.join(PROJECT_ROOT, 'stellarrose.WordPress.2026-02-17.xml')

def cdata_text(element, xpath)
  node = element.elements[xpath]
  return '' unless node
  node.text || ''
end

def meta_value(item, key)
  item.each_element('wp:postmeta') do |pm|
    k = cdata_text(pm, 'wp:meta_key')
    return cdata_text(pm, 'wp:meta_value') if k == key
  end
  nil
end

doc = REXML::Document.new(File.read(XML_PATH))
channel = doc.elements['rss/channel']

venues_by_id = {}
events = []

channel.each_element('item') do |item|
  post_type = cdata_text(item, 'wp:post_type')
  status = cdata_text(item, 'wp:status')
  post_id = cdata_text(item, 'wp:post_id')

  case post_type
  when 'tribe_venue'
    next unless status == 'publish'
    slug = cdata_text(item, 'wp:post_name')
    venues_by_id[post_id] = {
      'name'    => cdata_text(item, 'title'),
      'slug'    => slug,
      'address' => meta_value(item, '_VenueAddress') || '',
      'city'    => meta_value(item, '_VenueCity') || '',
      'state'   => meta_value(item, '_VenueState') || '',
      'zip'     => meta_value(item, '_VenueZip') || '',
      'phone'   => meta_value(item, '_VenuePhone') || '',
      'url'     => meta_value(item, '_VenueURL') || ''
    }

  when 'tribe_events'
    next unless status == 'publish'
    venue_id = meta_value(item, '_EventVenueID')
    start_date_str = meta_value(item, '_EventStartDate')
    end_date_str = meta_value(item, '_EventEndDate')
    content = cdata_text(item, 'content:encoded')

    events << {
      'title'      => cdata_text(item, 'title'),
      'slug'       => cdata_text(item, 'wp:post_name'),
      'venue_id'   => venue_id,
      'start_date' => start_date_str,
      'end_date'   => end_date_str,
      'timezone'   => meta_value(item, '_EventTimezone') || 'America/New_York',
      'content'    => content
    }
  end
end

# Write _data/venues.yml
venues_dir = File.join(PROJECT_ROOT, '_data')
FileUtils.mkdir_p(venues_dir)
venues_list = venues_by_id.values.sort_by { |v| v['name'] }
File.write(File.join(venues_dir, 'venues.yml'), venues_list.to_yaml)
puts "Wrote #{venues_list.size} venues to _data/venues.yml"

# Write _events/*.md
events_dir = File.join(PROJECT_ROOT, '_events')
FileUtils.mkdir_p(events_dir)

events.sort_by! { |e| e['start_date'] || '' }

events.each do |evt|
  venue = venues_by_id[evt['venue_id']]
  venue_slug = venue ? venue['slug'] : 'unknown'

  start_dt = DateTime.parse(evt['start_date']) rescue nil
  end_dt = DateTime.parse(evt['end_date']) rescue nil

  date_str = start_dt ? start_dt.strftime('%Y-%m-%d') : 'unknown'
  start_time = start_dt ? start_dt.strftime('%H:%M') : ''
  end_time = end_dt ? end_dt.strftime('%H:%M') : ''

  filename = "#{date_str}-#{evt['slug']}.md"

  front_matter = {
    'title'      => evt['title'],
    'date'       => date_str,
    'start_time' => start_time,
    'end_time'   => end_time,
    'venue'      => venue_slug,
    'timezone'   => evt['timezone']
  }

  content = evt['content'].to_s.strip
  body = "---\n#{front_matter.to_yaml.sub(/^---\n/, '')}---\n"
  body += "\n#{content}\n" unless content.empty?

  File.write(File.join(events_dir, filename), body)
  puts "Wrote event: #{filename}"
end

puts "\nImport complete!"
puts "  #{venues_list.size} venues in _data/venues.yml"
puts "  #{events.size} events in _events/"
