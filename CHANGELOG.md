# CHANGELOG - Data Science Jupyter Environment

Semua notable changes akan didokumentasikan di file ini.

Format berdasarkan [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

---

## [1.1.0] - 2026-03-09

### Added
- **Jupyter Notebook Deployment**
  - Jupyter Notebook successfully deployed and running in Docker
  - Container started successfully
  - JupyterLab accessible on port 8889
  - Volume mounts working (notebooks, data, src, models, logs)
  - Authentication configured (token-based)

- **Initial project setup**
- **Docker configuration files**
- **Documentation structure**

---

## [1.0.0] - 2024-01-01

### Added
- **Docker Environment**
  - docker-compose.yml configuration
  - JupyterLab with Python 3.13
  - Non-root user (hirakusan) configuration
  - Volume mounts for data, notebooks, models, logs

- **Documentation**
  - PROJECT.MD - Project specifications
  - ARCHITECTURE.MD - System architecture
  - SECURITY-BASELINE.md - Security controls
  - PRE-FLIGHT-EXECUTION-PLAN.MD - Implementation plan
  - PRODUCTION-READINESS-ASSESSMENT.MD - Readiness evaluation

- **Operational Documentation**
  - README.md - Quick start guide
  - RUNBOOK.md - Operational procedures
  - TROUBLESHOOTING.md - Problem solving
  - CHANGELOG.md - Version history

- **Configuration Files**
  - .env.example - Environment template
  - Makefile - Shortcut commands
  - .gitignore - Git ignore patterns

### Features
- JupyterLab access on port 8889
- Classic Notebook on port 8888
- Symlinks from /home/jovyan/ to /home/hirakusan/
- Token-based authentication
- Health check configuration

### Security
- Non-root user (hirakusan, UID 1000)
- GRANT_SUDO=no
- Environment-based secrets
- .gitignore configured for sensitive files

### Volume Structure
```
data/
├── raw/           # Raw data files
├── processed/     # Processed data
└── intermediate/  # Temporary data

notebooks/
├── exploratory/   # EDA notebooks
├── models/        # Model development
└── reports/       # Analysis reports

src/
├── modules/       # Python modules
└── scripts/       # Utility scripts

models/
├── checkpoints/   # Model checkpoints
├── trained/      # Trained models
└── metrics/      # Model metrics

logs/
├── execution/    # Execution logs
├── mlflow/      # MLflow logs
└── tensorboard/  # TensorBoard logs
```

---

## Versioning

We use [SemVer](http://semver.org/) for versioning.

- **MAJOR** - Breaking changes
- **MINOR** - New features
- **PATCH** - Bug fixes

---

## Migration Guides

### Upgrade to v1.0.0

1. Copy .env.example to .env
2. Update JUPYTER_TOKEN
3. Run `docker-compose up -d`
4. Access JupyterLab at http://localhost:8889

---

## Contributors

| Role | Name |
|------|------|
| Project Manager | [TBD] |
| DevOps Lead | [TBD] |
| Data Scientist | [TBD] |

---

## Contact

Untuk pertanyaan atau kontribusi, silakan buat issue di repository.