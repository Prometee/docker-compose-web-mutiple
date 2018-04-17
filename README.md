[![Build Status](https://travis-ci.org/Prometee/docker-compose-web-multiple.svg?branch=master)](https://travis-ci.org/Prometee/docker-compose-web)

Docker Compose for mutiple web hosts 
====================================

Copy the `.env.dist` to `.env`
Change the value of `PROJECT_DIR` variable to the root of your projects

Copy the `docker-compose.override.yaml.dist` to `docker-compose.override.yaml`

Edit the content of the `docker-compose.override.yaml` file to feet your need.
You hav to respect the hierarchy of the folders, so if you have this type of project :

  * Project type : symfony-flex
  * Virtual Host nae = my_local_app.localhost 
  * Php version = 7.1
  
Then you have to add a volume to appropriate php container, here : `php7.1`

```yaml
  app7.1:
    volumes:
      - $[PROJECT_DIR}/my_local_project_1:${APP_ROOT}/symfony-flex/my_local_project_1.localhost:cached
      - ${APP_ROOT}/symfony-flex/my_local_project_1.localhost/var/cache
      - ${APP_ROOT}/symfony-flex/my_local_project_1.localhost/var/sessions
      - ${APP_ROOT}/symfony-flex/my_local_project_1.localhost/var/logs
```

Finally you add the directory to the vhost :
```yaml
  nginx:
    volumes:
      $[PROJECT_DIR}/my_local_project_1:${APP_ROOT}/symfony-flex/my_local_project_1.localhost
```