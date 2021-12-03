FROM python:3.9.7-slim-bullseye

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc netcat gettext

RUN pip install --upgrade pip
RUN pip install textacy==0.11.0
RUN python -m spacy download en_core_web_lg
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# Set up dependencies for PostGIS use in Django with PostgreSQL
# TODO: the postgres container needs to execute "CREATE EXTENSION postgis;" on the newly created CoPED DB at first run.
RUN apt-get install -y binutils libproj-dev gdal-bin

COPY ./entrypoint.sh .
RUN sed -i 's/\r$//g' entrypoint.sh
RUN chmod +x entrypoint.sh

COPY . .

ENTRYPOINT ["/app/entrypoint.sh"]
