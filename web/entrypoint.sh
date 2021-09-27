#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
  echo "Waiting for PostgreSQL..."

  while ! nc -z $SQL_HOST $SQL_PORT; do
    sleep 0.1
  done

  echo "PostgreSQL started"
fi

# default to the PRODUCTION env to protect data
ENV="${ENVIRONMENT:-PROD}"

if [ "${ENV}" = "DEV" -o "${ENV}" = "TEST" ]
then
  echo "Current environment is ${ENV}."
  echo "Flushing database..."
  python manage.py flush --no-input
  echo "Flush complete"
fi

echo "Applying database migrations..."
python manage.py migrate
echo "Migrations complete"

echo "Collecting static files for Nginx..."
python manage.py collectstatic --no-input --clear
echo "Static file collection complete"

exec "$@"
