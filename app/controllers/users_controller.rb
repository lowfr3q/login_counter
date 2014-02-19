class UsersController < ApplicationController
  def index
  	@users = User.all
  end

#Login asks the model for a new User and confirms that it is error free. Else, it records and error in @err0
  def login
  	@user = User.login(params[:user], params[:password])
  	@err0 = User::SUCCESS
  	if @user.errors.any?
  		@err0 = User::ERR_BAD_CREDENTIALS
  	end

  	if @err0 > 0
      # return @user
      render :landingpage#json: {:errCode => err0, :count => @user.count}
  	else 
      render :index #json: {:errCode => err0}
  	end
  end

#Add asks the model to sign-up a new User view the signup method. The bulk of the error reporting code is here, and again
#is recorded in err0
  def add
  	@user = User.signup(params[:user], params[:password] )
  	@err0 = User::SUCCESS
  	if @user.present? and @user.errors.any?
  		if @user.errors.messages.keys[0] == :user
  			if @user.errors.messages[:user][0] == "is too long (maximum is 128 characters)"
  				@err0 = User::ERR_BAD_USERNAME
  			elsif @user.errors.messages[:user][0] == "has already been taken"
  				@err0 = User::ERR_USER_EXISTS                     
  			elsif @user.errors.messages[:user][0] == "can't be blank"
  				@err0 = User::ERR_BAD_USERNAME
  			end
      else # @user.errors.messages.keys[0] == :password
        @err0 = User::ERR_BAD_PASSWORD
  		end
    end

  	if @err0 > 0
      # return @user
      render :landingpage#json: {:errCode => @err0, :count => 1}
  	else 
      render :index#json: {:errCode => @err0}
  	end
  end

#resetFixture resets the database and reports a success code if the operation completes.
  def resetFixture
    User.TESTAPI_resetFixture
    render json: {:errCode => 1}
  end


  def unitTests
    myUnitTests = `ruby -Itest test/unit/user_test.rb`
    myTestCount = myUnitTests.scan(/^\d+ tests,/)
    myTestCount = myTestCount.first
    myTestCount = myTestCount.split
    myTestCount = myTestCount.first
    myTestCount = Integer(myTestCount)
    myFailCount = myUnitTests.scan(/\s\d+ failures,/)
    myFailCount = myFailCount.first
    myFailCount = myFailCount.split
    myFailCount = myFailCount.first
    myFailCount = Integer(myFailCount)
    render json: {totalTests: myTestCount, output: myUnitTests, nrFailed: myFailCount}

  end


end
