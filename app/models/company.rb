class Company < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :user
  validates_presence_of :name  
end
