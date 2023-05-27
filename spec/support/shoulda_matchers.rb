# http://matchers.shoulda.io/docs/v5.3.0/
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
