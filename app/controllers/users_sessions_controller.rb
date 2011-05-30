class Users::SessionsController < Devise::SessionsController
  def sign_in
puts "in user sessions controller#sign_in"
  end
end

