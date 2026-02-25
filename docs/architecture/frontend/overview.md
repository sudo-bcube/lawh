# Frontend Architecture Overview

[Back to Architecture Index](../index.md)

---

## IMPORTANT UPDATE: STT Provider Decision

**Date:** February 3, 2026
**Decision:** **Use Google Cloud Speech-to-Text (not Azure)**

After comprehensive testing:
- **Azure STT:** Failed on live recordings - returns English garbage ("Who do we do")
- **Google Cloud STT:** Pure Arabic, 60-70% accuracy - viable for MVP

**Impact on this document:**
- All references to "Azure STT" should be read as "Google Cloud STT"
- Repository pattern remains the same (swap `AzureSttRepositoryImpl` -> `GoogleSttRepositoryImpl`)
- See detailed comparison: [STT Decision Summary](../../archive/decision-making/azure-stt-quick-summary.md.archive)

**Implementation changes:**
- Use Google Cloud Speech-to-Text API (REST with API key)
- Audio format: WAV 16kHz mono (same as Azure)
- Fuzzy matching threshold: 40% (generous due to 60-70% STT accuracy)

---

## Change Log

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| 2026-02-03 | 1.1 | Updated STT provider decision: Google Cloud STT selected | Claude Code |
| 2026-02-03 | 1.0 | Initial frontend architecture document created | Winston (Architect) |

---

## Template and Framework Selection

### Framework Selected: Flutter (Dart)

**Rationale**:
- **Cross-platform efficiency**: Single codebase for iOS and Android meets the aggressive 4-week MVP timeline
- **Solo developer optimization**: Reduces context switching between platform-specific code
- **Performance requirements**: Native compilation achieves the required 60fps animations and <2s app launch time
- **UI/UX alignment**: Material Design 3 and Cupertino widgets provide the platform-native foundation described in the UI/UX spec
- **Web potential**: Flutter Web capability supports the future web version mentioned in the brief

### Key Dependencies Identified

- **Flutter SDK**: Latest stable (3.x+)
- **Google Cloud Speech-to-Text**: Selected after testing (see STT decision above)
- **Quran Text Database**: Tanzil.net or EveryAyah.com (pending license verification)

### Starter Template Approach

**Decision**: Standard Flutter project initialization without pre-built template.

**Reasoning**: The app's unique audio-first interaction model doesn't fit standard UI templates. Custom architecture provides:
- Full control over audio recording and API integration patterns
- Optimized state management for the specific "listen -> identify -> read" flow
- No unnecessary dependencies or boilerplate to remove

### Trade-offs Made

1. **Flutter vs React Native**: Chose Flutter for better performance (native compilation vs JavaScript bridge) and more mature state management options
2. **Custom vs Template**: Opted against UI templates because the unique audio-first workflow requires custom patterns
3. **Single Framework Risk**: Accepted vendor lock-in to Flutter for speed-to-market benefits; migration path exists via Flutter Web if needed

### Key Assumptions

- Developer has Flutter experience (mentioned in brief as "full-stack capabilities")
- Flutter's audio recording packages will meet the 10-15 second recording requirement
- Platform-specific microphone permissions will work without major friction

### Areas Requiring Validation

- **Quran font rendering**: Flutter's text rendering must handle complex Arabic Uthmani script with proper diacritical marks
- **Audio codec support**: Verify AAC/Opus compression works on both iOS and Android
- **Platform differences**: iOS requires explicit microphone permissions; Android needs runtime permissions handling

---

## Related Documentation

- [Tech Stack](./tech-stack.md) - Full technology stack and package versions
- [Project Structure](./project-structure.md) - Directory structure and architecture patterns
- [Clean Architecture](./clean-architecture.md) - SOLID principles and code quality guidelines
