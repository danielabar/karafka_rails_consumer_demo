# README

A companion project for a blog post about integrating Kafka into a Rails project using the Karafka gem. Topics to be covered include:
* Have the consumer delegate to a service object to avoid mixing concerns of Kafka consumption with business logic.
* Have the service delegate to an ActiveModel for validations to avoid high branch complexity in the service.
* Investigate error handling including Karafka's declarative DLQ (dead letter queue) and subscribing to error events, eg:
  ```ruby
  Karafka.monitor.subscribe 'error.occurred' do |event|
    Sentry.capture_exception(event[:error])
  end
  ```

## Setup

Create and seed database:

```
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

Start Kafka broker and Zookeeper:

```
docker-compose up
```

Start the Kafka consumer(s) polling for messages:

```
bundle exec karafka server
```

Produce message(s) from a Rails console `bundle exec rails c`:

```ruby
message = {
  greeting: "hello from the console"
}.to_json
Karafka.producer.produce_sync(topic: 'example', payload: message)
```

## Product Model

```
bin/rails generate model product name:string code:string price:decimal inventory:integer
```

## TODO

- fix `spec/factories/product.rb` wrt Faker methods
- add tests for Product model
- implement service to update product inventory given Kafka message payload, and tests
- implement consumer and tests
