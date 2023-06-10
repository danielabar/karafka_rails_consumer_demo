# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# https://stackify.com/rails-logger-and-rails-logging-best-practices/
Rails.logger = Logger.new($stdout)
Rails.logger.level = Logger::DEBUG
Rails.logger.datetime_format = "%Y-%m-%d %H:%M:%S"
