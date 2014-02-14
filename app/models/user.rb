class User < ActiveRecord::Base
	SUCCESS = 1
	ERR_BAD_CREDENTIALS = -1
	ERR_USER_EXISTS = -2
	ERR_BAD_USERNAME = -3
	ERR_BAD_PASSWORD = -4
	MAX_USERNAME_LENGTH = 128
	MAX_PASSWORD_LENGTH = 128

	attr_accessible :user
	attr_accessible :password
	attr_accessible :count
	attr_accessible :skip_uniq
	attr_accessor :skip_uniq

	validates :user, uniqueness: true, :unless => :skip_uniq
	validates :user, presence: true
	validates :user, length:{maximum: MAX_USERNAME_LENGTH, minimum: 1}
	validates :password, length:{maximum: MAX_PASSWORD_LENGTH}

	def self.signup(username, pass)
		User.create(:user => username, :password => pass, :count => 1)
	end

	def self.login(username, pass)
		user = User.new(:user => username, :password => pass, :skip_uniq => true)
		if user.valid?
			dummyUser = User.find_by_user_and_password(username, pass)

			if dummyUser.present?
				# if dummyUser != nil
				dummyUser.count += 1
				# end
				dummyUser.save
				dummyUser
			else
				user = User.new
				user.errors.add(:error, "BAD_CREDENT")
				user
			end
		else 
			user
		end	
	end 

	def self.TESTAPI_resetFixture
		User.delete_all
		SUCCESS
	end

end



