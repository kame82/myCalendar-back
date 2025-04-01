class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    puts "Provider: #{auth[:provider]}"
    puts "UID: #{auth[:uid]}"
    puts "Name: #{auth[:info][:name]}"
    puts "Email: #{auth[:info][:email]}"
    redirect_to root_url
  end

  def destroy
  end
end
