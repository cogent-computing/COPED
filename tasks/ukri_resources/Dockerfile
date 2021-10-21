FROM python:3.9.7-slim-bullseye

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade pip
COPY ./requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# No entrypoint needed in production: launch when needed using Apache Airflow.
# Run in development using a command in the `docker-compose.override.yaml` file.
