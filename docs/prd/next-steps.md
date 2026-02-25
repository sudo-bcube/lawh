# Next Steps

## UX Expert Prompt

Review the Lawh PRD (`docs/prd.md`) and UI Design Goals section. Create detailed UX specifications including:

1. **Wireframes/Mockups** for core screens (main, recording, results, reader, settings)
2. **User Flow Diagrams** for primary journeys (hear → record → identify → read)
3. **Design System** specifications (dark green/snow white color palette, Uthmani script typography, component library)
4. **Interaction Patterns** for confidence-based results display, recording UI, feedback collection
5. **Accessibility Guidelines** for MVP (text sizing, contrast 4.5:1, touch targets 44x44pt)
6. **Cultural Design Review** ensuring respectful imagery, RTL support, and Islamic design principles

Focus on spiritual minimalism, cultural sensitivity, and mobile-first responsive design for iOS/Android platforms.

**Deliverables:** UX specification document with wireframes, style guide, and component specifications ready for developer implementation in Epic 3.

## Architect Prompt

Review the Lawh PRD (`docs/prd.md`), all epic files in `docs/prd/`, and Technical Assumptions section. Create comprehensive technical architecture including:

1. **System Architecture** design (backend API, Flutter mobile apps, database, Azure STT integration, local Quran database)
2. **Fuzzy Matching Algorithm** specification with concrete implementation approach (Levenshtein, phonetic matching, confidence scoring formula)
3. **Database Schema** DDL with complete table definitions, indexes, foreign keys, and migration strategy
4. **API Specification** for all endpoints (`/search`, `/quran`, `/feedback`, `/admin/*`) with request/response formats
5. **Performance Optimization** strategy for ≤2s matching (NFR11) and <50ms Quran queries
6. **Security Architecture** for GDPR/CCPA compliance, data encryption, environment variable management
7. **Deployment Architecture** for staging/production environments with CI/CD pipeline
8. **Technical Risk Mitigation** plan for Azure STT validation, algorithm performance, concurrent load testing

**Critical First Task:** Conduct Week 1 technical spike validating Azure Speech-to-Text accuracy with Quranic Arabic recitation samples. Document findings and recommend proceed/pivot decision before Epic 2 implementation.

**Deliverables:** Architecture document with diagrams, API specs, database schema, algorithm design, and deployment plan ready for Epic 1 implementation kickoff.

---

**PRD Version:** 1.0
**Status:** Ready for Architecture Phase
**Next Review:** After architecture design completion



