ActiveAdmin.register Contractor do

  controller do
    load_and_authorize_resource
    skip_load_resource :only => :index
  end  

  filter :clid
  filter :email
  filter :deleted, :as=>:select
  filter :created_at
  filter :updated_at

end
