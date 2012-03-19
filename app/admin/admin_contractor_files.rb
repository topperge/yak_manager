ActiveAdmin.register ContractorFile do
  scope_to :current_user, :association_method => :get_self_contractor_files
  
  menu :priority => 1

  FILE_STATUS = ["Preparing File for Processing", "File Ready for Import into Directories", "Processing Completed"]
  
  filter :csv_file_name
  filter :user, :collection => proc { current_user.get_self_users.map(&:email) }
  filter :status, :as => :select, :collection => FILE_STATUS
  filter :company, :collection => proc { current_user.get_self_companies.map(&:name) }
  filter :created_at

  controller do
    actions :show, :index, :new, :create
    actions :show, :index, :new, :create, :edit, :update, :if => proc { can? :manage, ContractorFile }
    
    load_and_authorize_resource
    skip_load_resource :only => :index
    def create
      @contractorfile = ContractorFile.new(params[:contractor_file])
      @contractorfile.user_id = current_user.id
      if !current_user.superadmin
        @contractorfile.company_id = current_user.company_id
      end
      @contractorfile.status = FILE_STATUS[0]
      begin
        if @contractorfile.save!
          flash[:notice] = "CSV Uploaded Successfully and Staged for Processing!"
          ContractorFile.delay.process_csv_file(@contractorfile.csv.path, @contractorfile.company_id, @contractorfile.id)
          redirect_to :action => :show, :id => @contractorfile.id
        else
          render active_admin_template((@contractorfile.new_record? ? 'new' : 'edit') + '.html.arb')
        end
        rescue ActiveRecord::RecordInvalid
        render active_admin_template((@contractorfile.new_record? ? 'new' : 'edit') + '.html.arb')      
      end  
    end
  end  
  
  config.sort_order = 'created_at_desc'

  index do
    column("Uploaded File Name") {|contractorfile| link_to "#{contractorfile.csv_file_name}", contractorfile.csv.url(:original, false) }
    if current_user.superadmin == true
      column :company
    end
    column :user
    column :status, :sortable => :status do |contractorfile|
      if contractorfile.status == FILE_STATUS[0]
        div :class => "firstStatus" do
          contractorfile.status
        end
      elsif contractorfile.status == FILE_STATUS[1]
        div :class => "secondStatus" do
          contractorfile.status
        end
      else  
        div :class => "thirdStatus" do
          contractorfile.status
        end      
      end
    end
    column "Uploaded At", :created_at
    column("Records Uploaded") {|contractorfile| "#{contractorfile.contractor_file_records.count}" }
    column("Records Found") { |contractorfile| "#{contractorfile.users_found}" }
    column("Users Created") { |contractorfile| "#{contractorfile.users_created}" }
    column("Users Updated") { |contractorfile| "#{contractorfile.users_updated}" }
    column("Users Deleted") { |contractorfile| "#{contractorfile.users_deleted}" }
    column("Errors Found") { |contractorfile| "#{contractorfile.users_errored}" }
    column("Users Not Changed") { |contractorfile| "#{contractorfile.users_not_changed}" }
    default_actions
  end

  form do |f|
    if f.object.new_record? 
      f.inputs "File Upload" do
        f.input :csv, :as => :file, :label => "Please select a file for upload"
      end
      if current_user.superadmin
        f.inputs "Select Company" do
          f.input :company, :as => :select, :collection => Company.all
        end
      end
    else 
      f.inputs "Set Status" do
        #f.input :status, :as => :select, :collection => ["Preparing File for Processing", "File Ready for Import into Directories", "Processing Completed"]
        f.input :status, :as => :select, :collection => FILE_STATUS
      end
    end
    f.buttons
  end
  
  show :title => :csv_file_name do
    panel "File Details" do
      attributes_table_for contractor_file do
        row :id
        row :company
        row :user
        row :status do |contractorfile|
          if contractorfile.status == FILE_STATUS[0]
            div :class => "firstStatus leftAlign" do
              contractorfile.status
            end
          elsif contractorfile.status == FILE_STATUS[1]
            div :class => "secondStatus leftAlign" do
              contractorfile.status
            end
          else  
            div :class => "thirdStatus leftAlign" do
              contractorfile.status
            end      
          end
        end
        row :created_at
        row :csv_file_size
        row("Download") { link_to "#{:csv_file_name}", contractor_file.csv.url(:original, false) }
      end
    end
    active_admin_comments
  end

  sidebar "File Statistics", :only=>:show do 
    attributes_table_for contractor_file do 
      if contractor_file.status != FILE_STATUS[0]
        row("Records Found") { |contractorfile| "#{contractorfile.users_found}" }
        row("Updated Created") { |contractorfile| "#{contractorfile.users_created}" }
        row("Users Updated") { |contractorfile| "#{contractorfile.users_updated}" }
        row("Users Deleted") { |contractorfile| "#{contractorfile.users_deleted}" }
        row("Errors Found") { |contractorfile| "#{contractorfile.users_errored}" }
        row("Users Not Changed") { |contractorfile| "#{contractorfile.users_not_changed}" }
      else
        div :class=> "firstStatus" do
          "File Still Processing!"
        end
      end
    end
  end

end
