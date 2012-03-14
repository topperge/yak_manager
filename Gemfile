source 'https://rubygems.org'

gem 'rails', '3.2.1'

gem 'sqlite3'
gem 'activeadmin'
gem 'meta_search', '>= 1.1.0.pre'
gem 'devise', '~>2.0.0'
gem 'cancan'
gem 'paperclip'
gem 'delayed_job_active_record'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development do
  gem 'ffaker'
  gem 'ruby-prof'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'spork'
  gem 'rb-inotify' if RUBY_PLATFORM.downcase.include?("linux")
  gem 'rb-fsevent' if RUBY_PLATFORM.downcase.include?("darwin")
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
end
