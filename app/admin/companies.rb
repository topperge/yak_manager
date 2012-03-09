ActiveAdmin.register Company do
  # cancan fail
  #controller.authorize_resource
  
  # This will authorize the Company class with CanCan
  # The authorization is done using the AdminAbility class
  controller do
    load_and_authorize_resource
    skip_load_resource :only => :index
  end
      
  config.sort_order = 'name_asc'
  
  index do
    column("Name") {|company| link_to "#{company.name}", admin_company_path(company) }
    column :description, :sortable => false
    column("Users") {|company| link_to "#{company.user.count}", admin_company_path(company) }
    default_actions
  end
  
  show :title => :name do    
    panel "Users" do
      table_for(company.user) do
        column("Email", :sortable => :id) {|user| link_to "#{user.email}", admin_user_path(user)}
      end
    end
    active_admin_comments
  end
  
  sidebar "Company Details", :only=>:show do
    attributes_table_for company, :name, :description, :created_at
  end
  
end
