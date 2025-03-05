# Use multi-stage build
FROM ghcr.io/dbt-labs/dbt-bigquery:1.5.0 as base

# Create dbt user and set working directory
RUN useradd -ms /bin/bash dbtuser
WORKDIR /home/dbtuser

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    ssh-client \
    software-properties-common \
    make \
    build-essential \
    ca-certificates \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Development stage
FROM base as dev
USER dbtuser
# Add development specific packages here if needed
RUN pip install --no-cache-dir pytest pytest-cov

# Production stage
FROM base as prod
USER dbtuser
# Add any production specific configurations here

# Set default command
CMD ["bash"]