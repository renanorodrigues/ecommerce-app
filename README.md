# Project ecommerce for games

Project created based on the following OneBitCode bootcamp

## Modifications

1. Dockerizing the application
### Dockerization the application to facilitate the installation and maintenance of services.

* Use docker to run the application in your machine by clone this repository. After that, run the command:
```
docker-compose build
```
* Next, create the database
```
docker-compose run rails-api rails db:create
```
* And run the migratons
```
docker-compose run rails-api rails db:migrate
```

* Test the application
```
docker-compose up
```