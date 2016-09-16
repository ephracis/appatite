unless Rails.env.test?
  Raven.configure do |config|
    config.dsn = ENV['SENTRY_DSN']
  end
end
