source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0'

# Use postgres as the database for Active Record
gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 3.6'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Javascript runtime
gem 'therubyracer'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.6'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.3'

# Use HAML for templating
gem 'haml'

# Use Devise for authentication with OAuth
gem 'devise'
gem 'omniauth-github'
gem 'omniauth-gitlab'
gem 'oauth2'

# Allow users to follow projects
# TODO: currently need to fetch from github to get Rails 5 support
gem 'acts_as_follower', git: 'https://github.com/tcocca/acts_as_follower.git'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Collect crash reports
gem 'sentry-raven'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  # Specify environment variables in .env file
  gem 'dotenv-rails'

  # Use RSpec for unit testing
  gem 'rspec-rails'

  # Use Teaspoon for Javascript testing
  gem 'teaspoon-jasmine'
  gem 'phantomjs'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  # Use CodeClimate for coverage and static analysis
  gem 'codeclimate-test-reporter', require: nil

  # Style checks for Ruby, Coffeescript, HAML, YAML
  gem 'rubocop', require: false
  gem 'coffeelint'
  gem 'haml_lint'
  gem 'yamllint'

  # Use WebMock to stub web request
  gem 'webmock'

  # Use Mocha for stubbing and mocking in Ruby tests
  gem 'mocha'

  # Use Shoulda for useful matchers in RSpec
  gem 'shoulda-matchers'

  # Use FactoryGirl for filling database during tests
  gem 'factory_girl_rails'

  # Use Capybara to test rendered views
  gem 'capybara'
end

# Gemified versions of Bower packages for frontend
source 'https://rails-assets.org' do
  # Use bootstrap for UI components
  gem 'rails-assets-bootstrap'

  # Use AngularJS for app logic
  gem 'rails-assets-angular2'

  # Use FontAwesome for icons
  gem 'rails-assets-fontawesome'

  # We need to test AngularJS code
  gem 'rails-assets-angular-mocks'

  # Allow us to go fullscreen with a button
  gem 'rails-assets-angular-fullscreen'
end
