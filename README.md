# NYC Taxi Rides Data Pipeline with DBT

This project implements a data pipeline for analyzing NYC taxi rides data using DBT (Data Build Tool). The pipeline processes raw taxi ride data from BigQuery and transforms it into analytical models for various insights.

## 🚀 Features

- Data transformation pipeline using DBT
- Docker-based development and production environments
- Automated testing and documentation generation
- BigQuery integration for data storage and processing
- Comprehensive data models for taxi ride analysis

## 📋 Prerequisites

Before you begin, ensure you have the following installed:
- Docker and Docker Compose
- Google Cloud Platform (GCP) account with BigQuery access
- GCP credentials configured at `~/.config/gcloud/application_default_credentials.json`

## 🛠️ Project Setup

1. Clone the repository:
```bash
git clone https://github.com/abhayra12/taxi_rides_ny_dbt.git
cd taxi_rides_ny_dbt
```

2. Start the development container:
```bash
docker compose up dbt-dev
```

3. Access the development container:
```bash
docker compose exec dbt-dev bash
```

4. Inside the container, run the following commands in sequence:
```bash
# Install dependencies
dbt deps

# Load seed data
dbt seed

# Compile models
dbt compile

# Run tests
dbt test

# Run models
dbt run
```

## 📚 Documentation

To generate and view the project documentation:

1. Start the documentation container:
```bash
docker compose up dbt-docs
```

2. Access the documentation at: http://localhost:8080

## 🏗️ Project Structure

```
taxi_rides_ny_dbt/
├── models/              # DBT models
├── tests/              # Custom tests
├── macros/             # Reusable SQL macros
├── seeds/              # Seed data files
├── docker-compose.yml  # Docker configuration
└── dbt_project.yml     # DBT project configuration
```

## 🔧 Development Workflow

1. Make changes to your models in the `models/` directory
2. Run tests to ensure data quality:
```bash
dbt test
```
3. Compile and run your models:
```bash
dbt compile && dbt run
```
4. Generate updated documentation:
```bash
dbt docs generate && dbt docs serve --port 8080
```

## 🧹 Cleanup

To clean up the project:

```bash
# Stop and remove containers
docker compose down --volumes --remove-orphans

# Clean DBT artifacts
rm -rf target/
rm -rf dbt_packages/
rm -rf logs/
```

## 🚀 Production Deployment

For production deployment:

```bash
# Build and run production container
docker compose build dbt-prod
docker compose up dbt-prod
```

Production environment differences:
- Uses `trips_data_prod` dataset
- Runs with 12 threads
- Documentation served on port 8081
- Automatically runs models, tests, and generates documentation

## ⚠️ Troubleshooting

Common issues and solutions:

1. **Container Access Issues**
   - Check container status: `docker compose ps`
   - Ensure Docker daemon is running

2. **Documentation Server Issues**
   - Verify port 8080 is not in use
   - Check container logs: `docker compose logs dbt-docs`

3. **Authentication Errors**
   - Verify GCP credentials are correctly configured
   - Check credentials file path and permissions

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- Abhay Raj - Initial work

## 🙏 Acknowledgments

- NYC Taxi & Limousine Commission for the data
- DBT community for the excellent tooling
