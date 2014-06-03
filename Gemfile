source 'https://rubygems.org'

ruby '2.1.1'

gem 'rails', '4.1.1'
gem 'bootstrap-sass', '3.1.1.1'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'simple_form', '~> 3.1.0.rc1', github: 'plataformatec/simple_form'
gem 'faker', '1.3.0'
gem 'will_paginate', '3.0.5'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'redcarpet', '3.1.2'
gem 'devise'

# temporarily add to all environments. Later, will remove from production
gem 'rack-mini-profiler'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

group :development, :test do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'mysql2'
  gem 'rspec-rails', '2.13.1'
  gem 'guard-rspec', '2.5.0'
  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.3.6'
  gem 'hirb'
  gem 'awesome_print'
  gem 'debugger'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.2.0'
  gem 'cucumber-rails', '1.4.0', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
  # Uncomment this line on OS X.
  gem 'growl', '1.0.3'
  # Uncomment these lines on Linux.
  # gem 'libnotify', '0.8.0'
  # Uncomment these lines on Windows.
  # gem 'rb-notifu', '0.0.4'
  # gem 'win32console', '1.3.2'
  # gem 'wdm', '0.1.0'
end

group :production do
 	gem 'rails_12factor', '0.0.2'
 	gem 'pg', '0.15.1'
end

