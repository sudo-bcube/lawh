// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

import sitemap from '@astrojs/sitemap';
import remarkEnvReplace from './plugins/remark-env-replace.mjs';

export default defineConfig({
  site: process.env.SITE_URL || 'https://lawh.bcube.tech',
  vite: {
    plugins: [tailwindcss()]
  },
  markdown: {
    remarkPlugins: [remarkEnvReplace],
  },
  integrations: [sitemap()]
});