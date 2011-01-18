# == Schema Information
# Schema version: 20110109195732
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  first_name         :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  last_name          :string(255)
#  admin              :boolean
#  primary            :boolean
#

require 'digest'
class User < ActiveRecord::Base
	attr_accessor :password
	attr_accessible :first_name, :last_name, :email, :password, :password_confirmation
	
	before_save :encrypt_password
	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :first_name, :presence => true
	validates :last_name, :presence => true
	validates :email, :presence => true,
										:format => { :with => email_regex },
										:uniqueness => { :case_sensitive => false }
										
	validates :password, :presence => true,
											 :confirmation => true,
											 :length => { :within => 6..40 }
											 
  has_many :shifts, :finder_sql => 'SELECT * FROM shifts WHERE shifts.primary_id = #{id} OR shifts.secondary_id = #{id} ORDER BY shifts.start'
											
	def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
	def has_password?(submitted_password)
		encrypt(submitted_password) == encrypted_password
	end					 
	
	def full_name
	  "#{first_name} #{last_name}"
	end
	
	def name
	  "#{first_name} #{last_name[0,1]}."
	end
						
	def admin?
	  admin
	end
	
	def primary?
	  primary
	end
						
	private
	  
	  def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end 
end
