ActiveAdmin.register Company do
  scope_to :current_user, :association_method => :get_self_companies
  
  menu :parent => "Administration", :priority => 3, :if => proc { current_user.superadmin? }
  
  # This will authorize the Company class with CanCan
  # The authorization is done using the AdminAbility class
  # BLACK MAGIC BELOW
  # if you simply do controller.authorize_resource
  # CanCan will fail insecurely with complex auth rules
  # for example, everyone will be able to edit all Companies
 
  controller do
    load_and_authorize_resource
    skip_load_resource :only => :index
  end
  
  config.sort_order = 'name_asc'
  
  filter :name
  filter :created_at
  filter :updated_at
  
  index do
    column("Name") {|company| link_to "#{company.name}", admin_company_path(company) }
    column :description, :sortable => false
    column("Users") {|company| link_to "#{company.user.count}", admin_company_path(company) }
    default_actions :if => proc{ can?(:manage, Company) }
  end
  
  show :title => :name do
    if company.description?
      panel "Company Description" do
        div company.description   
      end
    end
    panel "Users" do
      table_for(company.user) do
        column("Email", :sortable => :id) {|user| link_to "#{user.email}", admin_user_path(user)}
      end
    end
    active_admin_comments
  end
  
end
