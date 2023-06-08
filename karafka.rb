# frozen_string_literal: true

class KarafkaApp < Karafka::App
  setup do |config|
    # In a real app, use environment variable to specify the bootstrap servers:
    config.kafka = { "bootstrap.servers": "127.0.0.1:9092" }
    config.client_id = "example_app"
    # Recreate consumers with each batch. This will allow Rails code reload to work in the
    # development mode. Otherwise Karafka process would not be aware of code changes
    config.consumer_persistence = !Rails.env.development?
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(Karafka::Instrumentation::LoggerListener.new)
  # Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

  # This logger prints the producer development info using the Karafka logger.
  # It is similar to the consumer logger listener but producer oriented.
  Karafka.producer.monitor.subscribe(
    WaterDrop::Instrumentation::LoggerListener.new(Karafka.logger)
  )

  Karafka.monitor.subscribe "error.occurred" do |event|
    e = event[:error]
    Rails.logger.error("ProductInventoryConsumer failed: #{e.message}\n#{e.backtrace.join("\n")}")
    # Or whatever error monitoring service Airbrake, Rollbar, etc.
    # Sentry.capture_exception(event[:error])
  end

  routes.draw do
    topic :inventory_management_product_updates do
      consumer ProductInventoryConsumer
      dead_letter_queue(
        topic: "dlq_inventory_management_product_updates",
        max_retries: 2
      )
    end
  end
end
