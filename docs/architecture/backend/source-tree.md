# Source Tree

[Back to Architecture Index](../index.md)

---

```
lawh/
├── .github/
│   └── workflows/
│       ├── backend-ci.yml
│       ├── mobile-ci.yml
│       └── deploy.yml
│
├── backend/
│   ├── app/
│   │   ├── api/v1/
│   │   │   ├── endpoints/
│   │   │   │   ├── search.py
│   │   │   │   ├── feedback.py
│   │   │   │   ├── quran.py
│   │   │   │   ├── donations.py
│   │   │   │   └── health.py
│   │   │   └── router.py
│   │   ├── core/
│   │   │   ├── config.py
│   │   │   ├── security.py
│   │   │   └── dependencies.py
│   │   ├── services/
│   │   │   ├── stt_service.py
│   │   │   ├── matching_service.py
│   │   │   ├── quran_service.py
│   │   │   ├── stripe_service.py
│   │   │   └── geolocation_service.py
│   │   ├── repositories/
│   │   ├── models/
│   │   │   ├── domain/
│   │   │   └── schemas/
│   │   ├── data/quran.json
│   │   └── main.py
│   ├── alembic/
│   ├── tests/
│   │   ├── unit/
│   │   └── integration/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── requirements.txt
│   └── pyproject.toml
│
├── mobile/
│   ├── lib/
│   │   ├── app/
│   │   ├── features/
│   │   │   ├── recording/
│   │   │   ├── results/
│   │   │   ├── quran_reader/
│   │   │   ├── feedback/
│   │   │   ├── donation/
│   │   │   └── settings/
│   │   ├── core/
│   │   │   ├── api/
│   │   │   ├── models/
│   │   │   └── utils/
│   │   └── l10n/
│   ├── test/
│   ├── ios/
│   ├── android/
│   ├── pubspec.yaml
│   └── analysis_options.yaml
│
├── shared/
│   └── quran/
│       └── quran-uthmani.xml
│
├── scripts/
│   ├── setup_quran_data.py
│   ├── test_google_stt.dart
│   └── accuracy_test_suite.dart
│
├── docs/
│   ├── prd/
│   ├── architecture.md
│   └── stories/
│
├── infrastructure/
│   ├── environments/
│   │   ├── staging/
│   │   └── production/
│   └── modules/
│
├── .env.example
├── .gitignore
└── README.md
```
