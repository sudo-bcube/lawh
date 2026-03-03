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

## Environment Variables

All configurable links and settings should be stored in `.env` files:

```bash
# .env.example (commit this file)
# App Store Links
PUBLIC_IOS_APP_URL=https://apps.apple.com/app/lawh/id000000000
PUBLIC_ANDROID_APP_URL=https://play.google.com/store/apps/details?id=com.lawh.app

# Contact
PUBLIC_CONTACT_EMAIL=hello@lawh.app
PUBLIC_SUPPORT_EMAIL=support@lawh.app

# Social Media (optional)
PUBLIC_TWITTER_URL=
PUBLIC_INSTAGRAM_URL=
PUBLIC_FACEBOOK_URL=

# Analytics (optional)
PUBLIC_PLAUSIBLE_DOMAIN=
```

**Usage in Astro components:**
```astro
---
const iosUrl = import.meta.env.PUBLIC_IOS_APP_URL;
const androidUrl = import.meta.env.PUBLIC_ANDROID_APP_URL;
---
<a href={iosUrl}>Download on App Store</a>
<a href={androidUrl}>Get it on Google Play</a>
```

---

## Reference Template

A Bootstrap-based HTML template is provided at `/web-template/` for visual reference:
- **Template:** Advanced Free Lite (app landing page)
- **Structure:** Hero → Features → About → Pricing → Download → Footer
- **Assets:** Contains placeholder images, icons (LineIcons), animations (WOW.js)

The Astro implementation should achieve similar visual structure but use:
- Tailwind CSS instead of Bootstrap
- Astro components instead of raw HTML
- Modern image optimization via Astro's `<Image />` component

---

## Proposed Structure

```
lawh-website/
├── src/
│   ├── pages/
│   │   ├── index.astro           # Landing page
│   │   ├── privacy.md            # Privacy Policy (from docs/)
│   │   ├── terms.md              # Terms of Use (from docs/)
│   │   └── faq.md                # FAQ (from docs/)
│   ├── components/
│   │   ├── Header.astro          # Navigation bar with logo
│   │   ├── Hero.astro            # Main hero section
│   │   ├── WhyThisMatters.astro  # Problem/context section
│   │   ├── Features.astro        # How Lawh helps
│   │   ├── HowItWorks.astro      # Step-by-step usage
│   │   ├── IslamicEmphasis.astro # Hadith/reward section
│   │   ├── Differentiator.astro  # What makes us different
│   │   ├── Pricing.astro         # Subscription tiers
│   │   ├── FAQ.astro             # Inline FAQ section
│   │   ├── Contact.astro         # Contact form/info
│   │   ├── AppStoreButtons.astro # iOS/Android download buttons
│   │   └── Footer.astro          # Footer with links
│   └── layouts/
│       └── Base.astro            # Shared layout (meta, RTL support)
├── public/
│   ├── screenshots/              # App screenshots for marketing
│   ├── favicon.png
│   └── og-image.png              # Social sharing image
├── .env.example                  # Environment variable template
├── .env                          # Local env vars (gitignored)
├── astro.config.mjs
├── tailwind.config.mjs
└── package.json
```

---

## Landing Page Sections (Detailed)

### 1. Header/Navigation
- Logo (left)
- Nav links: Features, How It Works, Pricing, FAQ
- CTA button: "Download App" (right)

### 2. Hero Section

**Headline:**
> Be in sync with moments that move your faith.

**Subtext:**
> Feel focused, connected, and fully present with every Quran verse without distraction or friction.

**Badge text:**
> *All recitations recognized, whatever the style.

**CTA Button:**
> Try Lawh for free

**Visual:**
- App mockup/screenshot on the right side
- Decorative shapes/gradients in background (reference: template hero)

---

### 3. Why This Matters Section

**Section Title:**
> Moments you shouldn't miss.

**Body Copy:**
> Some experiences are meant for reflection, not for fumbling through menus.
>
> Whether you walk into a recitation and aren't sure which surah is being read, join Taraweeh late and want to know exactly where the Imam is, hear a verse that touches your heart, or come across one online and wish to verify it instantly — Lawh is there for those moments.
>
> It keeps you in sync with every recitation, helping you stay present, reflect deeply, and connect meaningfully with the Qur'an.

