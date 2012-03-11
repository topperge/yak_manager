class ContractorFile < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  has_attached_file :csv
  validates_attachment_presence :csv
  validates_attachment_content_type :csv, :content_type => ['text/csv','text/comma-separated-values','text/csv','application/csv','text/plain']
  
  attr_accessible :csv_file_name, :csv_content_type, :csv_file_size, :csv_updated_at, :users_created, :users_deleted, :users_updated, :users_errored, :status, :user_id, :company_id
  
end