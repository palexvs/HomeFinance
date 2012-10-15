class TransactionsController < ApplicationController
  before_filter :loged_in
  before_filter :get_account_list,  only: [:index, :new, :create, :edit, :update]
  before_filter :get_transaction_by_id,  only: [:show, :edit, :update, :destroy]

  def index
    @transactions = current_user.transaction.with_type.with_account.all
    respond_to do |format|
      if params[:partial]
        format.html { render partial: 'transaction_list', :locals => { accounts: @accounts } }
      else
        format.html # index.html.erb
      end
    end
  end

  def show
  end

  def new
    default = {account_id:  @accounts.first.id, date: Date.current().to_s(:db)}
    default[:transaction_type_id] = TransactionType.find_by_name(params[:type]).id

    @transaction = Transaction.new(default)

    respond_to do |format|
      format.html { render partial: transaction_edit_form, locals: { accounts: @accounts, transaction: @transaction } }
      format.json { render :ok }
    end
  end

  def create
    @transaction = current_user.transaction.build(params[:transaction])

    respond_to do |format|
      if @transaction.save
#        format.json { render json: @transaction, status: :created }
        format.json { head :no_content }
      else
        format.json { render json: @transaction.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html { render partial: transaction_edit_form, locals: { accounts: @accounts, transaction: @transaction }}
    end
  end

  def update
    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
#        format.html { redirect_to(@transaction, :notice => 'Transaction was successfully updated.') }
        format.json { head :no_content }
#        format.json { respond_with_bip(@user) }
      else
#        format.html { render :action => "edit" }
        format.json { render :json => @transaction.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @transaction.destroy
#        format.html { redirect_to(root_path, :notice => 'Transaction was successfully delete.') }
        format.json { render json: params }
      else
#        format.html :show
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def get_account_list
    @accounts = current_user.account.all
    if @accounts.empty? 
      redirect_to accounts_path, alert: "Please, create at least one account."
    end
  end

  def get_transaction_by_id
    @transaction = current_user.transaction.find_by_id(params[:id])

    if @transaction.nil?
      redirect_to transactions_path, alert: "Can't get such transaction."
    end
  end

  def transaction_edit_form
    case @transaction.transaction_type_name
      when 'outlay'
        return 'edit_outlay'
      when 'income'
        return 'edit_income'
      when 'transfer'
        return 'edit_transfer'
    end
  end

end