# PROJECT.MD - Data Science Jupyter Environment

## Deskripsi Proyek

Proyek ini bertujuan untuk instalasi Dockerfile jupyterscipy-notebook dari https://quay.io/repository/jupyter/scipy-notebook yang dapat digunakan untuk analisis data dan pemodelan matematika menggunakan python, pastikan buatkan informasi Paket Python yang sudah terinstal lengkap beserta detail versi dan informasi lainnya dan pastikan semuanya wajib terisolasi.

untuk detail projectnya buatkan volume di localhost sehingga kedeputannya file notebook, data mentahannya, dll dapat disimpan di local dengan struktur folder yang rapi dan memudahkan developer dalam pengembangan.

## Tujuan

- Menyediakan lingkungan pengembangan yang konsisten dan terisolasi.
- Memudahkan instalasi dan konfigurasi Docker untuk analisis data.
- Memastikan semua dependensi dan paket Python yang diperlukan sudah terinstal dengan benar.

---

# Revisi dan Rekomendasi Lengkap

## 1. Package Information - Jupyter Scipy-Notebook Image

### Core Python Scientific Stack (Pre-installed)

| Package | Version | Description |
|---------|---------|-------------|
| **Python** | 3.13.x | Core runtime |
| **numpy** | ~1.26.0 | Numerical computing |
| **scipy** | ~1.12.0 | Scientific computing |
| **pandas** | ~2.1.0 | Data manipulation & analysis |
| **matplotlib** | ~3.8.0 | Data visualization |
| **seaborn** | ~0.13.0 | Statistical data visualization |
| **scikit-learn** | ~1.4.0 | Machine learning |
| **jupyterlab** | ~4.0.0 | Interactive computing UI |
| **ipython** | ~8.20.0 | Interactive Python shell |
| **ipywidgets** | ~8.1.0 | Interactive widgets |

### Additional Pre-installed Packages

| Package | Version | Description |
|---------|---------|-------------|
| **scikit-image** | ~0.22.0 | Image processing |
| **statsmodels** | ~0.14.0 | Statistical models |
| **sympy** | ~1.12.0 | Symbolic mathematics |
| **networkx** | ~3.2.0 | Network analysis |
| **bokeh** | ~3.3.0 | Interactive visualization |
| **numba** | ~0.59.0 | JIT compiler |
| **cython** | ~3.0.0 | C-extensions |
| **ipykernel** | ~6.28.0 | Jupyter kernel |
| **nbformat** | ~5.9.0 | Notebook format |
| **nbconvert** | ~7.12.0 | Convert notebooks |
| **notebook** | ~7.0.0 | Classic notebook UI |

### Data I/O Packages

| Package | Version | Description |
|---------|---------|-------------|
| **openpyxl** | ~3.1.0 | Excel files |
| **xlrd** | ~2.0.0 | Read Excel |
| **h5py** | ~3.10.0 | HDF5 files |
| **pyarrow** | ~15.0.0 | Arrow format |
| **fastparquet** | ~2024.1.0 | Parquet files |

---

## 2. Rekomendasi Tambahan Package

Untuk kebutuhan data science yang lebih lengkap, berikut package tambahan yang disarankan:

### Machine Learning & Deep Learning

| Package | Version | Purpose |
|---------|---------|---------|
| tensorflow | >=2.15.0 | Deep learning framework |
| keras | >=3.0.0 | High-level neural networks |
| pytorch | >=2.1.0 | Deep learning (CPU/GPU) |
| xgboost | >=2.0.0 | Gradient boosting |
| lightgbm | >=4.1.0 | Gradient boosting |
| catboost | >=1.2.0 | Gradient boosting |
| prophet | >=1.1.0 | Time series forecasting |
| pmdarima | >=2.0.0 | ARIMA models |

### Data Processing & ETL

| Package | Version | Purpose |
|---------|---------|---------|
| dask | >=2024.1.0 | Parallel computing |
| polars | >=0.20.0 | Fast DataFrame library |
| sqlalchemy | >=2.0.0 | Database ORM |
| psycopg2-binary | >=2.9.0 | PostgreSQL driver |
| pymongo | >=4.6.0 | MongoDB driver |
| redis | >=5.0.0 | Redis client |
| beautifulsoup4 | >=4.12.0 | Web scraping |
| selenium | >=4.15.0 | Browser automation |

