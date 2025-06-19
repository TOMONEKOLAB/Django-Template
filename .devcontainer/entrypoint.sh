#!/bin/sh
set -ex

if [ -f /workspaces/.gitkeep ]; then
    echo "Remove .gitkeep..."
    rm /workspaces/.gitkeep
fi

case $CONTAINER in
    Django-app)
        if [ ! -f /workspaces/manage.py ]; then
            echo "Creating new Django project..."
            django-admin startproject config .
            exec python manage.py runserver 0.0.0.0:8080
        else
            echo "Starting Django Project..."
            if [ "$DEBUG" = "True" ]; then
                exec python manage.py runserver 0.0.0.0:8000
            else
                exec gunicorn config.wsgi:application --bind 0.0.0.0:8080
            fi
        fi
        ;;
    Django-db)
        chown -R postgres:postgres /workspaces

        if [ ! -s "/workspaces/PG_VERSION" ]; then
            echo "Initializing PostgreSQL database cluster..."
            su - postgres -c "/usr/lib/postgresql/17/bin/initdb -D /workspaces"
            echo "listen_addresses = '*'" >> /workspaces/postgresql.conf
            echo "port = 5432" >> /workspaces/postgresql.conf
            echo "host all all 0.0.0.0/0 trust" >> /workspaces/pg_hba.conf
            su - postgres -c "/usr/lib/postgresql/17/bin/pg_ctl -D /workspaces -w start"
            if [ "$POSTGRES_USER" != "postgres" ]; then
                su - postgres -c "createuser $POSTGRES_USER"
            fi
            su - postgres -c "psql -c \"ALTER USER \\\"$POSTGRES_USER\\\" WITH PASSWORD '$POSTGRES_PASSWORD';\""
            su - postgres -c "createdb -O $POSTGRES_USER $POSTGRES_DB"
            su - postgres -c "/usr/lib/postgresql/17/bin/pg_ctl -D /workspaces -m fast -w stop"
        fi

        echo "Starting PostgreSQL..."
        touch /workspaces/.gitkeep
        exec su - postgres -c "/usr/lib/postgresql/17/bin/postgres -D /workspaces"
        ;;
    Django-web)
        echo "Starting Nginx..."
        exec nginx -g 'daemon off;'
        ;;
    *)
        exec "$@"
        ;;
esac
