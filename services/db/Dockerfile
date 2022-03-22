FROM postgres:13.4-bullseye

ARG METABASE_DB_NAME
ARG COPED_DB_NAME
# RUN apt-get update && apt-get install -y --no-install-recommends postgresql-13-postgis-3
RUN echo "CREATE DATABASE ${METABASE_DB_NAME};" > /docker-entrypoint-initdb.d/initialise.sql
RUN echo "CREATE DATABASE ${COPED_DB_NAME};" >> /docker-entrypoint-initdb.d/initialise.sql
