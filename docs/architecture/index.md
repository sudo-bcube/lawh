# Lawh Architecture Documentation

## Overview

This folder contains the complete technical architecture for **Lawh** - a Quran verse identification app. The architecture is split into backend (API/infrastructure) and frontend (Flutter mobile) sections.

**Architecture Style:** Monolithic backend with mobile clients
**Overall Score:** 97% - Approved for Development
**Last Updated:** 2026-02-10

---

## Quick Links

### Backend Architecture

| Document | Description |
|----------|-------------|
| [High-Level Overview](./backend/high-level-overview.md) | Technical summary, diagrams, architectural patterns |
| [Tech Stack](./backend/tech-stack.md) | Technology choices with versions and rationale |
| [Data Models](./backend/data-models.md) | Entity definitions, relationships, ER diagram |
| [Components](./backend/components.md) | System components and responsibilities |
| [External APIs](./backend/external-apis.md) | Google STT, Stripe, Tanzil.net integrations |
| [Core Workflows](./backend/core-workflows.md) | Sequence diagrams for key user journeys |
| [API Specification](./backend/api-spec.md) | REST endpoints and schemas |
| [Database Schema](./backend/database-schema.md) | PostgreSQL tables and indexes |
| [Source Tree](./backend/source-tree.md) | Project folder structure |
| [Infrastructure](./backend/infrastructure.md) | Deployment, environments, CI/CD |
| [Error Handling](./backend/error-handling.md) | Error strategy and logging |
| [Coding Standards](./backend/coding-standards.md) | Development standards and rules |
| [Testing](./backend/testing.md) | Test strategy and coverage goals |
| [Security](./backend/security.md) | Security requirements and controls |

### Frontend Architecture

| Document | Description |
|----------|-------------|
| [Frontend Overview](./frontend/overview.md) | Framework selection, key decisions |
| [Tech Stack](./frontend/tech-stack.md) | Flutter packages and versions |
| [Project Structure](./frontend/project-structure.md) | Directory layout, clean architecture |
| [State Management](./frontend/state-management.md) | Riverpod patterns and examples |
| [Routing](./frontend/routing.md) | go_router, deep linking |
| [Component Standards](./frontend/component-standards.md) | Templates, naming conventions |
| [API Integration](./frontend/api-integration.md) | Service patterns, HTTP client |
| [Styling](./frontend/styling.md) | Theme, colors, typography |
| [Testing](./frontend/testing.md) | Flutter testing approach |
| [Developer Standards](./frontend/developer-standards.md) | Coding rules and best practices |

### Validation

| Document | Description |
|----------|-------------|
| [Checklist Results](./checklist-results.md) | Architecture validation report |

---

## Related Documents

| Document | Location | Purpose |
|----------|----------|---------|
| **PRD** | [`docs/prd/`](../prd/index.md) | Product requirements and epics |
| **Project Brief** | [`docs/brief.md`](../brief.md) | Original project brief |

### Archived Decision-Making Documents

| Document | Location | Purpose |
|----------|----------|---------|
| **STT Provider Decision** | [`azure-stt-quick-summary.md.archive`](../archive/decision-making/azure-stt-quick-summary.md.archive) | Google vs Azure STT comparison |
| **STT Test Results** | [`azure-stt-test-results.md.archive`](../archive/decision-making/azure-stt-test-results.md.archive) | Detailed STT testing analysis |
| **UI/UX Specification** | [`front-end-spec.md.archive`](../archive/decision-making/front-end-spec.md.archive) | Original screens, flows, visual design |
| **Quran Database Setup** | [`setup-quran-database.md.archive`](../archive/decision-making/setup-quran-database.md.archive) | Database setup guide |

---

## Change Log

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| 2026-02-10 | 2.0 | Sharded architecture into separate files | Winston (Architect) |
| 2026-02-10 | 1.0 | Initial architecture document | Winston (Architect) |
