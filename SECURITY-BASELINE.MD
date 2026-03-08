# SECURITY-BASELINE.MD

## Overview

Dokumen ini menetapkan standar keamanan untuk Data Science Jupyter Environment menggunakan Docker container. Baseline ini derived dari PROJECT.MD dan ARCHITECTURE.MD yang telah dibuat.

---

## 1. Security Principles

### 1.1 Core Security Principles

- **Defense in Depth**: Multiple layers of security controls
- **Least Privilege**: Minimal permissions required for operation
- **Zero Trust**: Never trust, always verify
- **Fail Secure**: Default to secure state on failure

### 1.2 Security Objectives

| Objective | Description | Priority |
|-----------|-------------|----------|
| Confidentiality | Protect sensitive data from unauthorized access | High |
| Integrity | Ensure data and system integrity | High |
| Availability | Maintain system availability | Medium |
| Accountability | Track and audit all activities | Medium |

---

## 2. Container Security

### 2.1 Image Security

**Base Image Requirements**:
- Use official `quay.io/jupyter/scipy-notebook:python-3.13` image
- Regularly update to latest stable version
- Scan image for vulnerabilities before deployment

**Image Hardening**:
```yaml
# Security recommendations for Dockerfile
- Remove unnecessary packages
- Run as non-root user (hirakusan)
- Use read-only root filesystem where possible
- Enable security features
```

### 2.2 Container Runtime Security

| Control | Requirement | Implementation |
|---------|-------------|----------------|
| User | Run as non-root (hirakusan UID 1000) | NB_USER=hirakusan in docker-compose |
| Privileged | Never run in privileged mode | Remove --privileged flag |
| Capabilities | Drop all capabilities | security_opt seccomp profile |
| Network | Use custom network | docker network create |
| Resource limits | Set memory/CPU limits | mem_limit, cpu_shares |

### 2.3 Container Isolation

```
Container Security Layers:
┌─────────────────────────────────────────┐
│         Network Isolation               │
│    (Custom network, port restrictions)  │
├─────────────────────────────────────────┤
│         Resource Limits                 │
│    (Memory, CPU, disk quotas)           │
├─────────────────────────────────────────┤
│         User Permissions                │
│    (Non-root, read-only where possible)│
├─────────────────────────────────────────┤
│         Image Security                  │
│    (Official image, vulnerability scan) │
└─────────────────────────────────────────┘
```

---

## 3. Access Control

### 3.1 Authentication

**Jupyter Authentication**:
| Method | Security Level | Implementation |
|--------|----------------|----------------|
| Token | Medium | JUPYTER_TOKEN environment variable |
| Password | High | JUPYTER_PASSWORD with hashed password |
| JWT Token | Very High | For production deployments |

**Recommended Configuration**:
```yaml
environment:
  - JUPYTER_TOKEN=<secure-random-token>
  - JUPYTER_PASSWORD=<hashed-password>
  - GRANT_SUDO=no
```

### 3.2 User Management

| User Type | Permissions | Use Case |
|-----------|-------------|----------|
| hirakusan (default) | Read/Write to mounted volumes | Development |
| Read-only | Read-only access | Production viewing |

### 3.3 API Access Control

```
Access Control Flow:
┌──────────────┐
│   Request    │
└──────┬───────┘
       │
       ▼
┌──────────────┐     ┌──────────────┐
│  Token/Auth  │────▶│   Validate   │
│   Check      │     │   Credentials│
└──────────────┘     └──────┬───────┘
                             │
              ┌──────────────┴──────────────┐
              │                             │
              ▼                             ▼
       ┌──────────────┐              ┌──────────────┐
       │   Allowed    │              │    Denied    │
       │   Access     │              │   Request    │
       └──────────────┘              └──────────────┘
```

---

## 4. Network Security

### 4.1 Port Configuration

| Port | Service | Access | Security |
|------|---------|--------|----------|
| 8889 | JupyterLab | External | Token required |
| 8888 | Classic Notebook | Internal only | Token required |

### 4.2 Network Segmentation

**Development Environment**:
```yaml
# docker-compose.yml
ports:
  - "8889:8888"  # JupyterLab - localhost only
```

**Production Environment**:
```yaml
# With reverse proxy
ports:
  - "127.0.0.1:8889:8888"  # Only localhost
```

### 4.3 Network Policies

| Policy | Description |
|--------|-------------|
| Ingress | Restrict access to localhost or VPN |
| Egress | Allow outbound for package installation |
| Internal | Container-to-container communication if needed |

---

## 5. Data Security

### 5.1 Data Classification

| Classification | Description | Handling |
|----------------|-------------|----------|
| Public | No restrictions | Standard storage |
| Internal | Organization data | Volume encryption |
| Confidential | Sensitive data | Encrypted, access controlled |
| Restricted | Highly sensitive | Not stored in container |

### 5.2 Volume Security

**Volume Permissions**:
```yaml
volumes:
  - ./notebooks:/home/hirakusan/work:ro  # Read-only where possible
  - ./data:/home/hirakusan/data:rw       # Read-write for data
  - ./logs:/home/hirakusan/logs:rw       # Read-write for logs
```

**Mount Point Security**:
| Volume | Container Path | Permissions | Notes |
|--------|----------------|-------------|-------|
| notebooks | /home/hirakusan/work | RW | User notebooks |
| data | /home/hirakusan/data | RW | Raw data |
| src | /home/hirakusan/src | RW | Source code |
| models | /home/hirakusan/models | RW | Trained models |
| logs | /home/hirakusan/logs | RW | Application logs |

