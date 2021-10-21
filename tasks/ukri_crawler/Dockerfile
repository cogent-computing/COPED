FROM python:3.9.7-slim-bullseye

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade pip
COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
RUN rm /tmp/requirements.txt

WORKDIR /app
COPY . .

# No entrypoint needed in production: launch when needed using Apache Airflow.
# Run in development using a vscode remote container.
