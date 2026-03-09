# Data Science Jupyter Environment

Environment pengembangan data science menggunakan Docker dengan JupyterLab untuk analisis data dan pemodelan matematika.

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
├── docker-compose.yml    # Docker Compose configuration
├── docker/              # Konfigurasi Docker
│   ├── Dockerfile
│   └── .env.example
├── data/               # Data files
│   ├── raw/           # Data mentah
│   ├── processed/    # Data yang sudah diolah
│   └── intermediate/ # Data interim
├── notebooks/         # Jupyter notebooks
│   ├── exploratory/  # Eksplorasi data
│   ├── models/       # Pemodelan
│   └── reports/      # Laporan
├── src/              # Source code
│   ├── modules/     # Python modules
│   └── scripts/     # Scripts
├── models/           # Model trained
├── logs/             # Log files
└── docs/             # Dokumentasi
```

## Package yang Tersedia

### Core Packages
- numpy, scipy, pandas
- matplotlib, seaborn
- scikit-learn
- jupyterlab, notebook

### ML Packages (optional)
- tensorflow, pytorch
- xgboost, lightgbm

## Konfigurasi

### Port

| Port | Service |
|------|---------|
| 8889 | JupyterLab (primary) |
| 8888 | Classic Notebook |

### Environment Variables

| Variable | Description |
|----------|-------------|
| JUPYTER_TOKEN | Token untuk akses Jupyter |
| JUPYTER_PASSWORD | Password (optional) |
| NB_USER | Username (default: hirakusan) |

## Commands

Gunakan Makefile untuk commands cepat:

```bash
make up        # Start container
make down      # Stop container
make logs      # View logs
make restart   # Restart container
make clean     # Remove container dan volumes
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