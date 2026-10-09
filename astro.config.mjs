// @ts-check

import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import { defineConfig } from 'astro/config';

// Public origin for canonical/RSS/sitemap links. Override SITE_URL (and
// BASE_PATH when serving from a subdirectory) in the deploy environment.
const site = process.env.SITE_URL ?? 'https://wallus-src.github.io';
const base = process.env.BASE_PATH ?? (process.env.SITE_URL ? '/' : '/dev');

// https://astro.build/config
export default defineConfig({
	site,
	base,
	integrations: [mdx(), sitemap()],
});
