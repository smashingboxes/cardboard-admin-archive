class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def admin?
    self.id == AdminUser.first.id
  end


  def can_manage_cardboard?(area)
    case area
    when :dashboard
      false
    when :pages
      self.admin?
    when :settings
      false
    when :icescream
      true
    else
      false
    end
  end
end
