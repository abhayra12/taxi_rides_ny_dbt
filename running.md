# DBT Project Running Guide

## Prerequisites
- Docker and Docker Compose installed
- GCP credentials configured at `E:/.config/gcloud/application_default_credentials.json`

## Step 1: Start Containers

### Development Container 
```bash
docker compose up dbt-dev 
```


### Access the development container
```bash
docker compose exec dbt-dev bash
```

## Step 2: Development Workflow

Inside the development container (`dbt-dev`), run these commands in order:

### 0. debug dbt connection to bigquery
```bash
dbt debug
```


### 1. Install Dependencies
```bash
dbt deps
```

### 2. Load Seed Data 
```bash
dbt seed
```

### 3. Compile Models
```bash
dbt compile
```

### 4. Run tests
```bash
dbt test
```


### 5. Run models
```bash
dbt run
```

## unified command for STEP 2

### access the development container
```bash
docker compose exec dbt-dev bash
```

### run the command
```bash
dbt deps && dbt seed && dbt compile && dbt test && dbt run 
```


## Step 3: Generate and View Documentation

Inside the docs container (`dbt-docs`), run these commands:

### 1. Generate Documentation
```bash
dbt docs generate
```

### 2. Serve Documentation
```bash
dbt docs serve --port 8080 

```

## unified command for STEP 3
```bash
dbt docs generate && dbt docs serve --port 8080
```

Access the documentation at: http://localhost:8080

## Step 4: Common Operations

### Checking Logs
```bash
#view development container logs
docker compose logs -f dbt-dev

```
### Stopping all Containers
```bash
docker compose down
```
### Stop specific container
```bash
docker compose stop dbt-dev
```



### Cleaning Up

### Remove all containers and their volumes
```bash
#Stop and remove containers and their associated volumes for this project
docker-compose down --volumes --remove-orphans
```



### Clean DBT artifacts
```bash
rm -rf target/
rm -rf dbt_packages/
rm -rf logs/
```


## Troubleshooting

### Container Access Issues
If you can't access the container:

1. Check if the container is running:
```bash
docker compose ps
```

### Documentation Server Issues
If documentation isn't accessible:
1. Verify the container is running: `docker compose ps`
3. Ensure port 8080 is not in use by another application

### Common Error Solutions
1. **Port already in use**: Stop any existing containers or change the port mapping
2. **Authentication errors**: Verify your GCP credentials file is correctly mounted
3. **Missing dependencies**: Run `dbt deps` again inside the container
4. **Stale data**: Clean up using the cleanup commands and rebuild

## Best Practices
1. Always use `dbt deps` after pulling new changes
2. Run tests before and after making changes
3. Keep documentation up to date by regenerating after model changes
4. Use `docker compose down` when switching branches or making major changes

## Next Step: Start Production Container

### 1. Start Production Container
```bash
docker compose up dbt-prod
```


### Production Environment

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








