# DBT Project Setup Guide

## Prerequisites
- Docker and Docker Compose installed
- Git installed
- Google Cloud Platform account with BigQuery access
- GCP credentials file

## Project Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd <project-directory>
```

### 2. GCP Credentials Setup
Place your GCP credentials JSON file in:
- Linux/Mac: `~/.config/gcloud/application_default_credentials.json`
- Windows: `E:/.config/gcloud/application_default_credentials.json`

### 3. Configure DBT Profile
Create a `profiles.yml` file in your project root with the following content:

```yaml
default:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: oauth
      project: your-project-id
      dataset: trips_data_dev
      threads: 4
      timeout_seconds: 300
      location: US
      priority: interactive
    prod:
      type: bigquery
      method: oauth
      project: your-project-id
      dataset: trips_data_prod
      threads: 12
      timeout_seconds: 300
      location: US
      priority: interactive
```

### 4. Development Environment

#### Build and Start Development Container
```bash
# Build the development container
docker compose build dbt-dev

# Start the development container in interactive mode
docker compose run --rm dbt-dev bash
```

Once inside the container shell, you can run DBT commands:
```bash
# Install dependencies
dbt deps

# load seed data 
dbt seed
# Compile models
dbt compile

# Run tests
dbt test

# Execute models
dbt run

# Generate and serve documentation
dbt docs generate
dbt docs serve  # Access at http://localhost:8080
```

To exit the container shell:
```bash
exit
```

### 5. Production Environment

#### Build and Run Production Container
```bash
# Build production container
docker compose build dbt-prod

# Run production workflow
docker compose up dbt-prod
```

Production environment differences:
- Uses `trips_data_prod` dataset
- Runs with 12 threads
- Documentation served on port 8081
- Automatically runs models, tests, and generates documentation

### 6. Continuous Integration Setup

1. Configure GitHub Secrets:
   - Navigate to repository Settings → Secrets and Variables → Actions
   - Add `GCP_CREDENTIALS` secret containing your GCP JSON credentials

2. CI Workflow Configuration:
```yaml
name: DBT CI

on:
  pull_request:
    branches: [ main, master ]

jobs:
  dbt-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build and Test
        env:
          GCP_CREDENTIALS: ${{ secrets.GCP_CREDENTIALS }}
        run: |
          docker compose build dbt-dev
          docker compose run --rm dbt-dev dbt deps
          docker compose run --rm dbt-dev dbt seed
          docker compose run --rm dbt-dev dbt compile
          docker compose run --rm dbt-dev dbt test
```

### 7. Common Operations

#### Running Commands in Container
To execute any DBT command, you can either:

1. Enter the container shell:
```bash
docker compose run --rm dbt-dev bash
# Then run DBT commands directly
dbt deps
dbt seed
dbt compile
dbt run
dbt test
```

2. Run commands directly:
```bash
# Load seed data
docker compose run --rm dbt-dev dbt seed
# Test specific models
docker compose run --rm dbt-dev dbt test --select model_name

# Full refresh of all models
docker compose run --rm dbt-dev dbt build --full-refresh

# Generate documentation
docker compose run --rm dbt-dev dbt docs generate
docker compose run --rm dbt-dev dbt docs serve
```

## Project Structure
```
project-root/
├── analyses/          # Ad-hoc analyses
├── macros/           # Custom macros/functions
├── models/           # Data transformation models
│   ├── core/         # Core business logic models
│   └── staging/      # Initial data transformation
├── seeds/            # Static data files
├── tests/            # Custom test definitions
├── docker-compose.yaml  # Container configuration
└── profiles.yml      # DBT connection profiles
```

## Troubleshooting

### Authentication Issues
1. Verify GCP credentials file location and permissions
2. Check BigQuery access permissions
3. Run `gcloud auth application-default login` if using OAuth

### Docker Issues
1. Clean up containers and volumes:
```bash
docker compose down -v
docker system prune
```
2. Check for port conflicts
3. Verify Docker daemon status

### DBT Issues
1. Clear DBT artifacts:
```bash
# Inside container
rm -rf target/
dbt clean
dbt deps
```
2. Verify profiles.yml configuration
3. Check logs: `dbt debug`

## Best Practices

### Development Workflow
1. Create feature branches from main
2. Local testing workflow:
```bash
dbt compile
dbt test
dbt run
```
3. Use meaningful commit messages
4. Create pull requests for review

### Production Deployment
1. Always use production target
2. Monitor job execution times
3. Review logs regularly
4. Schedule full refreshes carefully

### Testing
1. Add tests for new models
2. Run incremental tests during development
3. Full test suite before production deployment

## Additional Resources
- [DBT Documentation](https://docs.getdbt.com/)
- [BigQuery Documentation](https://cloud.google.com/bigquery/docs)
- [Docker Documentation](https://docs.docker.com/)
