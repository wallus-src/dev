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

## Deploying

The site builds into `./dist/` as static files. Set the public origin at build time so canonical URLs, the sitemap, and RSS links are correct:

```sh
SITE_URL=https://your-domain.example BASE_PATH=/ npm run build
```

Without overrides it targets GitHub Pages at `https://wallus-src.github.io/dev/`. All internal links are base-aware via `link()` in `src/utils/posts.ts`.

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
