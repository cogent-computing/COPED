# pull base image with python
# NB: avoid python:alpine and python:slim variants due to
# chipset issues (Mac M1)
FROM python:3.9.6-alpine

# files will run from here
WORKDIR /usr/src/app

# keep python running smoothly
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install psycopg2 dependencies
RUN apk update \
    && apk add postgresql-dev gcc python3-dev musl-dev

# install dependencies for django site
RUN pip install --upgrade pip
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# copy entrypoint.sh (and ensure correct line endings)
COPY ./entrypoint.sh .
RUN sed -i 's/\r$//g' /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

# copy rest of project
COPY . .

# run entrypoint.sh (wait for database connection then migrate django)
ENTRYPOINT [ "/usr/src/app/entrypoint.sh" ]