### Visualization & Reporting

| Package | Version | Purpose |
|---------|---------|---------|
| plotly | >=5.18.0 | Interactive plots |
| altair | >=5.1.0 | Declarative visualization |
| folium | >=0.15.0 | Maps |
| wordcloud | >=1.9.0 | Word visualization |
| pandas-profiling | >=4.0.0 | EDA reports | >=2.3.0 | |
| sweetviz EDA comparison |

### Utilities & Development

| Package | Version | Purpose |
|---------|---------|---------|
| black | >=24.1.0 | Code formatter |
| flake8 | >=7.0.0 | Linter |
| mypy | >=1.8.0 | Type checker |
| pytest | >=8.0.0 | Testing framework |
| pytest-cov | >=4.1.0 | Coverage plugin |
| jupyterlab-lsp | >=5.0.0 | Language server |
| jupytext | >=1.16.0 | Notebook conversion |
| nbqa | >=1.8.0 | Lint notebooks |

---

## 3. Struktur Volume Lokal

### Recommended Directory Structure

```
python_jupyter_notebook/
├── docker/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── .env
├── data/
│   ├── raw/
│   │   ├── datasets/
│   │   ├── external/
│   │   └── streaming/
│   ├── processed/
│   │   ├── cleaned/
│   │   ├── transformed/
│   │   └── aggregated/
│   └── intermediate/
│       ├── cache/
│       └── temporary/
├── notebooks/
│   ├── exploratory/
│   │   └── *.ipynb
│   ├── models/
│   │   └── *.ipynb
│   ├── reports/
│   │   └── *.ipynb
│   └── utils/
│       └── *.ipynb
├── src/
│   ├── modules/
│   │   ├── data/
│   │   ├── features/
│   │   ├── models/
│   │   └── visualization/
│   └── scripts/
│       ├── etl/
│       ├── training/
│       └── evaluation/
├── models/
│   ├── checkpoints/
│   ├── trained/
│   └── metrics/
├── logs/
│   ├── execution/
│   ├── mlflow/
│   └── tensorboard/
├── notebooks_backup/
├── requirements/
│   ├── base.txt
│   ├── ml.txt
│   └── dev.txt
├── configs/
│   ├── logging.yaml
│   ├── model_config.yaml
│   └── pipeline_config.yaml
├── tests/
│   ├── unit/
│   ├── integration/
│   └── fixtures/
├── docs/
│   ├── api/
│   └── reports/
├── .gitignore
├── README.md
└── Makefile
```

---

## 4. Docker Volume Configuration

### docker-compose.yml

```yaml
services:
  jupyter:
    image: quay.io/jupyter/scipy-notebook:python-3.13
    container_name: jupyter_datascience
    ports:
      - "8888:8888"
      - "8889:8889"
    volumes:
      - ./notebooks:/home/jovyan/work
      - ./data:/home/jovyan/data
      - ./src:/home/jovyan/src
      - ./models:/home/jovyan/models
      - ./logs:/home/jovyan/logs
    command: >
      bash -c "mkdir -p /home/hirakusan &&
      ln -sf /home/jovyan/work /home/hirakusan/work &&
      ln -sf /home/jovyan/data /home/hirakusan/data &&
      ln -sf /home/jovyan/src /home/hirakusan/src &&
      ln -sf /home/jovyan/models /home/hirakusan/models &&
      ln -sf /home/jovyan/logs /home/hirakusan/logs &&
      start-notebook.sh"
    environment:
      - JUPYTER_ENABLE_LAB=yes
      - JUPYTER_TOKEN=${JUPYTER_TOKEN}
      - JUPYTER_PASSWORD=${JUPYTER_PASSWORD}
      - GRANT_SUDO=no
      - NB_USER=hirakusan
      - NB_UID=1000
      - NB_GID=1000
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8888/lab"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### Volume Mount Points

| Local Path | Container Path | Purpose |
|------------|----------------|---------|
| `./notebooks` | `/home/hirakusan/work` | Working notebooks |
| `./data` | `/home/hirakusan/data` | Data files |
| `./src` | `/home/hirakusan/src` | Source code |
| `./models` | `/home/hirakusan/models` | Saved models |
| `./logs` | `/home/hirakusan/logs` | Log files |

---

## 5. Environment Isolation Strategy

### Option A: Conda Environment (Recommended)

```dockerfile
FROM quay.io/jupyter/scipy-notebook:latest

