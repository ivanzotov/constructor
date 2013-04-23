# encoding: utf-8

module ConstructorCore
  class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :timeoutable  #:confirmable, :registerable, :omniauthable, :lockable, :encryptable
    # Setup accessible (or protected) attributes for your model
    attr_accessible :email, :password, :password_confirmation, :remember_me
  end
end