ActiveAdmin.register ContractorFile do

  controller do
    #load_and_authorize_resource
    #skip_load_resource :only => :index
  end  
  
  config.sort_order = 'created_at_asc'

  index do
    column("Uploaded File Name") {|contractorfile| link_to "#{contractorfile.csv_file_name}", contractorfile.csv.url(:original, false) }
    column :created_at
    column :csv_file_size
    column :status
  end

  form do |f|
    f.inputs "File Upload" do
      f.input :csv, :as => :file
    end
    f.buttons
  end
    
end
