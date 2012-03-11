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
  # validates_presence_of :company_id, :if => "superadmin.nil?"
  # validate :remove_company_if_superadmin?
  # 
  # def is_not_superadmin?
  #   superadmin.nil?
  # end
  # 
  # def remove_company_if_superadmin?
  #   if (superadmin == true)
  #     self.company_id=nil
  #   end
  # end
  
  def get_self_companies
    if self.role == 'superuser'
      Company.select([:id, :name, :description])
    else
      Company.where(:id => self.company_id)
    end
  end
end
