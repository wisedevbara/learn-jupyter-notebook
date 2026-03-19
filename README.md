# Data Science Jupyter Environment

Environment pengembangan data science menggunakan Docker dengan JupyterLab untuk analisis data dan pemodelan matematika.

## Arsitektur Sistem

```
┌─────────────────────────────────────────────────────────────┐
│                    Host Machine (localhost)                   │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │              Docker Container                          │  │
│  │  ┌──────────────────────────────────────────────────┐ │  │
│  │  │           JupyterLab / Jupyter Notebook          │ │  │
│  │  │                                                   │ │  │
│  │  │  ┌─────────────┐  ┌─────────────┐  ┌──────────┐ │ │  │
│  │  │  │   Python    │  │   Conda     │  │  Jupyter  │ │ │  │
│  │  │  │   Kernel    │  │  Environment│  │   Core   │ │ │  │
│  │  │  └─────────────┘  └─────────────┘  └──────────┘ │ │  │
│  │  │                                                   │ │  │
│  │  │  ┌─────────────────────────────────────────────┐ │ │  │
│  │  │  │     Scientific Stack & Data Science        │ │ │  │
│  │  │  │  (numpy, pandas, sklearn, tensorflow, etc)  │ │ │  │
│  │  │  └─────────────────────────────────────────────┘ │ │  │
│  │  └──────────────────────────────────────────────────┘ │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │              Volume Mounts (Local Storage)             │  │
│  │  ├── notebooks/  →  /home/hirakusan/work                  │  │
│  │  ├── data/       →  /home/hirakusan/data                 │  │
│  │  ├── src/        →  /home/hirakusan/src                  │  │
│  │  ├── models/     →  /home/hirakusan/models               │  │
│  │  └── logs/       →  /home/hirakusan/logs                  │  │
│  └────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Fitur

- **JupyterLab** - Interface interaktif untuk data science
- **Python 3.13** - Runtime dengan versi terbaru
- **Conda Environment** - Isolasi package yang optimal
- **Scientific Stack** - NumPy, Pandas, Scikit-learn, Matplotlib, dll
- **Volume Mounts** - Data dan notebook tersimpan di local

## Quick Start

### Prerequisites

- Docker Engine >= 29.2.1
- Docker Compose >= 2.0
- Memory >= 8GB (16GB recommended)
- Disk Space >= 20GB

### Installation

1. Clone repository:
```bash
git clone <repository-url>
cd python_jupyter_notebook
```

2. Setup environment variables:
```bash
cp docker/.env.example .env
# Edit .env dengan nilai yang sesuai
```

3. Start container:
```bash
docker-compose up -d
```

4. Access JupyterLab:
- URL: http://localhost:8889
- Token: Lihat di `.env` file (JUPYTER_TOKEN)

### Stop Container

```bash
docker-compose down
```

## Struktur Direktori

```
python_jupyter_notebook/
├── docker/              # Docker configuration
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── .env.example
├── data/               # Data files
│   ├── raw/            # Data mentah
│   ├── processed/      # Data yang sudah diolah
│   └── intermediate/   # Data interim
├── notebooks/          # Jupyter notebooks
│   ├── exploratory/    # Eksplorasi data
│   ├── models/        # Pemodelan
│   ├── reports/       # Laporan
│   └── utils/        # Utility notebooks
├── src/               # Source code
│   ├── modules/       # Python modules
│   │   ├── data/
│   │   ├── features/
│   │   ├── models/
│   │   └── visualization/
│   └── scripts/       # Scripts
│       ├── etl/
│       ├── training/
│       └── evaluation/
├── models/            # Trained models
│   ├── checkpoints/
│   ├── trained/
│   └── metrics/
├── logs/              # Log files
│   ├── execution/
│   ├── mlflow/
│   └── tensorboard/
├── requirements/      # Python dependencies
│   ├── base.txt
│   ├── ml.txt
│   └── dev.txt
├── configs/           # Configuration files
├── tests/             # Test files
│   ├── unit/
│   ├── integration/
│   └── fixtures/
├── docs/              # Documentation
├── script/            # Automation scripts
├── plans/             # Project plans
├── notebooks_backup/  # Backup notebooks
├── Makefile           # Development commands
└── README.md          # Project documentation
```

## Package yang Tersedia

### Core Scientific Stack (Pre-installed)
| Package | Version | Description |
|---------|---------|-------------|
| numpy | ~1.26.0 | Numerical computing |
| scipy | ~1.12.0 | Scientific computing |
| pandas | ~2.1.0 | Data manipulation & analysis |
| matplotlib | ~3.8.0 | Data visualization |
| seaborn | ~0.13.0 | Statistical visualization |
| scikit-learn | ~1.4.0 | Machine learning |
| jupyterlab | ~4.0.0 | Interactive computing UI |
| notebook | ~7.0.0 | Classic notebook UI |
| ipython | ~8.20.0 | Interactive Python shell |
| ipywidgets | ~8.1.0 | Interactive widgets |

### Additional Pre-installed Packages
| Package | Version | Description |
|---------|---------|-------------|
| scikit-image | ~0.22.0 | Image processing |
| statsmodels | ~0.14.0 | Statistical models |
| sympy | ~1.12.0 | Symbolic mathematics |
| networkx | ~3.2.0 | Network analysis |
| bokeh | ~3.3.0 | Interactive visualization |
| numba | ~0.59.0 | JIT compiler |
| ipykernel | ~6.28.0 | Jupyter kernel |

### ML Packages (optional)
| Package | Version |
|---------|---------|
| tensorflow | >=2.15.0 |
| pytorch | >=2.1.0 |
| xgboost | >=2.0.0 |
| lightgbm | >=4.1.0 |

### Development Tools (optional)
| Package | Version |
|---------|---------|
| black | >=24.1.0 |
| flake8 | >=7.0.0 |
| pytest | >=8.0.0 |

## Konfigurasi

### Port

| Port | Service | Status |
|------|---------|--------|
| 8889 | JupyterLab (primary) | ✅ Active (localhost only) |
| 8888 | Classic Notebook | ❌ Disabled (commented out) |

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| JUPYTER_TOKEN | Token untuk akses Jupyter | (required) |
| JUPYTER_PASSWORD | Password (optional) | - |
| NB_USER | Username | hirakusan |
| NB_UID | User ID | 1000 |
| NB_GID | Group ID | 1000 |
| GRANT_SUDO | Sudo access | no |
| JUPYTER_ENABLE_LAB | Enable JupyterLab | yes |
| TZ | Timezone | Asia/Jakarta |
| LANG | Language | en_US.UTF-8 |
| LC_ALL | Locale | en_US.UTF-8 |

## Commands

Gunakan Makefile untuk commands cepat:

### Docker Commands
```bash
make up           # Start container
make down         # Stop container
make restart      # Restart container
make logs         # View logs (last 100 lines)
make logs-follow  # Follow logs in real-time
make build        # Build container image
make rebuild      # Rebuild with latest image
make clean        # Remove container and volumes
```

### Development Commands
```bash
make shell        # Access container shell
make shell-root   # Access container as root
make install-deps # Install dependencies
make update-deps  # Update all packages
```

### Data Commands
```bash
make backup       # Backup all data
make restore      # Restore from backup
make clean-data   # Clean data files
```

### Monitoring Commands
```bash
make status       # Check container status
make stats        # Check resource usage
```

## Keamanan

- Container running sebagai non-root user (hirakusan)
- Akses menggunakan token/password
- Secrets disimpan di .env file (tidak di-commit)
- Grant sudo: disabled

## Troubleshooting

Lihat [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) untuk solusi masalah umum.

---

## CI/CD Pipeline

Proyek ini menggunakan GitHub Actions untuk otomatisasi CI/CD.

### Pipeline Stages

| Stage | Description | Tools |
|-------|-------------|-------|
| Setup | Environment preparation | Python 3.13, Docker |
| Test | Unit tests with coverage | pytest, coverage |
| Security | Code & container scanning | Bandit, Trivy, Grype |
| Build | Docker image build | Docker Buildx |
| Integration | Container testing | Docker |
| Registry | Push to registry | GHCR, Docker Hub |
| Staging | Deploy to staging | Manual |
| Production | Deploy to production | Manual approval |

### Menjalankan Pipeline

#### Local Development

```bash
# Clone repository
git clone <repository-url>
cd python_jupyter_notebook

