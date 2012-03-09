describe AdminAbility do
  it 'lets a user manage companies he belongs to' do
    google = Company.create(:id => 1, :name => 'Google', :email=>'joe@gmail.com')
    user = User.create(:name => 'Joe', :company_id => 1, :role => 'user')
    google.should_not be_nil
  end
end
