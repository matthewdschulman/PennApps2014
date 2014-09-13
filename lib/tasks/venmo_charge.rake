namespace :venmo do
  desc "Every week, charge users on venmo for rounded-up change"
  task :weekly_charge do
    User.all.each do |user|
      owed = UserController.get_total_owed(user.access_token)
      note = UserController.format_note(user.id)
      response = UserController.charge_user(owed, note, user.id)
    end
  end
end


