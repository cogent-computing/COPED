#!/bin/sh

echo "Creating database migrations..."
python manage.py makemigrations --noinput
echo "Migrations created"

echo "Applying database migrations..."
python manage.py migrate --run-syncdb --noinput
echo "Migrations complete"

echo "Collecting static files for Nginx..."
python manage.py collectstatic --noinput --clear
echo "Static file collection complete"

echo "Building elasticsearch indexes..."
python manage.py search_index --rebuild -f
echo "Elasticsearch indexes complete"

echo "Creating cache table..."
python manage.py createcachetable
echo "Cache table created"

echo "Starting celery worker daemon..."
celery --app core worker --task-events --loglevel ${LOGLEVEL:-INFO} --pool=threads --logfile /var/log/coped/celery_worker.log --detach
echo "Celery worker daemon started. Logs will go to /var/log/coped/celery_worker.log"

echo "Starting celery beat/scheduler daemon..."
celery --app core beat --loglevel ${LOGLEVEL:-INFO} --scheduler django_celery_beat.schedulers:DatabaseScheduler --logfile /var/log/coped/celery_beat.log --detach
echo "Celery beat/scheduler daemon started. Logs will go to /var/log/coped/celery_beat.log"

echo "Starting celery flower web-based task monitor..."
celery --app core flower --port=5555
echo "Celery flower web-based task monitor started. Access at localhost:5555 on the docker host (ensure docker-compose.yaml forwards this port to the host)."

exec "$@"
