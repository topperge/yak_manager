require 'spec_helper'

require "cancan/matchers"

describe AdminAbility do
  it 'lets a regular user read companies he belongs to' do
    google = Company.create(:name => 'Google' )
    user = User.create(:company_id => google.id, :password => 'passpass', :email=>'joe@gmail.com', :role => 'user')
    ability = AdminAbility.new(user)
    ability.should be_able_to(:read, google)
  end

  it 'lets a regular user read Contactors like through activeadmin' do
    livingsocial = Company.find_or_create_by_name(:name => 'Living Social' )
    normal_guy = User.find_or_create_by_email(:company_id => nil, :password => 'passpass', :email=>'joe@gmail.com', :role => 'user')
    non_admin = AdminAbility.new(normal_guy)
    non_admin.should be_able_to(:read, livingsocial)
  end

  it 'prevents a regular user from managing companies he does not belong to' do
    twitter = Company.find_or_create_by_name(:name => 'Twitter' )
    # we should only have one company in our test DB with transaction rollbacks so to create a user
    # that doesn't belong to any company, we'll just increment the id by one
    normal_guy = User.find_or_create_by_email(:company_id => twitter.id + 1, :password => 'passpass', :email=>'joe@gmail.com', :role => 'user')
    twitter.id.should_not == normal_guy.company_id
    non_admin = AdminAbility.new(normal_guy)
    non_admin.should_not be_able_to(:destroy, twitter)
  end

  it 'lets a superuser manage all companies' do
    bookface = Company.create(:name => 'Bookface' )
    frank = User.create(:company_id => nil, :password => 'passpass', :email=>'frank@blah.com', :superadmin => 'true', :role => 'superuser')
    frank_rights = AdminAbility.new(frank)
    frank_rights.should be_able_to(:destroy, bookface)    
  end
  
end
