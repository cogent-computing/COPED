FROM python:3.9.7-slim-bullseye

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# RUN apt-get update && apt-get install -y netcat
RUN apt-get update && apt-get install -y gettext
RUN apt-get update && apt-get install -y binutils
RUN apt-get update && apt-get install -y libproj-dev
RUN apt-get update && apt-get install -y gdal-bin
RUN apt-get update && apt-get install -y build-essential
RUN apt-get update && apt-get install -y gcc
RUN pip install --upgrade pip
RUN pip install textacy==0.11.0
RUN python -m spacy download en_core_web_lg
RUN apt-get update && apt-get install -y libgdal-dev
COPY ./requirements.txt .
RUN pip install -r requirements.txt

COPY ./entrypoint.sh .
RUN sed -i 's/\r$//g' entrypoint.sh
RUN chmod +x entrypoint.sh

COPY . .

ENTRYPOINT ["/app/entrypoint.sh"]
