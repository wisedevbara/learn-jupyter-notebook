# TROUBLESHOOTING - Data Science Jupyter Environment

Dokumen ini berisi solusi untuk masalah umum yang mungkin terjadi.

---

## 1. Container Issues

### Container Tidak Mau Start

**Gejala**: `docker-compose up` gagal atau container langsung berhenti

**Penyebab**:
- Port sudah digunakan
- Volume permissions issue
- Konfigurasi salah

**Solusi**:
```bash
# 1. Check port availability
netstat -tuln | grep 8889

# 2. Check Docker logs
docker-compose logs

# 3. Ganti port jika perlu
# Edit docker-compose.yml: ports: - "8890:8888"

# 4. Restart Docker
sudo systemctl restart docker
```

---

### Container Selalu Restart

**Gejala**: Container start tapi langsung stop

**Solusi**:
```bash
# Check exit code
docker-compose ps

# Check logs
docker-compose logs

# Hapus dan buat ulang
docker-compose down
docker-compose up -d
```

---

## 2. Akses Issues

### JupyterLab Tidak Bisa Diakses

**Gejala**: Browser tidak bisa membuka http://localhost:8889

**Solusi**:
```bash
# 1. Check container running
docker ps | grep jupyter

# 2. Check port mapping
docker port jupyter_datascience. Check firewall


# 3sudo ufw status

# 4. Allow port jika diperlukan
sudo ufw allow 8889/tcp
```

### Token Tidak Berfungsi

**Gejala**: Token dari .env tidak berfungsi

**Solusi**:
```bash
# 1. Check .env exists
ls -la docker/.env

# 2. Generate new token
openssl rand -hex 32

# 3. Update .env
nano docker/.env

# 4. Restart container
docker-compose restart
```

### Password Tidak Berfungsi

**Gejala**: Password tidak diterima

**Solusi**:
```bash
# Generate hashed password
docker exec jupyter_datascience python -c "from jupyter_server.auth import passwd; print(passwd('your_password'))"

# Copy output ke .env sebagai JUPYTER_PASSWORD
```

---

## 3. Volume Issues

### Permission Denied

**Gejala**: Cannot write to mounted volume

**Solusi**:
```bash
# Check current permissions
ls -la data/ notebooks/

# Fix permissions (HATI-HATI - ini mengubah owner)
sudo chown -R 1000:1000 data/ notebooks/ models/ logs/

# Atau jika pakai user hirakusan
sudo chown -R 1000:1000 data/ notebooks/ models/ logs/
```

### Volume Tidak Mount

**Gejala**: Direktori kosong di dalam container

**Solusi**:
```bash
# Check docker-compose.yml volumes section
# Pastikan format benar:
# volumes:
#   - ./notebooks:/home/hirakusan/work

# Verify host directory exists
ls -la notebooks/ data/

# Recreate directories if needed
mkdir -p notebooks data models logs
```

---

## 4. Performance Issues

### Out of Memory

**Gejala**: Container sering berhenti, error "Killed"

**Solusi**:
```bash
# 1. Check Docker resources
docker stats

# 2. Increase memory via Docker Desktop
# Settings > Resources > Memory > 8GB+

# 3. Limit container memory
# Edit docker-compose.yml:
# services:
#   jupyter:
#     mem_limit: 8g

# 4. Cleanup
docker system prune
```

### Disk Penuh

**Gejala**: Cannot write files, error "No space left"

**Solusi**:
```bash
# Check disk usage
docker system df

# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Remove old backups
rm -f backup-*.tar.gz

# Cleanup Jupyter cache
docker exec jupyter_datascience rm -rf ~/.cache/jupyter/
```

---

## 5. Network Issues

### Image Pull Gagal

**Gejala**: Error saat pull image

**Solusi**:
```bash
# Check internet connection
ping quay.io

# Use mirror (China)
# Edit /etc/docker/daemon.json:
# {
#   "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
# }

# Restart Docker
sudo systemctl restart docker

# Retry pull
docker-compose pull
```

### DNS Resolution Failed

**Gejala**: Cannot resolve hostnames

**Solusi**:
```bash
# Check DNS
docker exec jupyter_datascience ping -c 3 google.com

# Use Google DNS
docker exec jupyter_datascience sh -c "echo 'nameserver 8.8.8.8' >> /etc/resolv.conf"
```

---

## 6. Package Issues

### Package Conflict

**Gejala**: Import error atau package tidak ditemukan

**Solusi**:
```bash
# Akses container
docker exec -it jupyter_datascience bash

# Check installed packages
conda list
pip list

# Install package yang benar
conda install <package>
# atau
pip install <package>
```

### Package Tidak Tersedia

**Gejala**: Package yang dibutuhkan tidak ada

**Solusi**:
```bash
# Search package
conda search <package>

# Install dari conda-forge
conda install -c conda-forge <package>

# Atau dari pip
pip install <package>
```

---

## 7. Data Issues

### Data Corruption

**Gejala**: File tidak bisa dibaca

**Solusi**:
```bash
# Check file
file data/file.csv

# Restore dari backup
tar -xzvf backup-20240101.tar.gz data/

# Re-download jika dari external source
```

### Lost Notebook

**Gejala**: Notebook hilang

**Solusi**:
```bash
# Check recent files
ls -lat notebooks/

# Check git history jika sudah di-commit
git log --oneline

# Restore dari auto-save
# Jupyter menyimpan backup di .ipynb_checkpoints/
ls notebooks/.ipynb_checkpoints/
```

---

## 8. Debug Commands

### Useful Commands

```bash
# Full logs
docker-compose logs --tail=1000

# Follow logs
docker-compose logs -f

# Interactive debugging
docker exec -it jupyter_datascience bash

# Check Python version
docker exec jupyter_datascience python --version

# Check conda env
docker exec jupyter_datascience conda env list

# Check installed packages
docker exec jupyter_datascience pip list | head -20

# Check Jupyter config
docker exec jupyter_datascience jupyter --config-dir
```

---

## Getting Help

Jika masalah tidak teratasi:

1. Check logs: `docker-compose logs`
2. Check Docker status: `docker ps`
3. Restart container: `docker-compose restart`
4. Document error message
5. Contact DevOps team

---

## Revision History

| Date | Changes | Author |
|------|---------|--------|
| 2024-01-01 | Initial version | System |