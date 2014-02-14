class UsersController < ApplicationController
  def index
  	@users = User.all
  end

  def login
  	@user = User.login(params[:user], params[:password])
  	err0 = User::SUCCESS
  	if @user.errors.any?
  		err0 = User::ERR_BAD_CREDENTIALS
  	end

  	if err0 > 0
      render json: {:errCode => err0, :count => @user.count}
  	else 
      render json: {:errCode => err0}
  	end
  end

  def add
  	@user = User.signup(params[:user], params[:password] )
  	err1 = User::SUCCESS
  	if @user.present? and @user.errors.any?
  		if @user.errors.messages.keys[0] == :user
  			if @user.errors.messages[:user][0] == "is too long (maximum is 128 characters)"
  				err1 = User::ERR_BAD_USERNAME
  			elsif @user.errors.messages[:user][0] == "has already been taken"
  				err1 = User::ERR_USER_EXISTS                     
  			elsif @user.errors.messages[:user][0] == "can't be blank"
  				err1 = User::ERR_BAD_USERNAME
  			end
      else # @user.errors.messages.keys[0] == :password
        err1 = User::ERR_BAD_PASSWORD
  		end
    end

  	if err1 > 0
      render json: {:errCode => err1, :count => 1}
  	else 
      render json: {:errCode => err1}
  	end
  end

  def resetFixture
    User.TESTAPI_resetFixture
    render json: {:errCode => 1}
  end

  def unitTests
    @unitVal = `ruby -Itest test/unit/user_test.rb`
    @numTests = @unitVal.scan(/^\d+ tests,/)
    @numTests = @numTests.first
    @numTests = @numTests.split
    @numTests = @numTests.first
    @numTests = Integer(@numTests)
    @numFailures = @unitVal.scan(/\s\d+ failures,/)
    @numFailures = @numFailures.first
    @numFailures = @numFailures.split
    @numFailures = @numFailures.first
    @numFailures = Integer(@numFailures)
    render json: {totalTests: @numTests, output: @unitVal, nrFailed: @numFailures}
  end


end
