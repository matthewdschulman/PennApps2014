namespace :venmo do
  desc "Every week, charge users on venmo for rounded-up change"
  task :weekly_charge => :environment do
    User.find_each do |user|
      parsedResponse = user.parsePlaidForUser(user.access_token)
      response = user.chargeUser(parsedResponse[0], parsedResponse[1])
    end
  end
end


