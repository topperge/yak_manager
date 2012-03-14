class ContractorFileRecord < ActiveRecord::Base
  belongs_to :contractor_file
  belongs_to :company
end
