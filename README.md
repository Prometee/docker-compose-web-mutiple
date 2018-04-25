[![Build Status](https://travis-ci.org/Prometee/docker-compose-web-mutiple.svg?branch=master)](https://travis-ci.org/Prometee/docker-compose-web-mutiple)

Docker Compose for mutiple web hosts 
====================================

Copy the `.env.dist` to `.env`
Change the value of `PROJECT_DIR` variable to the root of your projects

Copy the `docker-compose.override.yaml.dist` to `docker-compose.override.yaml`

Edit the content of the `docker-compose.override.yaml` file to feet your need.
You have to respect the hierarchy of the folders, so if you have this type of project :

  * Project type Project 1 : `symfony-2`
  * Virtual Host name for Project 1 : `my_local_project_1.localhost`
  * Php version Project 1 : `5.6`
  * Local path on your machine : `${PROJECT_DIR}/my_local_project_1`
  * Path within the docker container : `${APP_ROOT_MULTIPLE}/__THE_NAME_OF_THE_VHOST__`
  
  * Project type Project 2 : `symfony-flex`
  * Virtual Host name for Project 2 : `my_local_project_2.localhost`
  * Php version Project 2 : `7.1`
  * Local path on your machine : `${PROJECT_DIR}/my_local_project_2`
  * Path within the docker container : `${APP_ROOT_MULTIPLE}/__THE_NAME_OF_THE_VHOST__`
  
You have to add a volume to the appropriate php container, here : `php5.6` and `php7.1`

```yaml
  app5.6:
    environment:
      APP_VHOST_LIST: my_local_project_1.localhost
      APP_PROJECT_TYPE_LIST: symfony-2
      APP_CACHE_DIR_LIST: app/cache
      APP_LOGS_DIR_LIST: app/logs
      APP_SESSIONS_DIR_LIST: app/sessions
    volumes:
      - ${PROJECT_DIR}/my_local_project_1:${APP_ROOT_MULTIPLE}/my_local_project_1.localhost:cached
      - ${APP_ROOT_MULTIPLE}/my_local_project_1.localhost/app/cache
      - ${APP_ROOT_MULTIPLE}/my_local_project_1.localhost/app/sessions
      - ${APP_ROOT_MULTIPLE}/my_local_project_1.localhost/app/logs
  app7.1:
    environment:
      APP_VHOST_LIST: my_local_project_2.localhost
      APP_PROJECT_TYPE_LIST: symfony-flex
      APP_CACHE_DIR_LIST: var/cache
      APP_LOGS_DIR_LIST: var/logs
      APP_SESSIONS_DIR_LIST: var/sessions
    volumes:
      - ${PROJECT_DIR}/my_local_project_2:${APP_ROOT_MULTIPLE}/my_local_project_2.localhost:cached
      - ${APP_ROOT_MULTIPLE}/my_local_project_2.localhost/var/cache
      - ${APP_ROOT_MULTIPLE}/my_local_project_2.localhost/var/sessions
      - ${APP_ROOT_MULTIPLE}/my_local_project_2.localhost/var/logs
```

You have to add the directory to the vhost :
```yaml
  nginx:
    environment:
      NGINX_VHOST_LIST: my_local_project_1.localhost my_local_project_2.localhost
      NGINX_PROJECT_TYPE_LIST: symfony-2 symfony-flex
      NGINX_WEB_INDEX_FILE_LIST: app_dev.php index.php
      NGINX_WEB_FOLDER_LIST: web public
      NGINX_PHP_VERSION_LIST: 5.6 7.1
    volumes:
      - ${PROJECT_DIR}/my_local_project_1:${APP_ROOT_MULTIPLE}/my_local_project_1.localhost
      - ${PROJECT_DIR}/my_local_project_2:${APP_ROOT_MULTIPLE}/my_local_project_2.localhost
```

Finally add some databases :

```yaml
  db:
    environment:
      MYSQL_DATABASE_LIST: my_db_1 my_db_2
```
