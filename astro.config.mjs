// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: process.env.SITE_URL || 'https://lawh.bcube.tech',
  vite: {
    plugins: [tailwindcss()]
  },
  integrations: [sitemap()]
});