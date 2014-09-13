class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  BASE_URL = 'https://tartan.plaid.com/'

  #obviously move these
  CLIENT_ID='541377a9a621710000ff3621' 
  SECRET='fkFfK2SBmrsjFipWzFLFzu'
  
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
    @user = User.new(user_params)
    json_response = add_user(params[:user][:bank], params[:user][:bank_username], params[:user][:bank_password], params[:user][:email])
    
    @user.update_attribute(:most_recent_plaid_sync, json_response)
    
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to GoodCents!"
      redirect_to @user
    else
      render 'new'
    end
  end  

  def add_user(type, username, password, email)
    post('/connect', type, username, password, email)
    if @response.code == 201 #mfa
      
      @user.update_attribute(:access_token, JSON.parse(@response)["access_token"])
      
      mfa_post(@response)
      
      @response #temporary!!! 
    elsif @response.code == 200 #we're good
      @user.update_attribute(:access_token, JSON.parse(@response)["access_token"])
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

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

            def user_params
              params.require(:user).permit(:name, :email, :password,
                                           :password_confirmation,
                                           :phone_number)



            end

            # Before filters

            def correct_user
              @user = User.find(params[:id])
              redirect_to(root_url) unless current_user?(@user)
            end

            def admin_user
              redirect_to(root_url) unless current_user.admin?
            end
end