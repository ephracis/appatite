source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

# Use postgres as the database for Active Record
gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Javascript runtime
gem 'therubyracer'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'

# Use HAML for templating
gem 'haml'

# Use Devise for authentication with OAuth
gem 'devise'
gem 'omniauth-github'
gem 'omniauth-gitlab'
gem 'oauth2'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Use CodeClimate for coverage and static analysis
  gem 'codeclimate-test-reporter', require: nil

  # Use Rubocop for style checks
  gem 'rubocop', require: false

  # Use WebMock to stub web request
  gem 'webmock'
end

# Gemified versions of Bower packages for frontend
source 'https://rails-assets.org' do
  # Use bootstrap for UI components
  gem 'rails-assets-bootstrap'

  # Use AngularJS for app logic
  gem 'rails-assets-angular2'

  # Use FontAwesome for icons
  gem 'rails-assets-fontawesome'
end
