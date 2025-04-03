class UsersController < ApplicationController

  def index;end

  def show;end

  def create;end

  def update;end

  def destroy;end

  def current
    puts "------------------------****************"
    if @current_user
      render json: {user: @current_user}
    else
      render json: {error: '認証情報を取得できません'}, status: :unauthorized
    end
  end
end
