# Lawh Website Planning

## Decision: Astro Framework

**Date:** 2026-02-26
**Status:** Planned (not yet implemented)

---

## Why Astro?

Astro was chosen over WordPress and other alternatives for the following reasons:

| Consideration | Astro Advantage |
|---------------|-----------------|
| Performance | Zero JS by default, 40% faster than React sites |
| Hosting | Static HTML = free hosting on Vercel/Netlify |
| Styling | Tailwind CSS built-in |
| Content | Markdown support (existing legal docs work directly) |
| SEO | Auto sitemaps, meta tags, RSS feeds |
| Flexibility | Island Architecture - add interactivity only where needed |

### Alternatives Considered

1. **WordPress** - Rejected. Overkill for app landing page, slow, requires maintenance.
2. **Carrd** - Good for quick launch, but limited customization.
3. **Framer** - Great design quality, but less developer control.
4. **Flutter Web** - Would keep stack unified, but heavy for a simple landing page.

---

## Proposed Structure

```
lawh-website/
├── src/
│   ├── pages/
│   │   ├── index.astro        # Landing page
│   │   ├── privacy.md         # Privacy Policy (from docs/)
│   │   ├── terms.md           # Terms of Use (from docs/)
│   │   └── faq.md             # FAQ (from docs/)
│   ├── components/
│   │   ├── Hero.astro         # App showcase with screenshots
│   │   ├── Features.astro     # How it works section
│   │   ├── Pricing.astro      # Subscription tiers ($1/mo, $10/yr)
│   │   ├── AppStoreButtons.astro
│   │   └── Footer.astro
│   └── layouts/
│       └── Base.astro         # Shared layout (RTL support)
├── public/
│   └── screenshots/           # App screenshots for marketing
├── astro.config.mjs
├── tailwind.config.mjs
└── package.json
```

---

## Landing Page Sections

### 1. Hero Section
- App name and tagline: "Identify any Quran verse in seconds"
- App mockup/screenshots
- App Store & Play Store download buttons

### 2. How It Works
- Step 1: Record audio (5-15 seconds)
- Step 2: AI identifies the verse
- Step 3: Read, learn, and share

### 3. Features
- Works with ANY reciter
- 85%+ identification accuracy
- Built-in Quran reader
- Translations and transliterations
- Share to social media

### 4. Pricing
| Plan | Price | Features |
|------|-------|----------|
| Free | $0 | 3 searches/day, ads shown |
| Monthly | $1/month | Unlimited searches, ad-free |
| Yearly | $10/year | Unlimited searches, ad-free (2 months free) |

### 5. Footer
- Links to Privacy Policy, Terms of Use, FAQ
- Contact/support email
- Social media links

---

## Technical Requirements

### RTL Support
- Arabic content requires right-to-left layout
- Astro supports RTL via CSS `dir="rtl"`
- Consider language toggle (EN/AR)

### Integrations
- App Store link (iOS)
- Play Store link (Android)
- Analytics (optional: Plausible or Simple Analytics for privacy)

### Existing Assets to Migrate
- `/docs/legal/privacy-policy-en.md`
- `/docs/legal/privacy-policy-ar.md`
- `/docs/legal/terms-of-use-en.md`
- `/docs/legal/terms-of-use-ar.md`
- `/docs/legal/faq-en.md`
- `/docs/legal/faq-ar.md`

---

## Deployment Options

| Platform | Cost | Notes |
|----------|------|-------|
| Vercel | Free | `vercel deploy`, great DX |
| Netlify | Free | Drag & drop or git integration |
| Cloudflare Pages | Free | Excellent global CDN |

---

## Getting Started Commands

```bash
# Create new Astro project
npm create astro@latest lawh-website

# Add Tailwind CSS
npx astro add tailwind

# Start dev server
npm run dev

# Build for production
npm run build

# Deploy to Vercel
vercel deploy
```

---

## Resources

- [Astro Official Site](https://astro.build/)
- [Astro Documentation](https://docs.astro.build/)
- [Free Astro Themes](https://getastrothemes.com/free-astro-themes-templates/)
- [Astro + Tailwind Guide](https://docs.astro.build/en/guides/integrations-guide/tailwind/)

---

## Next Steps

1. [ ] Design mockups for landing page
2. [ ] Gather app screenshots for marketing
3. [ ] Initialize Astro project in `/website` directory
4. [ ] Build landing page sections
5. [ ] Migrate legal docs to Astro pages
6. [ ] Deploy to Vercel/Netlify
7. [ ] Connect custom domain