# Install dependencies
pip install -r requirements/dev.txt

# Run tests locally
pytest tests/ --cov=src --cov-report=html

# Security scan
bandit -r src/

# Build Docker image
docker build -t jupyter-datascience:latest -f docker/Dockerfile .

# Run container
docker run -d -p 8889:8888 -e JUPYTER_TOKEN=dev-token jupyter-datascience:latest
```

#### GitHub Actions

Pipeline berjalan otomatis pada:
- Push ke branch `main` atau `develop`
- Pull request ke `main`
- Manual trigger via GitHub UI

```bash
# Manual trigger via CLI
gh workflow run ci-cd.yml -f environment=staging
```

### Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| GITHUB_TOKEN | GitHub token | Yes (auto) |
| DOCKERHUB_USERNAME | Docker Hub username | No |
| DOCKERHUB_PASSWORD | Docker Hub password | No |
| SLACK_WEBHOOK | Slack notification | No |

### Artifacts

Pipeline menghasilkan artifact:
- `bandit-report.json` - Code security scan results
- `trivy-report.json` - Container vulnerability scan
- `grype-report.json` - Additional vulnerability assessment
- `coverage.xml` - Test coverage reports

### Deployment Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Commit    │────▶│    Test     │────▶│   Security  │
└─────────────┘     └─────────────┘     └─────────────┘
                                                │
                                                ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Production  │◀────│  Approval   │◀────│  Staging    │
│   (Manual)  │     │   Gate      │     │  Deploy     │
└─────────────┘     └─────────────┘     └─────────────┘
       │
       ▼
┌─────────────┐
│   Rollback  │ (on failure)
└─────────────┘
```

## Lisensi

Lihat [LICENSE](LICENSE) untuk detail.