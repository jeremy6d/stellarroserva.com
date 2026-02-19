# Adding Shows

Shows are stored as **event files** in `_events/`. Each file is one show.

## 1. Create an event file

**Filename:** `_events/YYYY-MM-DD-short-slug.md`

Use the **date** and a **URL-friendly slug** (lowercase, hyphens). Examples:

- `_events/2026-03-15-main-line.md`
- `_events/2026-04-01-ripple-rays.md`

## 2. Event front matter

Copy this template and fill it in:

```yaml
---
title: Show Title Here
date: 'YYYY-MM-DD'
start_time: 'HH:MM'
end_time: 'HH:MM'
venue: venue-slug
timezone: America/New_York
---
```

**Fields:**

| Field | Example | Notes |
|-------|---------|--------|
| `title` | `Main Line` | Display name of the show |
| `date` | `'2026-03-15'` | Show date (quotes required) |
| `start_time` | `'19:00'` | 24-hour time (7:00 PM) |
| `end_time` | `'22:00'` | 24-hour time (10:00 PM) |
| `venue` | `main-line-brewery` | **Slug** from `_data/venues.yml` (see below) |
| `timezone` | `America/New_York` | For future use |

**Optional:** Add body text below the `---` for a short description (e.g. "Special early show!").

## 3. Venue slug

The `venue` value must match a **slug** in `_data/venues.yml`. Current venues:

- `main-line-brewery`
- `ripple-rays`
- `tripping-billies`
- `the-camel`
- `kindred-spirits-goochland`
- `kindred-spirit-brewings-satellite`
- `flat-iron-crossroads`
- `frisbys-restaurant-and-side-bar`
- `springhill-festival-grounds`

## 4. New venues

To add a new venue, edit `_data/venues.yml` and add an entry like:

```yaml
- name: Venue Display Name
  slug: venue-slug
  address: 123 Street
  city: Richmond
  state: VA
  zip: '23220'
  phone: "(804) 555-1234"
  url: https://venue-website.com
```

Use the same `slug` in your event’s `venue` field.

## Example: full event file

`_events/2026-03-15-main-line.md`:

```yaml
---
title: Main Line
date: '2026-03-15'
start_time: '19:00'
end_time: '22:00'
venue: main-line-brewery
timezone: America/New_York
---
```

After saving, the show appears on the homepage (upcoming) and on the **Shows** page. Re-run `bundle exec jekyll build` (or use `jekyll serve`) to see changes.
