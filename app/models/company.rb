class Company < ActiveRecord::Base
  has_many :user
  validates_presence_of :name
end
