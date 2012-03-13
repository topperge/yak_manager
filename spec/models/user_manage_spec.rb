require 'spec_helper'

require "cancan/matchers"

describe User do
  it 'lets a regular user be created in a company' do
    google = Company.find_or_create_by_name(:name => 'Google' )
    user = User.create!(:company_id => google.id, :password => 'passpass', :email=>'joe@gmail.com', :role => 'user')
  end
end