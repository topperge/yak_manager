class User < ActiveRecord::Base
  belongs_to :company
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :superadmin, :company_id
  validates_presence_of :email
  validates_presence_of :company_id, :if => "superadmin.nil?"
  validate :remove_company_if_superadmin?

  def is_not_superadmin?
    superadmin.nil?
  end
  
  def remove_company_if_superadmin?
    if (superadmin == true)
      self.company_id=nil
    end
  end
end
