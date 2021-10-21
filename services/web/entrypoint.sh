#!/bin/sh

echo "Waiting for PostgreSQL..."
while ! nc -z $SQL_HOST $SQL_PORT; do
  sleep 0.1
done
echo "PostgreSQL started"

# default to the PRODUCTION env to protect data
ENV="${ENVIRONMENT:-PRODUCTION}"

if [ "${ENV}" = "DEVELOPMENT" -o "${ENV}" = "TEST" ]
then
  echo "Current environment is ${ENV}."
  echo "Flushing database..."
  python manage.py flush --no-input
  echo "Flush complete"
fi

echo "Applying database migrations..."
python manage.py migrate
echo "Migrations complete"

echo "Applying fixtures. Environment variables will be replaced..."
envsubst < coped_resources/fixtures/couchdbname.yaml > /tmp/couchdbname.yaml  # replace env
python manage.py loaddata /tmp/couchdbname.yaml
python manage.py loaddata coped_resources/fixtures/relationtype
python manage.py loaddata coped_resources/fixtures/resourcetype
rm /tmp/couchdbname.yaml
echo "Fixtures complete"

echo "Collecting static files for Nginx..."
python manage.py collectstatic --no-input --clear
echo "Static file collection complete"

exec "$@"
