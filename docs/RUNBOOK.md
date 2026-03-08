# RUNBOOK - Data Science Jupyter Environment

Dokumen ini berisi panduan operasional harian untuk mengelola Jupyter Environment.

---

## 1. Kontrol Container

### Start Container

```bash
# Cara 1: docker-compose
docker-compose up -d

# Cara 2: make
make up
```

### Stop Container

```bash
# Cara 1: docker-compose
docker-compose down

# Cara 2: make
make down
```

### Restart Container

```bash
# Cara 1: docker-compose
docker-compose restart

# Cara 2: make
make restart
```

### View Logs

```bash
# Semua logs
docker-compose logs -f

# Logs container tertentu
docker-compose logs -f jupyter

# Cara 2: make
make logs
```

---

## 2. Akses Container

### Akses Shell

```bash
docker exec -it jupyter_datascience bash
```

### Akses sebagai User hirakusan

```bash
docker exec -it -u hirakusan jupyter_datascience bash
```

### List Running Container

```bash
docker ps
```

---

## 3. Manajemen Data

### Backup Data

```bash
# Backup semua data
tar -czvf backup-$(date +%Y%m%d).tar.gz data/ notebooks/ models/

# Backup specific directory
tar -czvf data-backup-$(date +%Y%m%d).tar.gz data/
```

### Restore Data

```bash
# Restore semua data
tar -xzvf backup-20240101.tar.gz

# Restore specific file
tar -xzvf backup-20240101.tar.gz -C /path/to/restore
```

### Hapus Data (Caution!)

```bash
# Hapus semua data (setelah backup)
rm -rf data/raw/*
rm -rf data/processed/*
rm -rf notebooks/*.ipynb
```

---

## 4. Update & Maintenance

### Update Image

```bash
# Pull image terbaru
docker-compose pull

# Rebuild container
docker-compose up -d --build
```

### Update Packages

```bash
# Akses container
docker exec -it jupyter_datascience bash

# Update conda packages
conda update --all

# Update pip packages
pip list --outdated
pip install --upgrade <package-name>
```

### Cleanup

```bash
# Hapus unused images
docker image prune -a

# Hapus unused volumes (HATI-HATI!)
docker volume prune

# Cara 2: make
make clean
```

---

## 5. Monitoring

### Check Container Status

```bash
# Container health
docker inspect --format='{{.State.Health.Status}}' jupyter_datascience

# Resource usage
docker stats jupyter_datascience
```

### Check Disk Space

```bash
# Docker disk usage
docker system df

# Volume sizes
docker volume ls
```

### Check Logs

```bash
# Error logs only
docker-compose logs --since 1h | grep -i error

# Recent logs
docker-compose logs --tail=100
```

---

## 6. Keamanan

### Rotate Token

```bash
# Generate new token
openssl rand -hex 32

# Update .env file
nano docker/.env

# Restart container
docker-compose restart
```

### Check User Access

```bash
# Lihat user yang aktif
docker exec jupyter_datascience who
```

---

## 7. Troubleshooting

### Container Tidak Start

```bash
# Check logs
docker-compose logs

# Check port availability
netstat -tuln | grep 8889
```

### Volume Mount Error

```bash
# Check permissions
ls -la data/ notebooks/ models/

# Fix permissions
sudo chown -R 1000:1000 data/ notebooks/ models/
```

### Out of Memory

```bash
# Check memory usage
docker stats

# Increase Docker resources via Docker Desktop
```

---

## 8. Daily Checklist

| # | Task | Frequency |
|---|------|-----------|
| 1 | Check container status | Daily |
| 2 | Check disk space | Daily |
| 3 | Review logs for errors | Daily |
| 4 | Backup data | Weekly |
| 5 | Update packages | Monthly |

---

## Emergency Contacts

| Role | Contact |
|------|---------|
| DevOps Lead | [TBD] |
| Security Lead | [TBD] |

---

## Revision History

| Date | Changes | Author |
|------|---------|--------|
| 2024-01-01 | Initial version | System |