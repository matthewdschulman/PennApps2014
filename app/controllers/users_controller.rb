class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  BASE_URL = 'https://tartan.plaid.com/'

  #obviously move these
  CLIENT_ID='541377a9a621710000ff3621' 
  SECRET='fkFfK2SBmrsjFipWzFLFzu'

  ACCESS_TOKEN='bkd2Yk5b4jEvwmxHvtph2ez6unyB58v6'
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    puts "in new..."
  	@user = User.new
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def create
    debugger
    @user = User.new(user_params)
    json_response = add_user(user_params[:bank], user_params[:bank_username], user_params[:bank_password], user_params[:email])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to FoodFeed!"
      redirect_to @user
    else
      render 'new'
    end
  end  

  def add_user(type, username, password, email)
    post('/connect', type, username, password, email)
    debugger
    if @response.code == 201 #mfa
      @user.update_attribute(:access_token => @response.access_token)
      mfa_post(@response)
    elsif @response.code == 200 #we're good
      @user.update_attribute(:access_token => @response.access_token)
      @response
    else #diagnose the error
      if !JSON.parse(@response)["message"].nil?
        flash[:error] = JSON.parse(@response)["message"]
      else 
        flash[:error] = "Error with authentication"
      end
      redirect_to root_url
    end
  end

  def mfa_post(response)
    #get user's answer to current mfa question
    #mfa post
  end

  def post(path, type, username, password, email)
    url = BASE_URL + path
    @response = RestClient.post url, :client_id => CLIENT_ID, :secret => SECRET, :type => type, :credentials => {:username => username, :password => password} ,:email => email
    return @response
  end

  def edit
  end

  def get_total_owed(access_token)
    url = BASE_URL + path
    @response = RestClient.get url, :client_id => CLIENT_ID, :secret => SECRET, :access_token => access_token, :options => {:gte => Date.now - 7}
    return @response
  end

  def charge_user(amount, note, id)
    url = 'https://api.venmo.com/v1/payments'
    @response = RestClient.post url, :access_token => ACCESS_TOKEN, :phone => User.find(id).phone_number, :note => note, :amount => amount
    return @response
  end

  def format_note(id)
    return "test note for now"
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end