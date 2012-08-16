class TransactionsController < ApplicationController
  include SessionsHelper
  before_filter :get_account_list,  only: [:index, :new, :create, :edit, :update]
  before_filter :get_transaction_type_list,  only: [:new, :create, :edit, :update]
  before_filter :get_transaction_by_id,  only: [:show, :edit, :update, :destroy]

  def index
    @transactions = current_user.transaction.with_type.with_account.order("date desc,id desc").all
  end

  def show
  end

  def new
    default = {account_id:  @accounts.first.id, transaction_type_id: 1, date: DateTime.current().to_s(:db)}
    @transaction = Transaction.new(default)
  end

  def create
    @transaction = current_user.transaction.build(params[:transaction])

    @transaction.amount = @transaction.amount.to_f*100

    if @transaction.save
      redirect_to(root_path, :notice => 'Transaction was successfully created.')
    else
      render :new
    end
  end

  def edit
  end

  def update
    params[:transaction][:amount] = params[:transaction][:amount].to_f*100

    if @transaction.update_attributes(params[:transaction])
      redirect_to(root_path, :notice => 'Transaction was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    respond_to do |format|
      if @transaction.destroy
        format.html { redirect_to(root_path, :notice => 'Transaction was successfully delete.') }
        format.json { render json: params }
      else
        format.html :show
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def get_account_list
    @accounts = current_user.account.all
  end

  def get_transaction_type_list
    @transaction_types = TransactionType.all
  end

  def get_transaction_by_id
    @transaction = @transaction = current_user.transaction.find_by_id(params[:id])

    if @transaction.nil?
      redirect_to transactions_path, alert: "Can't get such transaction."
    end
  end

end