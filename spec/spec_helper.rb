require 'rubygems'
require 'spork'

# puts slow stuff here
Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
  end

end


# This code will be run each time you run your specs.
Spork.each_run do
end