---

### 4. Features Section

**Section Title:**
> Helping your Iman grow in more ways than one

**Features (5 cards/items):**

| Feature | Description |
|---------|-------------|
| Instant recognition | Record any Quran verse and see instant Arabic text, transliteration, and translation, no matter the recitation style. |
| Real-time flow | Follow recitations naturally. Intonation, dialect, or tribal variation won't get in the way. |
| Effortless search | Find any verse or surah quickly, even if you only remember part of it. |
| Read and share | Explore the Qur'an at your own pace, or share meaningful verses with loved ones. |
| Stay present | Every interaction keeps you in sync with your recitation so you can reflect, focus, and feel the words fully. |

**Icons to use:** (LineIcons or similar)
- Instant recognition: `lni-mic` or microphone icon
- Real-time flow: `lni-pulse` or waveform icon
- Effortless search: `lni-search` or magnifier icon
- Read and share: `lni-share` or book+share icon
- Stay present: `lni-heart` or meditation icon

---

### 5. How It Works Section

**Section Title:**
> Stay in sync with every verse

**Steps (5 steps, numbered):**

| Step | Title | Description |
|------|-------|-------------|
| 1 | Hear a verse | During recitation, lectures, or daily reflection. |
| 2 | Lawh it | Tap to record and instantly recognize the verse. |
| 3 | See the verse | Arabic text, transliteration, and translation appear instantly. |
| 4 | Reflect or share | Pause to understand, save it, or share with loved ones. |
| 5 | Stay in sync | Follow the recitation naturally, building a habit of presence and reflection. |

**Visual:**
- Vertical timeline or horizontal step indicators
- Optional: app screenshot showing each step

---

### 6. Islamic Emphasis Section

**Section Title:**
> Remember, every verse carries its reward

**Body Copy:**
> Reading the Qur'an daily carries deep reward and peace for the heart. As the Holy Prophet S.A.W advised:

**Hadith Quote (styled as blockquote):**
> "Whoever recites a letter of the Qur'an, he will have a reward, and the reward will be multiplied by ten. I do not say 'Alif, Lam, Meem' is one letter, but Alif is a letter, Lam is a letter, and Meem is a letter."
>
> — Ṣaḥīḥ al-Tirmidhī 2910

**Closing Copy:**
> Even a single verse, remembered, pondered, or shared, carries reward. Lawh makes these moments easier and more meaningful, supporting you with technology, not distracting you with it.

**Styling:**
- Elegant typography for the hadith quote
- Consider subtle Islamic geometric pattern as background
- Muted, respectful color palette for this section

---

### 7. Differentiator Section

**Section Title:**
> The Quran comes first

**Body Copy:**
> Many Qur'an apps overload you with menus and features you never asked for. Glitches make navigation unreliable, and intrusive notifications or ads can pull you out of the moment.
>
> Lawh keeps it simple, respectful, and focused. One app with one purpose: helping you experience the Qur'an fully, every time you open it.

**CTA Button:**
> See it in Action

*(This could link to a demo video or app store)*

---

### 8. Pricing Section

**Section Title:**
> Choose Your Plan

| Plan | Price | Features |
|------|-------|----------|
| Free | $0 | 3 searches/day, ads shown |
| Monthly | $1/month | Unlimited searches, ad-free |
| Yearly | $10/year | Unlimited searches, ad-free, 2 months free |

**Note:** Highlight "Yearly" as best value with a badge

**Styling:**
- 3-column card layout (reference: template pricing section)
- Monthly plan can be marked as "Popular" or yearly as "Best Value"

---

### 9. FAQ Section

**Section Title:**
> Your guide to using Lawh with ease

