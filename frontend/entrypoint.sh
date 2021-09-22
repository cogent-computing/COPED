#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

# Comment lines below if DB should NOT be refreshed in development
python manage.py flush --no-input
python manage.py migrate

exec "$@"
