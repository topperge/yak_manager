# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
#   watch('config/application.rb')
#   watch('config/environment.rb')
#   watch(%r{^config/environments/.+\\.rb$})
#   watch(%r{^config/initializers/.+\\.rb$})
#   watch('Gemfile')
#   watch('Gemfile.lock')
#   watch('spec/spec_helper.rb') { :rspec }
#   watch('test/test_helper.rb') { :minitest }
#   watch(%r{features/support/}) { :cucumber }
# end

guard 'rspec', cli: "--drb" do
  watch(%r|^test/*/(.*)_test\.rb|)
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})  { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r|^test/test_helper\.rb|)    { "test" }
end

