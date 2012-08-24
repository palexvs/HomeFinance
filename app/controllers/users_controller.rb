class UsersController < ApplicationController
  include SessionsHelper

  def new
    @user = User.new
  end

  def show
    @user = User.find_by_id(params[:id])

    if @user != current_user
      redirect_to root_path, alert: "Can't get such profile."
    end
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to(signin_path, :notice => 'Successfully registered. Please, Login now')
    else
      render 'sessions/new'
    end    
  end
end
