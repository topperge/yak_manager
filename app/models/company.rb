class Company < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :user
  has_many :contractor_files
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
end
