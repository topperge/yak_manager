class Contractor < ActiveRecord::Base
  belongs_to :company
  
  scope :to_be_removed, where("deleted=='t' and updated_at < '#{Time.now - 45.days}'")
  scope :active_users, where("deleted=='f' or (deleted=='t' and updated_at >= '#{Time.now - 45.days}')")
end
