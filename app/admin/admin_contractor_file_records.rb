ActiveAdmin.register ContractorFileRecord do
  menu :parent => "Contractor Files", :priority => 1
  
  scope_to :current_user, :association_method => :get_self_contractor_file_records
  
  actions :index, :show

  controller do
    load_and_authorize_resource
    skip_load_resource :only => :index
  end
  
  filter :clid
  filter :email
  filter :message
  filter :flag, :as => :select, :collection => ContractorFileRecord.group(:flag).map(&:flag)
  #filter :contractor_file, :as => :select, :collection => ContractorFile.group(:csv_file_name).map(&:csv_file_name)
  #filter :contractor_file, :as => :select, :collection => proc { ContractorFile.all(:conditions => { :company_id => f.template.controller.current_user.company_id}).flatten }
  filter :created_at
  filter :updated_at
  
  scope :all, :default => true
  scope :new_users
  scope :updated_users
  scope :bad_data
  
  show :title => :clid do
    attributes_table_for contractor_file_record, :id, :email, :record_id, :flag, :message, :company, :created_at  
    active_admin_comments
  end
  
  sidebar "Associated File Information", :only => :show do
    attributes_table_for contractor_file_record.contractor_file do
       row("File Name") { link_to "#{contractor_file_record.contractor_file.csv_file_name}", contractor_file_record.contractor_file.csv.url(:original, false)}
       row("Uploaded At") {contractor_file_record.contractor_file.created_at}
       row :status
       row :user
    end
  end
  
  end
