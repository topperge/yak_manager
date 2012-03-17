ActiveAdmin.register ContractorFileRecord do
  scope_to :current_user, :association_method => :get_self_contractor_file_records

  controller do
    load_and_authorize_resource
    skip_load_resource :only => :index
  end
  
  filter :clid
  filter :email
  filter :flag, :as => :select, :collection => ContractorFileRecord.group(:flag).map(&:flag)
  filter :contractor_file, :as => :select, :collection => ContractorFile.group(:csv_file_name).map(&:csv_file_name)
  filter :created_at
  filter :updated_at
  
end
