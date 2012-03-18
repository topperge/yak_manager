ActiveAdmin.register Contractor do
  scope_to :current_user, :association_method => :get_self_contractors

  menu :priority => 2

  controller do
    load_and_authorize_resource
    skip_load_resource :only => :index
    
    actions :show, :index
    actions :show, :index, :new, :create, :edit, :update, :if => proc { can? :manage, ContractorFile }
  end  

  filter :clid
  filter :email
  filter :deleted, :as=>:select
  filter :created_at
  filter :updated_at
  
  scope :all, :default => true
  scope :active_users
  scope :to_be_removed
  
end
