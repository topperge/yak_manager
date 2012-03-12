class User < ActiveRecord::Base
  attr_accessible :id, :name, :company_id, :email, :role
  
  # scope :get_self_companies, Company.where(:id => self.company_id)
  
  belongs_to :company
  has_many   :contractor_files
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Privileges are inherited between roles in the order specified in the ROLES
  # array. E.g. A moderator can do the same as an editor + more.
  #
  # This method understands that and will therefore return true for moderator
  # users even if you call `role?('editor')`.
  def role?(base_role)
    return false unless role # A user have a role attribute. If not set, the user does not have any roles.
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me, :superadmin, :company_id, :role
  attr_accessible :email, :password, :password_confirmation, :remember_me, :company_id, :role

  validates_presence_of :email
  validates_presence_of :company_id, :if => "superadmin.nil?"
  validate :remove_company_if_superadmin?
   
  def is_not_superadmin?
    superadmin.nil?
  end
   
  def remove_company_if_superadmin?
    # Check if the user has selected both a company and made the user an Identity Administrator.  
    # This is not a valid use case. Remove company and confirm 
    if (superadmin == true && !company_id.nil?)
      self.company_id = nil
      self.role = 'superuser'
      errors.add(:company_id, "If the user is an Identity Administrator then they cannot be a member of a company.  Please resubmit if correct.")
    # This should evaluate if they confirm the user is an Identity Administrator and have not selected a Company
    elsif (superadmin == true)
      self.company_id = nil
      self.role = 'superuser'
    # If the user hasn't selected anything we force them to select something.
    elsif (superadmin == false && company_id.nil?)
      self.role = 'user'
      errors.add(:company_id, "You must select either a Company or an Identity Administrator Role for the User")
    # If they aren't an Identity Administrator then we make sure they only have the user role
    else
      self.role = 'user'
    end
  end
  
  def get_self_companies
    if self.role == 'superuser'
      Company.select([:id, :name, :description])
    else
      Company.where(:id => self.company_id)
    end
  end
end
