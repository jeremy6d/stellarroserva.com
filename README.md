# Stellar Rose

Jekyll site for Stellar Rose — Richmond's Premier Grateful Dead Tribute Band.

## Setup

```bash
bundle install
bundle exec jekyll serve
```

Open http://localhost:4000

## Events (shows)

Events are maintained as **Markdown files** in `_events/`. Each file is one show. Venues are defined in `_data/venues.yml` and referenced by slug.

### Adding a show

1. **Create a file** in `_events/` named `YYYY-MM-DD-short-slug.md` (e.g. `2026-03-15-main-line.md`).

2. **Add front matter** (required fields):

   ```yaml
   ---
   title: Show Title
   date: 'YYYY-MM-DD'
   start_time: '19:00'
   end_time: '22:00'
   venue: venue-slug
   timezone: America/New_York
   ---
   ```

   - **Times** are 24-hour (e.g. `19:00` = 7:00 PM, `01:00` = 1:00 AM).
   - **venue** must match a `slug` in `_data/venues.yml`.

3. **Optional:** Add body text below the `---` for a short note (e.g. "Special early show!").

Shows appear on the homepage (Upcoming Shows) and on the **Shows** page. Past vs upcoming is determined by `date` vs today.

### Editing or removing a show

- **Edit:** Change the event file in `_events/` (front matter and/or body).
- **Remove:** Delete the event file or move it outside `_events/`.

### Venues

- **Existing venues:** See `_data/venues.yml` for the list. Use the `slug` value in each event’s `venue` field (e.g. `main-line-brewery`, `ripple-rays`, `tripping-billies`, `the-camel`, etc.).

- **New venue:** Add an entry to `_data/venues.yml` with `name`, `slug`, `address`, `city`, `state`, `zip`, `phone`, and `url`. Use that `slug` in event files.

### Full guide and template

- **Detailed guide:** [docs/ADDING-SHOWS.md](docs/ADDING-SHOWS.md)
- **Copy-paste template:** `_events/_template.md.example`

## Build

```bash
bundle exec jekyll build
```

Output is in `_site/`.
