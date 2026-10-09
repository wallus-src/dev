# Fieldnotes

A personal publication about the craft of building software — essays on craft, tools, reading code, and the small web. Built with [Astro](https://astro.build), set in Fraunces and Inter, deployed as static files.

## Writing a post

Create a Markdown or MDX file in `src/content/blog/`:

```md
---
title: 'My essay'
description: 'One sentence shown in indexes and search.'
pubDate: 'Oct 09 2026'
tags: ['craft']
featured: false
heroImage: '../../assets/covers/cover.jpg'
heroAlt: 'Cover caption'
---

Your essay…
```

Set `featured: true` on at most one post to pin it on the home page, and `draft: true` to hide a post everywhere.

## Commands

| Command           | Action                                          |
| :---------------- | :---------------------------------------------- |
| `npm install`     | Installs dependencies                           |
| `npm run dev`     | Starts local dev server at `localhost:4321`     |
| `npm run build`   | Builds the production site to `./dist/`         |
| `npm run preview` | Previews the production build locally           |
| `npx astro check` | Type-checks the project                         |

## What's inside

- Content collections (Markdown/MDX) with typed frontmatter
- ⌘K / Ctrl-K search palette backed by a generated `/search.json` index
- Tag archive pages, RSS feed, sitemap
- Light/dark theme with no-FOUC init, remembered across visits
- Sticky table of contents and scroll progress on posts
- View transitions between pages
