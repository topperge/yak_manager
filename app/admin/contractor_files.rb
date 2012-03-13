ActiveAdmin.register ContractorFile do
  scope_to :current_user, :association_method => :get_self_contractor_files

  controller do
    #load_and_authorize_resource
    #skip_load_resource :only => :index
    def create
      @contractorfile = ContractorFile.new(params[:contractor_file])
      @contractorfile.user_id = current_user.id
      @contractorfile.company_id = current_user.company_id
      @contractorfile.status = 'Preparing for Processing'
      if @contractorfile.save!
        redirect_to :action => :show, :id => @contractorfile.id
      else
        render active_admin_template((@contractorfile.new_record? ? 'new' : 'edit') + '.html.arb')
      end
    end
  end  
  
  config.sort_order = 'created_at_asc'

  index do
    column("Uploaded File Name") {|contractorfile| link_to "#{contractorfile.csv_file_name}", contractorfile.csv.url(:original, false) }
    column :company
    column :user
    column :status
    column :created_at
    column :csv_file_size
    default_actions
  end

  form do |f|
    if f.object.new_record? 
      f.inputs "File Upload" do
        f.input :csv, :as => :file
      end
    else 
      f.inputs "Set Status" do
        f.input :status, :as => :select, :collection => ["Preparing for Processing", "Processing Completed"]
      end
    end
    f.buttons
  end

end
