require 'test_helper'

class UserTest < ActiveSupport::TestCase
	SUCCESS = 1
	ERR_BAD_CREDENTIALS = -1
	ERR_USER_EXISTS = -2
	ERR_BAD_USERNAME = -3
	ERR_BAD_PASSWORD = -4
	MAX_USERNAME_LENGTH = 128
	MAX_PASSWORD_LENGTH = 128

#TEST 1- Ensure signup returns a valid user.
	test "signUpResponse" do 
		User.delete_all
		myUser = User.signup("D", "P")
		assert myUser.valid? == true
	end

#TEST 2- Ensure signup correctly initializes count properly.
	test "signUpCount" do
		User.delete_all
		myUser = User.signup("COUNT", "COUNT")
		assert myUser.count == 1
	end

#TEST 3- Ensure count variable increments properly
	test "multpleLoginCount" do
		User.delete_all
		myUser = User.signup("multi", "") #1
		myUser1 = User.login("multi", "") #2
		myUser2 = User.login("multi", "") #3
		assert myUser2.count == 3
	end

#TEST 4- Ensure signup succeeds with an empty password.
	test "signUpNoPassword" do
		User.delete_all
		myUser = User.signup("D", "")
		assert myUser.valid? == true
	end

#TEST 4- Ensure signup fails with no username
	test "signUpNoUsername" do
		User.delete_all
		myUser = User.signup("", "pass")
		assert myUser.valid? == false
	end

#TEST 5- Ensure the resetFixture responds correctly
	test "resetFixtureResponse" do
		User.delete_all
		testReset = User.TESTAPI_resetFixture
		assert testReset == SUCCESS
	end

#TEST 6- Ensure resetFixtures properly clears the db
	test "resetFixtureWorking" do
		User.delete_all
		User.signup("D","P")
		assert User.all != []

		testReset = User.TESTAPI_resetFixture
		assert User.all == []
	end

#TEST 7- Ensure that login responds with valid User
	test "logInResponse" do
		User.delete_all
		signUp = User.signup("login", "test")
		assert signUp.valid? == true

		logIn = User.login("login", "test")
		assert logIn.valid? == true
	end

#TEST 8- Ensure you cannot login with bad credentials
	test "logInBadCredentials" do
		User.delete_all
		signUp = User.signup("GOOD_USER", "GOOD_PASSWORD")
		assert signUp.valid? == true

		badLogIn = User.login("bad", "bad")
		assert badLogIn.valid? == false
	end

#TEST 9- Ensure singup fails with bad password
	test "signupBadPassword" do
		User.delete_all
		badPass = ""
		i = 1
		while i < 150
			badPass = badPass + "B"
			i += 1
		end
		u = User.signup("user", badPass)
		assert u.errors.messages[:password][0] == "is too long (maximum is 128 characters)"
	end

#TEST 10- Ensure signup fails with bad username
	test "signupBadUser" do
		badUser = ""
		i = 1
		while i < 150
			badUser = badUser + "B"
			i += 1
		end
		u = User.signup(badUser, "password")
		assert u.errors.messages[:user][0] == "is too long (maximum is 128 characters)"
	end

end
