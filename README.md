[![Build Status](https://travis-ci.org/Prometee/docker-compose-web-multiple.svg?branch=master)](https://travis-ci.org/Prometee/docker-compose-web)

Docker Compose for mutiple web hosts 
====================================

Copy the `.env.dist` to `.env`
Change the value of `PROJECT_DIR` variable to the root of your projects

Copy the `docker-compose.override.yaml.dist` to `docker-compose.override.yaml`

Edit the content of the `docker-compose.override.yaml` file to feet your need.
You have to respect the hierarchy of the folders, so if you have this type of project :

  * Project type Project 1 : symfony-2
  * Virtual Host name for Project 1 = my_local_project_1.localhost
  * Php version Project 1 = 5.6
  * Project type Project 2 : symfony-flex
  * Virtual Host name for Project 2 = my_local_project_2.localhost
  * Php version Project 2 = 7.1
  
You have to add a volume to the appropriate php container, here : `php5.6` and `php7.1`

```yaml
  app5.6:
    volumes:
      - $[PROJECT_DIR}/my_local_project_1:${APP_ROOT}/symfony-2/my_local_project_1.localhost:cached
      - ${APP_ROOT}/symfony-2/my_local_project_1.localhost/app/cache
      - ${APP_ROOT}/symfony-2/my_local_project_1.localhost/app/sessions
      - ${APP_ROOT}/symfony-2/my_local_project_1.localhost/app/logs
  app7.1:
    volumes:
      - $[PROJECT_DIR}/my_local_project_2:${APP_ROOT}/symfony-flex/my_local_project_2.localhost:cached
      - ${APP_ROOT}/symfony-flex/my_local_project_2.localhost/var/cache
      - ${APP_ROOT}/symfony-flex/my_local_project_2.localhost/var/sessions
      - ${APP_ROOT}/symfony-flex/my_local_project_2.localhost/var/logs
```

You have to add the directory to the vhost :
```yaml
  nginx:
    volumes:
      $[PROJECT_DIR}/my_local_project_1:${APP_ROOT}/symfony-2/my_local_project_1.localhost
      $[PROJECT_DIR}/my_local_project_2:${APP_ROOT}/symfony-flex/my_local_project_2.localhost
```

Finally add some databases :

```yaml
  db:
    environment:
      MYSQL_DATABASE_LIST: my_db_1 my_db_2
```