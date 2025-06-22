# English
# Django template

This repository was created as a template for Django applications.  
It can be used in both development and production environments.  
Please modify it as necessary.

## Prerequisite knowledge

Required
- Docker

Recommended
- VSCode
- Dev Container

## .env file and environment variables

Please refer to .env.sample.  
The contents are as follows.

<details>
  
```
#-------------------------------------
# PostgreSQL
#-------------------------------------
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=postgres
POSTGRES_HOST=db
PGDATA=/workspaces

# Optional: Full connection string (used by dj_database_url)
# DATABASE_URL=postgresql://postgres:postgres@db:5432/postgres

#-------------------------------------
# Django
#-------------------------------------
DEBUG=True
# Comma-separated list of allowed hosts
ALLOWED_HOSTS=localhost,127.0.0.1
SECRET_KEY=your-secret-key
#-------------------------------------
# Locale settings
# (Make sure ja_JP.UTF-8 is available in your base image)
# -------------------------------------
DEBIAN_FRONTEND=noninteractive
LANG=ja_JP.UTF-8
LC_ALL=ja_JP.UTF-8
```
</details>

### Things you must change

```
DEBUG=True
SECRET_KEY=your-secret-key
```

Your Django secret key and whether it is a development or production environment.  
Please reissue your Django secret key and write it.  
Please use the DEBUG variable if you want to check whether it works in a production environment.  
True is a development environment, False is a production environment.

### Changes as needed

```
POSTGRES_DB=postgres
DATABASE_URL=postgresql://postgres:postgres@db:5432/postgres
ALLOWED_HOSTS=localhost,127.0.0.1
```

You are free to change these, but if you change other environment variables, please do so at your own risk.  

## docker-compose.yml

If you create environments multiple times in different projects without making any changes to this template, an error will be thrown saying that the container names are the same.  
Therefore, change the container names as needed.

<details>

```
services:

  app:
    container_name: dev-manager
    image: django-app
    build:
      context: .
      dockerfile: .devcontainer/app/Dockerfile
    platform: linux/x86_64
    volumes:
      - ./app:/workspaces
      - ./app/static:/workspaces/static
    tty: true
    expose:
      - 8080
    ports:
      - "8000:8000"
    environment:
      - CONTAINER=Django-app
      - DEBUG=${DEBUG}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
    networks:
      - frontend
      - backend
    depends_on:
      db:
        condition: service_healthy
    # command: sh -c "/opt/entrypoint.sh"

  web:
    container_name: portfolio-web
    image: django-web
    build:
      context: .
      dockerfile: .devcontainer/web/Dockerfile
    platform: linux/x86_64
    volumes:
      - ./app/static:/workspaces/static
    tty: true
    ports:
      - "80:80"
    environment:
      - CONTAINER=Django-web
      - DEBUG=${DEBUG}
    networks:
      - frontend
    depends_on:
      - app
    command: sh -c "/opt/entrypoint.sh"

  db:
    container_name: portfolio-db
    image: django-db
    build:
      context: .
      dockerfile: .devcontainer/db/Dockerfile
    platform: linux/x86_64
    volumes:
      - ./db:/workspaces
    tty: true
    environment:
      - CONTAINER=Django-db
      - DEBUG=${DEBUG}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
      - PGDATA=${PGDATA}
    networks:
      - backend
    command: sh -c "/opt/entrypoint.sh"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 1s
      timeout: 5s
      retries: 10

networks:
  frontend:
    name: frontend
  backend:
    name: backend
```
</details>

Change the container_name property in each service.  
Also, if you want to start the Django app as is, uncomment the command property in the app service.

## requirements.txt

Located in app/requirements.txt.  
Make changes as needed.

## How to start

If you are using Dev Container etc. and want to start it from within, please do the following.

- If DEBUG=True
```shell
python manage.py runserver 0.0.0.0:8000
```

- If DEBUG=False
```shell
python manage.py runserver 0.0.0.0:8080
```

If you are not using Dev Conatiner etc., start it with docker-compose and it will be published.
The published location is as follows.

- If DEBUG=True
```shell
localhost:8000
```

- If DEBUG=False
```shell
localhost:80
```

# 日本語
# Djangoテンプレート

このリポジトリはDjangoアプリケーションのためのテンプレートとして作成しました．  
開発環境と本番環境の両方で使用できるようにしました．  
必要に応じて変更して使用してください．

## 前提知識

