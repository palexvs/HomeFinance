class AccountsController < ApplicationController
  include SessionsHelper
  before_filter :get_account_by_id, only: [:edit, :show, :update, :destroy]

  def index
    @accounts = current_user.account.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accounts }
    end
  end

  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @account }
    end
  end

  def edit
  end

  def create
    @account = current_user.account.build(params[:account], :balance => 0)

    respond_to do |format|
      if @account.save
        format.html { redirect_to accounts_path, notice: 'Account was successfully created.' }
        format.json { render json: @account, status: :created, location: @account }
      else
        format.html "new"
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to accounts_path, notice: 'Account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html :edit
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url }
      format.json { head :no_content }
    end
  end

  private

  def get_account_by_id
    @account = current_user.account.find_by_id(params[:id])

    if @account.nil?
      redirect_to accounts_path, alert: "Can't get such account."
    end
  end
end
