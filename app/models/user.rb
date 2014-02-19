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

# Method login. Params: username- string, pass- string
	def self.login(username, pass)
		#Create the new user object (skipping the test for unique). We will not save this user.
		user = User.new(:user => username, :password => pass, :skip_uniq => true)
		
		#A little hack-y, but this is how we use the controller to check validity
		#If the user is valid, we then proceed to check if the user exists in the database.
		if user.valid?
			dummyUser = User.find_by_user_and_password(username, pass)
			if dummyUser.present?
				dummyUser.count += 1
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

#resetFixture clears the User database
	def self.TESTAPI_resetFixture
		User.delete_all
		SUCCESS
	end

end