| Question | Answer |
|----------|--------|
| What is Lawh exactly? | Lawh is an instant Quran audio recognition app designed to make reflection effortless. Each verse is recognized instantly, displayed in Arabic, transliteration, and translation, and works across all 7 recitation styles. |
| How do I get access? | Just download or open the app. It's fully available to everyone. |
| Is there a free version? | Yes! The free plan gives you 3 searches per day. Upgrade to remove ads and unlock unlimited searches. |
| Do I need to worry about recitation style or dialect? | Not at all. Lawh recognizes all 7 Quranic recitation dialects, so intonation or tribal variation never gets in the way of your reflection. |
| Can I give feedback or help shape it? | Absolutely. Feedback is optional. You can quietly explore, or share thoughts and suggestions. We read every message. |

**Styling:**
- Accordion or expandable list
- Keep answers concise

---

### 10. Contact Section

**Section Title:**
> Sharing your moments of faith and more

**Body Copy:**
> Have a question, a reflection, or a verse that moved you? Share it with us. We love hearing how Lawh fits into your moments of faith.
>
> Whether it's feedback, a suggestion, or even ideas for collaboration, drop us a message and we'll get back to you within 48 hours.

**Contact Form Fields:**
- Name
- Email
- Message
- Submit button

**Alternative:** Simple email link using `PUBLIC_CONTACT_EMAIL` env var

---

### 11. Download Section (CTA Banner)

**Headline:**
> Download Lawh Today

**Subtext:**
> Available on iOS and Android

**Buttons:**
- App Store button (uses `PUBLIC_IOS_APP_URL`)
- Play Store button (uses `PUBLIC_ANDROID_APP_URL`)

**Visual:**
- App mockup/phone image
- Gradient or colored background

---

### 12. Footer

**Content:**
- Logo
- Quick links: Privacy Policy, Terms of Use, FAQ
- Contact email: `PUBLIC_CONTACT_EMAIL`
- Social media icons (if configured)
- Copyright: © 2026 Lawh. All rights reserved.

---

## Technical Requirements

### RTL Support
- Arabic content requires right-to-left layout
- Astro supports RTL via CSS `dir="rtl"`
- Consider language toggle (EN/AR) for future

### SEO
- Meta title: "Lawh - Instant Quran Verse Recognition"
- Meta description: "Be in sync with moments that move your faith. Identify any Quran verse instantly with Lawh."
- Open Graph image for social sharing
- Structured data for app (schema.org/MobileApplication)

### Accessibility
- Proper heading hierarchy (h1 → h2 → h3)
- Alt text for all images
- Keyboard navigation support
- Sufficient color contrast

### Performance
- Lazy load images below the fold
- Use Astro's built-in image optimization
- Minimize JavaScript (Astro ships zero JS by default)

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

# Copy environment template
cp .env.example .env

# Start dev server
npm run dev

# Build for production
npm run build

# Deploy to Vercel
vercel deploy
```

---

## Design Guidelines

### Colors (suggested)
- Primary: Deep teal or Islamic green (#0D7377 or similar)
- Secondary: Warm gold accent (#D4AF37)
- Background: Light cream/off-white (#FAFAF8)
- Text: Dark charcoal (#1A1A1A)

### Typography
- Headings: Modern sans-serif (Inter, Poppins, or similar)
- Body: Clean, readable sans-serif
- Arabic text: Proper Arabic font (Amiri, Scheherazade, or Noto Naskh Arabic)

### Imagery
- App screenshots showing verse recognition
- Clean, minimal phone mockups
- Subtle Islamic geometric patterns (optional, non-intrusive)

---

## Resources

- [Astro Official Site](https://astro.build/)
- [Astro Documentation](https://docs.astro.build/)
- [Free Astro Themes](https://getastrothemes.com/free-astro-themes-templates/)
- [Astro + Tailwind Guide](https://docs.astro.build/en/guides/integrations-guide/tailwind/)
- Reference template: `/web-template/index.html`

---

## Next Steps

1. [ ] Gather app screenshots for marketing
2. [ ] Initialize Astro project in `/lawh-website` directory
3. [ ] Create `.env.example` with app store link placeholders
4. [ ] Build landing page sections following specs above
5. [ ] Migrate legal docs to Astro pages
6. [ ] Test RTL support for Arabic content
7. [ ] Deploy to Vercel/Netlify
8. [ ] Connect custom domain
