# ARCHITECTURE.MD

## Overview

Dokumen ini menjelaskan arsitektur teknis untuk Data Science Jupyter Environment menggunakan Docker container.

---

## 1. System Architecture

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

---

## 2. Component Design

### 2.1 Container Image

**Base Image**: `quay.io/jupyter/scipy-notebook:python-3.13`

**Rationale**:
- Pre-built dengan scientific Python stack
- Regular updates dari Jupyter community
- Tested dan stable untuk production use

### 2.2 Environment Isolation

**Primary**: Conda Environment

```
Container
├── Base Python (system)
│   └── conda environments/
│       └── datascience/          # Isolated environment
│           ├── python 3.13.x
│           ├── numpy, pandas, sklearn
│           ├── tensorflow, pytorch
│           └── custom packages
```

### 2.3 Volume Strategy

| Volume | Path | Purpose | Persistence |
|--------|------|---------|-------------|
| notebooks | /home/hirakusan/work | Active notebooks | Long-term |
| data | /home/hirakusan/data | Raw & processed data | Long-term |
| src | /home/hirakusan/src | Source code | Version controlled |
| models | /home/hirakusan/models | Trained models | Long-term |
| logs | /home/hirakusan/logs | Execution logs | Short-term |

---

## 3. Data Flow Architecture

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Raw Data   │────▶│  Processing  │────▶│   Models     │
│   (data/)    │     │  (notebooks) │     │  (models/)   │
└──────────────┘     └──────────────┘     └──────────────┘
                            │
                            ▼
                     ┌──────────────┐
                     │   Reports     │
                     │  (notebooks)  │
                     └──────────────┘
```

### Data Pipeline

1. **Ingestion**: External data → `data/raw/`
2. **Processing**: Jupyter notebooks → `data/processed/`
3. **Training**: Models → `models/trained/`
4. **Evaluation**: Metrics & reports → `logs/` & `notebooks/reports/`

---

## 4. Security Architecture

### 4.1 Authentication

```
Jupyter Token/Password
       │
       ▼
┌──────────────┐
│  JWT Token   │
│  Validation  │
└──────────────┘
       │
       ▼
┌──────────────┐
│  JupyterLab  │
│  Access      │
└──────────────┘
```

### 4.2 Container Security

- **Non-root user**: hirakusan (UID 1000)
- **Read-only base**: Where possible
- **No sensitive data**: In container images

---

## 5. Network Architecture

```
localhost:8889  ──▶  Container:8888  (JupyterLab)
localhost:8888  ──▶  Container:8888  (Classic Notebook)
```

### Port Mapping

| Host Port | Container Port | Service |
|-----------|-----------------|---------|
| 8889 | 8888 | JupyterLab (primary) |
| 8888 | 8888 | Classic Notebook |

---

## 6. Deployment Architecture

### Development Environment

```
┌─────────────────┐     ┌─────────────────┐
│   Developer     │     │   Docker Host   │
│   (Local PC)    │────▶│   (localhost)   │
│                 │     │                 │
│  - VSCode       │     │  - Container    │
│  - Git          │     │  - Volumes      │
└─────────────────┘     └─────────────────┘
```

### Production Environment

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│    Users        │────▶│  Reverse Proxy  │────▶│  Docker Host    │
│  (Browser)      │     │  (nginx/traefik)│     │  (Container)    │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

---

## 7. Scalability Considerations

### Horizontal Scaling

- Multiple container instances
- Shared network filesystem (NFS)
- Load balancer integration

### Vertical Scaling

- Increase container resources
- Memory optimization
- GPU acceleration

---

## 8. Monitoring & Logging

### Metrics Collection

```
┌──────────────┐
│  Container   │
│  Metrics     │
└──────┬───────┘
       │
       ▼
┌──────────────┐     ┌──────────────┐
│   Prometheus  │────▶│    Grafana    │
└──────────────┘     └──────────────┘
```

### Log Management

- Container logs → stdout/stderr
- Application logs → `/home/hirakusan/logs/`
- ML tracking → MLflow / TensorBoard

---

## 9. Backup & Recovery

### Backup Strategy

```
┌─────────────────┐
│   Production   │
│   Data         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ┌─────────────────┐
│   Backup        │────▶│   Storage       │
│   (tar/zip)    │     │   (S3/GCS/etc)  │
└─────────────────┘     └─────────────────┘
```

### Recovery Plan

1. Restore volume from backup
2. Rebuild container image
3. Verify data integrity

---

## 10. Technology Stack Summary

| Category | Technology |
|----------|------------|
| Container | Docker |
| Orchestration | Docker Compose |
| Base Image | quay.io/jupyter/scipy-notebook |
| Environment | Conda |
| Notebook | JupyterLab / Jupyter Notebook |
| Language | Python 3.13 |
| Version Control | Git |

---

## 11. Implementation Checklist

- [ ] Create Docker configuration files
- [ ] Setup volume directories
- [ ] Configure environment variables
- [ ] Build and test container
- [ ] Setup backup strategy
- [ ] Configure monitoring
- [ ] Document deployment process
