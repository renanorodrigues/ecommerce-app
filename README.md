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

### Service Object

All services objects in this application inherit from a class called **ApplicationService** which uses metaprogramming to instantiate a new object every time the **call** method is called. 
~~~ruby
module Admin
  class ApplicationService
    def self.call(*args, &block)
      new(*args, &block).call
    end
  end
end
~~~
The implementation of this class was based on this article https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial
