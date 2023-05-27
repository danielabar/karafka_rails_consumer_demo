# README

A companion project for a blog post about integrating Kafka into a Rails project using the Karafka gem. Topics to be covered include:
* Have the consumer delegate to a service object to avoid mixing concerns of Kafka consumption with business logic.
* Have the service delegate to an ActiveModel for validations to avoid high branch complexity in the service.
* Investigate error handling including Karafka's declarative DLQ (dead letter queue) and subscribing to error events, eg:
  ```ruby
  Karafka.monitor.subscribe 'error.occurred' do |event|
    # Or whatever error monitoring service Airbrake, Rollbar, etc.
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
# Valid
Product.first.inventory
message = {
  product_code: Product.first.code,
  inventory_count: 10
}.to_json
Karafka.producer.produce_async(topic: 'product_inventory', payload: message)
Product.first.inventory

# Invalid: Inventory count is negative
message = {
  product_code: Product.first.code,
  inventory_count: -1
}.to_json
Karafka.producer.produce_async(topic: 'product_inventory', payload: message)

# Invalid: Product code does not exist
message = {
  product_code: "NO_SUCH_CODE",
  inventory_count: 5
}.to_json
Karafka.producer.produce_async(topic: 'product_inventory', payload: message)

# Invalid: String instead of JSON
message = "this is no good"
Karafka.producer.produce_async(topic: 'product_inventory', payload: message)
```

## Product Model

```
bin/rails generate model product name:string code:string price:decimal inventory:integer
```

## TODO

- WIP: implement service to update product inventory given Kafka message payload, and tests
- WIP: implement consumer and tests
- add index on products table, code column

### Update Error Handling

```ruby
begin
  user = User.find(1)
  user.update!(name: "John Doe")
rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
  # Handle validation errors and other save-related errors
  error_message = "Record could not be saved: #{e.message}\n#{e.backtrace.join("\n")}"
  Rails.logger.error error_message
rescue => e
  # Handle any other exceptions
  error_message = "Error occurred: #{e.message}\n#{e.backtrace.join("\n")}"
  Rails.logger.error error_message
end
```
