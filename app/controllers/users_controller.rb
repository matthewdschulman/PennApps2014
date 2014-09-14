class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  BASE_URL = 'https://tartan.plaid.com/'

  #obviously move these
  CLIENT_ID='541377a9a621710000ff3621' 
  SECRET='fkFfK2SBmrsjFipWzFLFzu'

  ACCESS_TOKEN='bkd2Yk5b4jEvwmxHvtph2ez6unyB58v6'

  #get rid of this var once jeff finishes his MFA stuff
  SAMPLE_JSON_RESPONSE_STR = '{
  "accounts": [
    {
      "_id": "5414d49a62f3e9565f713745",
      "_item": "5414d42462f3e9565f71373f",
      "_user": "5414d42362f3e9565f71373e",
      "balance": {
        "current": 7526.85
      },
      "institution_type": "bofa",
      "meta": {
        "official_name": "BofA Core Checking",
        "number": "0430",
        "name": "BofA Core Checking - 0430",
        "limit": null
      },
      "type": "depository"
    }
  ],
  "transactions": [
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "5414d49a62f3e9565f713746",
      "_id": "5414d49b62f3e9565f71375b",
      "amount": 2.5,
      "date": "2014-09-12",
      "name": "Bank Xpress",
      "meta": {
        "location": {}
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Bank Fees"
      ],
      "category_id": "537426b570d8a0ac65000001"
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "5414d49a62f3e9565f713747",
      "_id": "5414d49b62f3e9565f71375a",
      "amount": 2.5,
      "date": "2014-09-12",
      "name": "Bank Xpress",
      "meta": {
        "location": {}
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Bank Fees"
      ],
      "category_id": "537426b570d8a0ac65000001"
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "5414d49a62f3e9565f713748",
      "_id": "5414d49b62f3e9565f71375e",
      "amount": 388.93,
      "date": "2014-09-12",
      "name": "Discover Des:e Payment Id:xxxxx Indn:schulman Matthew Id:xxxxx20270 Web",
      "meta": {
        "location": {
          "state": "CO"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Payment"
      ],
      "category_id": "53742c114fd7f2f065000001"
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "5414d49a62f3e9565f713749",
      "_id": "5414d49b62f3e9565f713759",
      "amount": 2400,
      "date": "2014-09-09",
      "name": "Check 104",
      "meta": {
        "location": {}
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Transfer",
        "Withdrawal",
        "Check"
      ],
      "category_id": "53742da54fd7f2f065000003"
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "5414d49a62f3e9565f71374a",
      "_id": "5414d49b62f3e9565f713762",
      "amount": 40,
      "date": "2014-09-07",
      "name": "Atm Withdrawal",
      "meta": {
        "location": {
          "state": "PA",
          "city": "Philadelphia"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Transfer",
        "Withdrawal",
        "ATM"
      ],
      "category_id": "5374277870d8a0ac6500001c"
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "53d0b8e0fec6ea8842d9abcc",
      "_id": "5414d49b62f3e9565f713755",
      "amount": 17.8,
      "date": "2014-09-02",
      "name": "amazon.com",
      "meta": {
        "location": {
          "state": "WA",
          "city": "Seattle",
          "address": "1512 2 Nd Ave"
        },
        "contact": {
          "website": "amazon.com"
        }
      },
      "pending": false,
      "score": {
        "master": 0.5,
        "detail": {
          "identifier": 1,
          "website": 1
        }
      },
      "type": {
        "primary": "digital",
        "secondary": "unresolved"
      },
      "category": [
        "Miscellaneous"
      ],
      "category_id": "52544965f71e87d007000088"
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "5414d49b62f3e9565f71374c",
      "_id": "5414d49b62f3e9565f71375d",
      "amount": -446.24,
      "date": "2014-09-02",
      "name": "Venmo Des:cashout Id:xxxxx787 Indn:matt Schulman Id:xxxxx81992 Ccd",
      "meta": {
        "location": {
          "state": "CO"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Transfer",
        "Deposit"
      ],
      "category_id": "5374271970d8a0ac6500000a"
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "53d15d2bb53d3bdd207c0661",
      "_id": "5414d49b62f3e9565f713757",
      "amount": 94.85,
      "date": "2014-08-29",
      "name": "amzn.com",
      "meta": {
        "location": {},
        "contact": {
          "website": "amzn.com"
        }
      },
      "pending": false,
      "score": {
        "master": 0.5,
        "detail": {
          "identifier": 1,
          "website": 1
        }
      },
      "type": {
        "primary": "digital",
        "secondary": "unresolved"
      }
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "53d0b8e0fec6ea8842d9abcc",
      "_id": "5414d49b62f3e9565f713758",
      "amount": 23.91,
      "date": "2014-08-29",
      "name": "amazon.com",
      "meta": {
        "location": {
          "state": "WA",
          "city": "Seattle",
          "address": "1512 2 Nd Ave"
        },
        "contact": {
          "website": "amazon.com"
        }
      },
      "pending": false,
      "score": {
        "master": 0.5,
        "detail": {
          "identifier": 1,
          "website": 1
        }
      },
      "type": {
        "primary": "digital",
        "secondary": "unresolved"
      },
      "category": [
        "Miscellaneous"
      ],
      "category_id": "52544965f71e87d007000088"
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "53d0b8e0fec6ea8842d9abcc",
      "_id": "5414d49b62f3e9565f713756",
      "amount": 15.31,
      "date": "2014-08-29",
      "name": "amazon.com",
      "meta": {
        "location": {
          "state": "WA",
          "city": "Seattle",
          "address": "1512 2 Nd Ave"
        },
        "contact": {
          "website": "amazon.com"
        }
      },
      "pending": false,
      "score": {
        "master": 0.5,
        "detail": {
          "identifier": 1,
          "website": 1
        }
      },
      "type": {
        "primary": "digital",
        "secondary": "unresolved"
      },
      "category": [
        "Miscellaneous"
      ],
      "category_id": "52544965f71e87d007000088"
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "5414d49b62f3e9565f713750",
      "_id": "5414d49b62f3e9565f71375c",
      "amount": 526.57,
      "date": "2014-08-28",
      "name": "Discover Des:e Payment Id:xxxxx Indn:schulman Matthew Id:xxxxx20270 Web",
      "meta": {
        "location": {
          "state": "CO"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Payment"
      ],
      "category_id": "53742c114fd7f2f065000001"
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "5414d49b62f3e9565f713751",
      "_id": "5414d49b62f3e9565f713763",
      "amount": 260,
      "date": "2014-08-23",
      "name": "Atm Withdrawal",
      "meta": {
        "location": {
          "state": "PA",
          "city": "Philadelphia"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Transfer",
        "Withdrawal",
        "ATM"
      ],
      "category_id": "5374277870d8a0ac6500001c"
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "5414d49b62f3e9565f713752",
      "_id": "5414d49b62f3e9565f71375f",
      "amount": 500.14,
      "date": "2014-08-20",
      "name": "Discover Des:e Payment Id:xxxxx Indn:schulman Matthew Id:xxxxx20270 Web",
      "meta": {
        "location": {
          "state": "CO"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Payment"
      ],
      "category_id": "53742c114fd7f2f065000001"
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "5414d49b62f3e9565f713753",
      "_id": "5414d49b62f3e9565f713761",
      "amount": 20,
      "date": "2014-08-15",
      "name": "Atm Withdrawal",
      "meta": {
        "location": {
          "state": "CA",
          "city": "San Francisco"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Transfer",
        "Withdrawal",
        "ATM"
      ],
      "category_id": "5374277870d8a0ac6500001c"
    },
    {
      "_account": "5414d49a62f3e9565f713745",
      "_entity": "5414d49b62f3e9565f713754",
      "_id": "5414d49b62f3e9565f713760",
      "amount": -2336.34,
      "date": "2014-08-15",
      "name": "Microsoft Des:edipayment Id:xxxxx81114280 P8 Indn:schulman Matthew Id:xxxxx44442 Ppd",
      "meta": {
        "location": {
          "state": "CO"
        }
      },
      "pending": false,
      "score": {
        "master": 0
      },
      "type": {
        "primary": "unresolved"
      },
      "category": [
        "Transfer",
        "Deposit"
      ],
      "category_id": "5374271970d8a0ac6500000a"
    }
  ],
  "access_token": "WyI1NDEzNzdhOWE2MjE3MTAwMDBmZjM2MjEiLCI1NDE0ZDQyMzYyZjNlOTU2NWY3MTM3M2UiLCI1NDE0ZDQyNDYyZjNlOTU2NWY3MTM3M2YiXQ=="
}'
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @transactions_hash_arr = transactions_hash_arr
  end

  def transactions_hash_arr
    json_data = JSON.parse(@user.most_recent_plaid_sync)
    transactions_arr = Array.new
    json_data["transactions"].each do |transaction|
      if transaction["amount"] > 0
        
        amount = transaction["amount"].to_s
        if transaction["amount"].to_s.index(".") == nil 
          amount = "#{amount}.00"
        elsif (transaction["amount"].to_s.size - transaction["amount"].to_s.index(".") - 1) == 1
          amount = "#{amount}0"
        end
        
        cents = (eval(amount).to_i + 1 - eval(amount)).round(2)

        if cents == 1.0
          cents = "0.00"
        elsif (cents.to_s.size - cents.to_s.index(".") - 1) == 1
          cents = "#{cents}0"
        end

        cur_hash = {:name => transaction["name"], :date => transaction["date"], :amount => amount, :roundup => cents} 
        transactions_arr << cur_hash
      end
    end
    transactions_arr
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
    #delete the next line after jeff finishes his mfa stuff
    @user.update_attribute(:most_recent_plaid_sync, SAMPLE_JSON_RESPONSE_STR)
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
end