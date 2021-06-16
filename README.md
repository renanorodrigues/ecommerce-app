# Project ecommerce for games

Project created based on the following OneBitCode bootcamp

## Modifications

### Dockerizing the application

1. Use docker to run the application in your machine by clone this repository. After that, run the command:
```
docker-compose build
```
2. Next, create the database
```
docker-compose run rails-api rails db:create
```
3. And run the migratons
```
docker-compose run rails-api rails db:migrate
```
4. Test the application
```
docker-compose up
```