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
cp docker/.env.example docker/.env
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
├── docker/              # Konfigurasi Docker
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── .env
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

## Lisensi

Lihat [LICENSE](LICENSE) untuk detail.