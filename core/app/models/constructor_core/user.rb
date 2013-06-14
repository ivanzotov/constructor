# encoding: utf-8

module ConstructorCore
  class User < ActiveRecord::Base
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :timeoutable, :registerable  #:confirmable,  :omniauthable, :lockable, :encryptable
    attr_accessible :email, :password, :password_confirmation, :remember_me
  end
end