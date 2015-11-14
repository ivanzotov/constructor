module ConstructorCore
  class User < ActiveRecord::Base
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :registerable  #:confirmable,  :omniauthable, :lockable, :encryptable
  end
end
