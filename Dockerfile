FROM ghcr.io/dbt-labs/dbt-postgres:1.4.7

WORKDIR /usr/app/dbt
COPY . .
RUN pip install --upgrade pip && \
    pip install dbt-postgres

ENTRYPOINT ["./docker-entrypoint.sh"]
