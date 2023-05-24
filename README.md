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

## Product Model

```
bin/rails generate model product name:string code:string price:decimal inventory:integer
```