### 5.3 Data Encryption

| Data State | Protection Method |
|------------|-------------------|
| In Transit | TLS/SSL for external connections |
| At Rest | Host-level encryption (LUKS, BitLocker) |
| In Memory | Secure coding practices |

---

## 6. Secrets Management

### 6.1 Environment Variables

**DO NOT** store secrets directly in docker-compose.yml:
```yaml
# WRONG - Exposes secrets
environment:
  - JUPYTER_PASSWORD=mysecretpassword
```

**USE** environment files or secrets management:
```yaml
# CORRECT - Use environment file
env_file:
  - .env

# .env file (add to .gitignore)
JUPYTER_TOKEN=secure-random-token
```

### 6.2 Secrets Storage Hierarchy

```
Secrets Priority:
1. Kubernetes Secrets / Docker Secrets
2. HashiCorp Vault
3. Environment files (.env)
4. Configuration files (last resort)
```

### 6.3 .gitignore Requirements

```gitignore
# Essential ignores for security
.env
*.log
*.key
*.pem
credentials.json
secrets/
```

---

## 7. Logging & Monitoring

### 7.1 Security Logging

| Event | Log | Retention |
|-------|-----|-----------|
| Authentication | Success/Failure | 90 days |
| Access attempts | All | 30 days |
| Configuration changes | All | 1 year |
| Errors | All | 30 days |

### 7.2 Audit Requirements

```yaml
# Audit checklist
- [ ] Login attempts logged
- [ ] Failed authentication logged
- [ ] Configuration changes tracked
- [ ] Volume access logged
- [ ] Network connections logged
```

### 7.3 Monitoring Alerts

| Alert Type | Threshold | Action |
|------------|-----------|--------|
| Failed logins | >5 in 10 min | Notify admin |
| Unusual access | Anomaly detection | Block IP |
| Resource usage | >90% CPU | Scale/resources |
| Container restart | Any | Investigate |

---

## 8. Vulnerability Management

### 8.1 Image Scanning

**Required Scans**:
- Pre-deployment vulnerability scan
- Regular dependency updates
- CVE monitoring

**Tools Integration**:
```yaml
# Example: Trivy scan command
trivy image quay.io/jupyter/scipy-notebook:latest
```

### 8.2 Patch Management

| Priority | Response Time |
|----------|---------------|
| Critical (CVSS 9-10) | 24 hours |
| High (CVSS 7-8.9) | 7 days |
| Medium (CVSS 4-6.9) | 30 days |
| Low (CVSS <4) | Next release |

### 8.3 Dependency Management

```yaml
# Update strategy
- Weekly: Check for updates
- Monthly: Apply security patches
- Quarterly: Full dependency review
```

---

## 9. Compliance Considerations

### 9.1 Applicable Standards

| Standard | Applicability | Requirements |
|----------|---------------|--------------|
| GDPR | Personal data | Data protection, privacy |
| SOC 2 | Production use | Access control, logging |
| ISO 27001 | Enterprise | Security management |

### 9.2 Compliance Checklist

- [ ] Access control implemented
- [ ] Encryption at rest and in transit
- [ ] Audit logging enabled
- [ ] Incident response plan
- [ ] Regular security assessments
- [ ] Data backup and recovery

---

## 10. Incident Response

### 10.1 Security Incidents

| Incident Type | Severity | Response Time |
|---------------|----------|---------------|
| Data breach | Critical | Immediate |
| Unauthorized access | High | 1 hour |
| Malware detection | Critical | Immediate |
| Service outage | Medium | 4 hours |

### 10.2 Response Procedures

```
Incident Response Flow:
┌──────────────┐
│   Detect      │◄── Monitoring alerts
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Analyze    │◄── Investigate root cause
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Contain    │◄── Isolate affected systems
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Eradicate  │◄── Remove threat
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Recover    │◄── Restore services
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Lessons    │◄── Document findings
│   Learned    │
└──────────────┘
```

---

## 11. Security Checklist

### Pre-Deployment

- [ ] Base image updated and scanned
- [ ] Non-root user configured
- [ ] Authentication enabled (token/password)
- [ ] Network access restricted
- [ ] Secrets stored securely
- [ ] Volumes configured with appropriate permissions
- [ ] Logging enabled
- [ ] Backup strategy defined

### Production

- [ ] Regular security scans
- [ ] Monitoring and alerting active
- [ ] Incident response plan tested
- [ ] Access reviews scheduled
- [ ] Dependencies up to date

---

## 12. References

- Docker Security Best Practices: https://docs.docker.com/engine/security/
- Jupyter Security: https://jupyter-notebook.readthedocs.io/en/stable/security.html
- NIST Container Security Guide
- CIS Docker Benchmark

---

## Summary

Security baseline ini menetapkan controls minimum untuk deployment Data Science Jupyter Environment. Semua control harus diimplementasikan sesuai dengan tingkat sensitivity data dan environment (development/production).

| Category | Priority | Implementation |
|----------|----------|----------------|
| Container Security | High | Required |
| Access Control | High | Required |
| Network Security | High | Required |
| Data Security | High | Required |
| Secrets Management | High | Required |
| Logging & Monitoring | Medium | Recommended |
| Vulnerability Management | High | Required |
| Compliance | Medium | As needed |
| Incident Response | Medium | Recommended |