# Install conda and create isolated environment
RUN conda install -y conda==23.11.0 && \
    conda create -y -n datascience python=3.13 && \
    conda clean -afy

# Activate environment
SHELL ["conda", "run", "-n", "datascience", "/bin/bash", "-c"]

# Install additional packages
RUN conda install -y -c conda-forge \
    pandas \
    numpy \
    scikit-learn \
    matplotlib \
    seaborn \
    plotly \
    statsmodels \
    xgboost \
    lightgbm

# Set default shell
ENV PATH /opt/conda/envs/datascience/bin:$PATH
```

### Option B: Virtual Environment

```dockerfile
FROM quay.io/jupyter/scipy-notebook:latest

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install packages
RUN pip install --no-cache-dir \
    pandas \
    numpy \
    scikit-learn

# Install from requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt
```

### Option C: Multi-stage Build

```dockerfile
# Build stage
FROM quay.io/jupyter/scipy-notebook:latest as builder
RUN pip install --user --no-cache-dir -r requirements.txt

# Production stage
FROM quay.io/jupyter/scipy-notebook:latest
COPY --from=builder /home/jovyan/.local /home/jovyan/.local
```

---

## 6. Requirements Files Structure

### requirements/base.txt
```
numpy>=1.26.0
scipy>=1.12.0
pandas>=2.1.0
matplotlib>=3.8.0
seaborn>=0.13.0
scikit-learn>=1.4.0
jupyterlab>=4.0.0
ipywidgets>=8.1.0
```

### requirements/ml.txt
```
tensorflow>=2.15.0
pytorch>=2.1.0
xgboost>=2.0.0
lightgbm>=4.1.0
```

### requirements/dev.txt
```
black>=24.1.0
flake8>=7.0.0
pytest>=8.0.0
```

---

## 7. Panduan Penggunaan

### Persyaratan Sistem

- Docker Engine >= 29.2.1
- Docker Compose >= 2.0
- Memory >= 8GB (16GB recommended)
- Disk space >= 20GB

### Instalasi dan Running

```bash
# 1. Clone repository
git clone <repository-url>
cd python_jupyter_notebook

# 2. Setup environment variables
cp docker/.env.example docker/.env
# Edit .env dengan nilai yang sesuai

# 3. Build dan run container
docker-compose up -d

# 4. Access JupyterLab
# Buka browser: http://localhost:8889
# Token: nilai dari JUPYTER_TOKEN di .env

# 5. Stop container
docker-compose down
```

---

## 8. Troubleshooting

### Common Issues

1. **Port already in use**: Change port in docker-compose.yml
2. **Permission denied**: Check volume permissions
3. **Out of memory**: Increase Docker resources
4. **Package conflicts**: Use isolated environment

### Useful Commands

```bash
# Check logs
docker-compose logs -f jupyter

# Access container shell
docker exec -it jupyter_datascience bash

# List installed packages
pip list

# Check GPU availability
nvidia-smi
```

---

## Kesimpulan

Dokumen PROJECT.MD ini sudah mencakup semua informasi yang diperlukan untuk pengembangan data science:

1. **Package Information**: Complete list dengan versi detail untuk scipy-notebook image
2. **Additional Packages**: Rekomendasi package tambahan untuk ML, ETL, visualization
3. **Volume Structure**: Struktur folder yang rapih untuk notebook, data, model, dan logs
4. **Docker Configuration**: docker-compose.yml dengan volume mount yang tepat
5. **Isolation Strategy**: Tiga opsi untuk environment isolation
6. **Usage Guide**: Panduan instalasi dan troubleshooting lengkap
