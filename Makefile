
build:
	docker compose build

dev:
	docker compose up dbt-dev

prod:
	docker compose up dbt-prod

test:
	docker compose run --rm dbt-dev dbt test

docs:
	docker compose run --rm dbt-dev dbt docs generate
	docker compose run --rm dbt-dev dbt docs serve

clean:
	docker compose down
	rm -rf target/
	rm -rf dbt_packages/
	rm -rf logs/