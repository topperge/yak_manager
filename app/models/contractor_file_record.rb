class ContractorFileRecord < ActiveRecord::Base
  belongs_to :contractor_file
  belongs_to :company
  
  scope :bad_data, where("flag = 'Bad Data'")
  scope :new_users, where("flag = 'New User'")
  scope :updated_users, where("flag = 'Updated User'")
end
