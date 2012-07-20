class SessionsController < ApplicationController
  protect_from_forgery
  include SessionsHelper

  def new
    @user = User.new
  end

  def create
    user = User.find_by_email(params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      sign_in user
      redirect_to(root_path, :notice => 'Authorized PASS')
    else
      redirect_to(signin_path, :notice => 'Authorized FAILED')
    end
  end

  def destroy
    sign_out
    redirect_to(signin_path, :notice => 'Logout PASS')
  end
end