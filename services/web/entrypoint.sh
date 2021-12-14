#!/bin/sh

echo "Setting environment"
ENV="${ENVIRONMENT:-PRODUCTION}"
echo "Environment set to ${ENVIRONMENT}"

echo "Applying database migrations..."
python manage.py migrate
echo "Migrations complete"

echo "Collecting static files for Nginx..."
python manage.py collectstatic --no-input --clear
echo "Static file collection complete"

echo "Building elasticsearch indexes..."
python manage.py search_index --rebuild -f
echo "Elasticsearch indexes complete"

exec "$@"
