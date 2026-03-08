# Git Setup Commands

Ini adalah perintah-perintah Git yang diperlukan untuk setup project ini.

---

## 1. Initialize Repository

```bash
# Initialize git (jika belum ada)
git init

# Atau clone existing repository
git clone <repository-url>
cd python_jupyter_notebook
```

---

## 2. Configure Git

```bash
# Set username dan email
git config user.name "wisedevbara"
git config user.email "wisedev@atomicmail.io"

# Set default branch ke main
git config init.defaultBranch main
```

---

## 3. Stage Files

```bash
# Add all files
git add .

# Atau add specific files
git add README.md CHANGELOG.md LICENSE
git add Makefile .gitignore
git add docker/
git add docs/
git add .kilocode/rules/
```

---

## 4. Create Initial Commit

```bash
# Commit dengan pesan
git commit -m "Initial commit: Add planning documents and project structure

- Add PROJECT.MD, ARCHITECTURE.MD, SECURITY-BASELINE.MD
- Add PRE-FLIGHT-EXECUTION-PLAN.MD, PRODUCTION-READINESS-ASSESSMENT.MD
- Add README.md, RUNBOOK.md, TROUBLESHOOTING.md
- Add docker-compose.yml, Makefile
- Add .gitignore, LICENSE"
```

---

## 5. Create Remote Repository (GitHub/GitLab)

### Option A: GitHub

```bash
# Login ke GitHub
# Buat repository baru di https://github.com/new

# Add remote
git remote add origin https://github.com/wisedevbara/learn-jupyter-notebook.git

# Push ke remote
git push -u origin main
```

### Option B: GitLab

```bash
# Login ke GitLab
# Buat repository baru di https://gitlab.com/new-project

# Add remote
git remote add origin https://github.com/wisedevbara/learn-jupyter-notebook.git

# Push ke remote
git push -u origin main
```

---

## 6. Workflow Harian

### Check Status
```bash
git status
```

### Check Differences
```bash
git diff
```

### Add Perubahan
```bash
git add <file>
git add .
```

### Commit Perubahan
```bash
git commit -m "Deskripsi perubahan"
```

### Push Perubahan
```bash
git push origin main
```

### Pull Perubahan
```bash
git pull origin main
```

---

## 7. Branching (Optional)

### Create Branch Baru
```bash
git checkout -b feature/new-feature
```

### Switch Branch
```bash
git checkout main
git checkout feature/new-feature
```

### Merge Branch
```bash
git checkout main
git merge feature/new-feature
```

---

## 8. Useful Commands

### View History
```bash
git log --oneline
git log --graph --oneline --all
```

### View Branches
```bash
git branch -a
```

### Undo Perubahan (Sebelum Commit)
```bash
git checkout -- <file>
git checkout .
```

### Undo Commit (Belum di-Push)
```bash
git reset --soft HEAD~1
```

### Stash Perubahan (Sementara)
```bash
git stash
git stash pop
```

---

## Quick Reference

| Command | Fungsi |
|---------|--------|
| `git init` | Initialize repository |
| `git add .` | Stage semua file |
| `git commit -m "..."` | Commit dengan pesan |
| `git push` | Push ke remote |
| `git pull` | Pull dari remote |
| `git status` | Cek status |
| `git log` | View history |
| `git branch` | List branches |
| `git checkout -b` | Create new branch |

---

## Catatan Penting

1. **Jangan pernah commit file sensitif:**
   - `.env` (sudah di-gitignore)
   - `*.key`, `*.pem`
   - `credentials.json`

2. **Selalu pull sebelum push:**
   ```bash
   git pull origin main
   git push origin main
   ```

3. **Commit sering-sering:**
   - Setiap selesai satu task, langsung commit
   - Pesan commit harus jelas

4. **Gunakan .gitignore:**
   - Sudah disediakan di project ini
   - Pahami apa yang diignore

---

## Revision History

| Date | Changes | Author |
|------|---------|--------|
| 2024-01-01 | Initial commands | System |
