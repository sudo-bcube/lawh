import type { APIRoute } from 'astro';

export const GET: APIRoute = ({ site }) => {
  const siteUrl = site?.origin || 'https://lawh.bcube.tech';

  return new Response(
    `User-agent: *
Allow: /

Sitemap: ${siteUrl}/sitemap-index.xml
`,
    { headers: { 'Content-Type': 'text/plain' } }
  );
};
