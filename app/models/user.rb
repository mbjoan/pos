class User < ActiveRecord::Base

  attr_accessor :password

  #validating the form for creating new user
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :password, :confirmation => true #password_confirmation attr
  validates_length_of :password, :in => 6..20, :on => :create
  validates :role, :presence => true
 
  #call method before appropriate action
  before_save :encrypt_password
  after_save :clear_fields

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_fields
    self.password=nil
    self.username=nil
    self.role=nil
  end
  #authenticating a system user
  def self.authenticate(username, password)
    user=find_by_username(username)  #find the user
      #confirm the users password
      if user && user.encrypted_password == BCrypt::Engine.hash_secret(password, user.salt)
          user      
      else
       nil
      end
  end
  
end