必須
- Docker

推奨
- VSCode
- Dev Container

## .envファイル及び，環境変数

.env.sampleを参考にしてください．  
内容は以下です．

<details>
  
```
#-------------------------------------
# PostgreSQL
#-------------------------------------
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=postgres
POSTGRES_HOST=db
PGDATA=/workspaces

# Optional: Full connection string (used by dj_database_url)
# DATABASE_URL=postgresql://postgres:postgres@db:5432/postgres

#-------------------------------------
# Django
#-------------------------------------
DEBUG=True
# Comma-separated list of allowed hosts
ALLOWED_HOSTS=localhost,127.0.0.1
SECRET_KEY=your-secret-key
#-------------------------------------
# Locale settings
# (Make sure ja_JP.UTF-8 is available in your base image)
# -------------------------------------
DEBIAN_FRONTEND=noninteractive
LANG=ja_JP.UTF-8
LC_ALL=ja_JP.UTF-8
```
</details>

### 必ず変更するもの

```
DEBUG=True
SECRET_KEY=your-secret-key
```

Djangoのシークレットキーと開発環境か本番環境か否かです．  
Djangoのシークレットキーは再発行して，書き込んでください．  
DEBUG変数は，本番環境でも動くか確認したい場合にどうぞ．  
Trueで開発環境，Falseで本番環境です．  

### 必要に応じて変更するもの

```
POSTGRES_DB=postgres
DATABASE_URL=postgresql://postgres:postgres@db:5432/postgres
ALLOWED_HOSTS=localhost,127.0.0.1
```

は自由に変えてもらっても構いませんが，他の環境変数を変える場合，ご自身で責任をもって変更をお願いします．

## docker-compose.yml

このテンプレートを何も変更を加えずに違うプロジェクトで複数回環境を作成すると，コンテナ名が同じといわれてエラーを吐きます．  
なので，必要に応じてコンテナの名前を変更してください．  

<details>
  
```
services:

  app:
    container_name: dev-manager
    image: django-app
    build:
      context: .
      dockerfile: .devcontainer/app/Dockerfile
    platform: linux/x86_64
    volumes:
      - ./app:/workspaces
      - ./app/static:/workspaces/static
    tty: true
    expose:
      - 8080
    ports:
      - "8000:8000"
    environment:
      - CONTAINER=Django-app
      - DEBUG=${DEBUG}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
    networks:
      - frontend
      - backend
    depends_on:
      db:
        condition: service_healthy
    # command: sh -c "/opt/entrypoint.sh"

  web:
    container_name: portfolio-web
    image: django-web
    build:
      context: .
      dockerfile: .devcontainer/web/Dockerfile
    platform: linux/x86_64
    volumes:
      - ./app/static:/workspaces/static
    tty: true
    ports:
      - "80:80"
    environment:
      - CONTAINER=Django-web
      - DEBUG=${DEBUG}
    networks:
      - frontend
    depends_on:
      - app
    command: sh -c "/opt/entrypoint.sh"

  db:
    container_name: portfolio-db
    image: django-db
    build:
      context: .
      dockerfile: .devcontainer/db/Dockerfile
    platform: linux/x86_64
    volumes:
      - ./db:/workspaces
    tty: true
    environment:
      - CONTAINER=Django-db
      - DEBUG=${DEBUG}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
      - PGDATA=${PGDATA}
    networks:
      - backend
    command: sh -c "/opt/entrypoint.sh"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 1s
      timeout: 5s
      retries: 10

networks:
  frontend:
    name: frontend
  backend:
    name: backend
```
</details>

各サービスにあるcontainer_nameプロパティを変更してください．  
また，起動してそのままDjangoのアプリを起動したい場合はappサービスの中にあるcommandプロパティのコメントアウトを外してください．

## requirements.txt

app/requirements.txtにあります．  
必要に応じて変更を加えてください．

## 起動方法

Dev Container等を使用して，中から起動する場合は，以下の通りにしてください．

- DEBUG=Trueの場合
```shell
python manage.py runserver 0.0.0.0:8000
```

- DEBUG=Falseの場合
```shell
python manage.py runserver 0.0.0.0:8080
```

Dev Conatiner等を使用しない場合は，docker-composeで起動してもらえば公開されます．  
公開される場所は以下の通りです．

- DEBUG=Trueの場合
```shell
localhost:8000
```

- DEBUG=Falseの場合
```shell
localhost:80
```
