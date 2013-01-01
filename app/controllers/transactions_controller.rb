class TransactionsController < ApplicationController
  include PeriodHelper
  before_filter :authenticate_user!

  before_filter :get_categories_all, only: [:index]
  before_filter :get_account_list,  only: [:index, :new, :create, :edit, :update]
  before_filter :get_transaction_by_id,  only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @period = process_period(params[:period], 1.month.ago.to_date, Date.today)
    @transactions = current_user.transactions.with_type.with_account.with_category.period(@period[:start],@period[:finish])

    respond_with do |format|
      format.html { render partial: 'transaction_list', :locals => { accounts: @accounts, categories: @categories } } if params[:partial]
      format.json { render json: TransactionsDatatable.new(view_context, @transactions, @accounts, @categories ) }
    end
  end

  def show
  end

  def new
    default = {account_id:  @accounts.first.id, date: Date.current().to_s(:db)}
    default[:transaction_type_id] = TransactionType.find_by_name(params[:type]).id

    @transaction = Transaction.new(default)
    @categories = get_category_list(@transaction[:transaction_type_id] - 1)

    respond_with do |format|
      format.html { render partial: transaction_edit_form, locals: {categories: @categories, accounts: @accounts, transaction: @transaction } }
    end
  end

  def create
    @transaction = current_user.transactions.build(params[:transaction])
    @categories = { @transaction.transaction_type_name => get_category_list(@transaction.transaction_type_id - 1) }

    respond_to do |format|
      if @transaction.save
        format.json { render json: TransactionsDatatable.new(view_context, [@transaction], @accounts, @categories ) }
      else
        format.json { render json: @transaction.errors, status: :unprocessable_entity}
      end
    end
  end

  def edit
    @categories = get_category_list(@transaction.transaction_type_id - 1)

    respond_with do |format|
      format.html { render partial: transaction_edit_form, locals: { categories: @categories, accounts: @accounts, transaction: @transaction }}
    end
  end

  def update
    @categories = { @transaction.transaction_type_name => get_category_list(@transaction.transaction_type_id - 1) }

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        format.json { render json: TransactionsDatatable.new(view_context, [@transaction], @accounts, @categories), status: :ok}
      else
        format.json { render json: @transaction.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    flash[:notice] =  'Transaction was successfully delete.'  if @transaction.destroy

    respond_with(@transaction)
  end

  private

  def get_categories_all
    @categories = {
      "outlay" => current_user.categories.outlay.nested_set,
      "income" => current_user.categories.income.nested_set
    }
    redirect_to categories_path+'#outlay', alert: "Please, create at least one outlay categories." if @categories["outlay"].empty?
    redirect_to categories_path+'#income', alert: "Please, create at least one income categories." if @categories["income"].empty?
  end

  def get_category_list(type_id)
    @categories = current_user.categories.where("type_id = ?", type_id).nested_set
  end

  def get_account_list
    @accounts = current_user.accounts.all

    redirect_to accounts_path, alert: "Please, create at least one account." if @accounts.empty?
  end

  def get_transaction_by_id
    @transaction = current_user.transactions.find_by_id(params[:id])

    redirect_to transactions_path, alert: "Can't get such transaction." if @transaction.nil?
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