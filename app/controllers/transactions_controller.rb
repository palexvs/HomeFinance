class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.with_type.with_account.order("date desc,id desc").all
    @accounts = Account.all
  end
    
  def show
    @transaction = Transaction.with_type.with_account.find(params[:id])
  end

  def new
    @transaction = Transaction.new
    @transaction_types = TransactionType.all
    @accounts = Account.all
    
    @transaction.account_id = 1
    @transaction.transaction_type_id = 1
    
    @transaction.date = DateTime.current().to_s(:db)
  end
    
  def create
    @transaction = Transaction.new(params[:transaction])
    @transaction_types = TransactionType.all
    @accounts = Account.all
    
    @transaction.amount = @transaction.amount.to_f*100
    
    if @transaction.save
      redirect_to(root_path, :notice => 'Transaction was successfully created.')
    else
      render :action => "new"
    end
  end
      
  def edit
     @transaction = Transaction.with_type.with_account.find(params[:id])
     @transaction_types = TransactionType.all
     @accounts = Account.all
  end
  
  def update
    @transaction = Transaction.find(params[:id])
    @transaction_types = TransactionType.all
    @accounts = Account.all
    
    params[:transaction][:amount] = params[:transaction][:amount].to_f*100
    
    if @transaction.update_attributes(params[:transaction])
      redirect_to(root_path, :notice => 'Transaction was successfully updated.')
    else
      render :action => "edit"
    end
  end
    
  def destroy
    @transaction = Transaction.with_type.find(params[:id])
    
    respond_to do |format|
      if @transaction.destroy
        format.html { redirect_to(root_path, :notice => 'Transaction was successfully delete.') }
        format.json { render json: params }
      else
        format.html { render :action => "show" }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end    

end