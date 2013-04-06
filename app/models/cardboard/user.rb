module Cardboard
  class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable, :omniauthable, :registerable, :recoverable, :rememberable
    devise :database_authenticatable, :trackable, :timeoutable, :lockable, :validatable


    attr_accessible :email, :password, :password_confirmation #, :remember_me

  end
end
