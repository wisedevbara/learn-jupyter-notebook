# Dockerfile - Data Science Jupyter Environment
# Base image: Jupyter Scientific Notebook with Python 3.13
FROM quay.io/jupyter/scipy-notebook:python-3.13

# =============================================================================
# Metadata
# =============================================================================
LABEL maintainer="Data Science Team"
LABEL description="Data Science Jupyter Environment with Python 3.13"
LABEL version="1.0.0"

# =============================================================================
# Environment Variables
# =============================================================================
ENV JUPYTER_ENABLE_LAB=yes \
    NB_USER=hirakusan \
    NB_UID=1000 \
    NB_GID=1000 \
    GRANT_SUDO=no \
    TZ=Asia/Jakarta \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# =============================================================================
# Install Additional System Dependencies
# =============================================================================
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    vim \
    wget \
    htop \
    && rm -rf /var/lib/apt/lists/*

# =============================================================================
# Note: Base image already provides jovyan user with UID 1000
# The docker-compose.yml configures NB_USER=hirakusan for runtime
# =============================================================================

# =============================================================================
# Install Additional Python Packages (Optional)
# =============================================================================
# To install packages from requirements files, uncomment below and mount the file:
#
# Example docker-compose.yml addition:
#   volumes:
#     - ../requirements/base.txt:/home/jovyan/requirements/base.txt:ro
#
# Then in Dockerfile, uncomment:
# COPY --chown=jovyan:jovyan /home/jovyan/requirements/base.txt /home/jovyan/requirements/base.txt
# RUN pip install --no-cache-dir -r /home/jovyan/requirements/base.txt
#
# NOTE: The base image (quay.io/jupyter/scipy-notebook) already includes:
#   - numpy, scipy, pandas, matplotlib, seaborn, scikit-learn
#   - jupyterlab, ipython, ipywidgets
#   - scikit-image, statsmodels, sympy, networkx, bokeh, numba
#
# Additional packages can be installed at runtime via:
#   docker exec -it jupyter_datascience pip install <package>
#   docker exec -it jupyter_datascience conda install -c conda-forge <package>

# =============================================================================
# Create Workspace Directories
# =============================================================================
RUN mkdir -p /home/jovyan/work \
    /home/jovyan/data \
    /home/jovyan/src \
    /home/jovyan/models \
    /home/jovyan/logs

# =============================================================================
# Create Symlinks for /home/hirakusan/ paths (as per ARCHITECTURE.MD)
# Note: These symlinks work for non-mounted paths. Volume mounts from host
# will override these paths at runtime (e.g., /home/jovyan/work from compose)
# =============================================================================
RUN mkdir -p /home/hirakusan && \
    ln -sf /home/jovyan/work /home/hirakusan/work && \
    ln -sf /home/jovyan/data /home/hirakusan/data && \
    ln -sf /home/jovyan/src /home/hirakusan/src && \
    ln -sf /home/jovyan/models /home/hirakusan/models && \
    ln -sf /home/jovyan/logs /home/hirakusan/logs

# =============================================================================
# Set Default Working Directory
# =============================================================================
WORKDIR /home/hirakusan/work

# =============================================================================
# Expose Ports
# =============================================================================
EXPOSE 8888

# =============================================================================
# Health Check
# =============================================================================
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8888/lab || exit 1

# =============================================================================
# Start Jupyter Notebook
# =============================================================================
CMD ["start-notebook.sh"]
