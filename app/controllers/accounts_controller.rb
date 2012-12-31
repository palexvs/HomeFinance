class AccountsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_account_by_id, only: [:edit, :show, :update, :destroy]

  respond_to :html, :json

  def index
    @accounts = current_user.accounts.all

    respond_with do |format|
      format.json { render json: @accounts.to_json(:methods => [:balance]) }
    end
  end

  def new
    @account = Account.new
    respond_with(@account)
  end

  def edit
  end

  def create
    @account = current_user.accounts.build(params[:account], :balance => 0)

    flash[:notice] = 'Account was successfully created.' if @account.save

    respond_with(@account, :location => accounts_path)
  end

  def update
    flash[:notice] = 'Account was successfully updated.' if @account.update_attributes(params[:account])

    respond_with(@account, :location => accounts_path)
  end

  def destroy
    flash[:notice] = 'Account was successfully deleted.' if @account.destroy

    respond_with(@account)
  end

  private

  def get_account_by_id
    @account = current_user.accounts.find_by_id(params[:id])

    if @account.nil?
      redirect_to accounts_path, alert: "Can't get such account."
    end
  end
end
