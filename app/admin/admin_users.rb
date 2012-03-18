ActiveAdmin.register User do
  #menu :if => proc{ can?(:manage, User) }
  
  menu :parent => "Administration", :priority => 4, :if => proc { current_user.superadmin? }
  
  scope_to :current_user, :association_method => :get_self_users
  
  # This will authorize the User class with CanCan
  # The authorization is done using the AdminAbility class
  #controller.authorize_resource
  
  controller do
    load_and_authorize_resource
    skip_load_resource :only => :index
  end
  
  # The order of the ROLES array is important!
  # All privileges are inherited from left to right
  ROLES = %w(user superuser)
  
  filter :email
  filter :company
  filter :created_at
  filter :updated_at
  
  index do
    column :email
    column :company
    column :superadmin, :label => 'Identity Administrator'
    default_actions
  end

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :company, :as => :select
      f.input :password
      f.input :password_confirmation
      f.input :superadmin, :label => "Identity Administrator"
    end
    f.buttons
  end

  create_or_edit = Proc.new {
    @user            = User.find_or_create_by_id(params[:id])
    @user.superadmin = params[:user][:superadmin]
    @user.attributes = params[:user].delete_if do |k, v|
      (k == "superadmin") ||
      (["password", "password_confirmation"].include?(k) && v.empty? && !@user.new_record?)
    end
    if @user.save
      redirect_to :action => :show, :id => @user.id
    else
      render active_admin_template((@user.new_record? ? 'new' : 'edit') + '.html.arb')
    end
  }
  member_action :create, :method => :post, &create_or_edit
  member_action :update, :method => :put, &create_or_edit

end
