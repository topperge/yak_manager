class Company < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :user
  has_many :contractor_files, :dependent => :destroy
  has_many :contractors, :dependent => :destroy
  has_many :contractor_file_records, :through => :contractor_files, :dependent => :destroy
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
end
