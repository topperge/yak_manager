require 'spec_helper'

describe AdminAbility do
  it 'lets a user manage companies he belongs to' do
    google = Company.create(:id => 1, :name => 'Google', )
    user = User.create(:company_id => 1, :email=>'joe@gmail.com', :role => 'user')
    google.should_not be_nil
  end
end

