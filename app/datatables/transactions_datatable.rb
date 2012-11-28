class TransactionsDatatable
  delegate :dom_id, :best_in_place, :link_to, :glyph, :h, to: :@view

  def initialize(view, transactions, accounts, categories)
    @view = view
    @transactions = transactions
    @accounts = accounts.collect{ |u| [u.id,u.name]}
    @categories = {}
    categories.each do |k,v|  
      @categories[k] = v.map { |i| [i.id, "#{'-' * i.depth} #{i.name}"] }
    end
  end

  def as_json(options = {})
    @transactions.map { |transaction| data(transaction) }
  end

private

  def data(transaction)
    {
      date:  best_in_place(transaction, :date, :type => :date),
      desc:  best_in_place(transaction, :text, :type => :input),
      type:  cell_type_name(transaction),
      amount:  cell_amount(transaction),
      account:  cell_account(transaction),
      category: cell_category(transaction),
      control: cell_control(transaction),
      DT_RowClass: transaction.transaction_type_name,
      DT_RowId: dom_id(transaction) 
    }    
  end

  def cell_category(transaction)
    if !transaction.type_transfer?
      best_in_place(transaction, :category_id, :type => :select, :collection => @categories[transaction.transaction_type_name])
    else
      ''
    end
  end

  def cell_type_name(transaction)
    if !transaction.type_transfer?
      transaction.transaction_type_name
    else
      "<div><div>#{transaction.transaction_type_name}</div> <div class='direction'>from:<div class='divider'></div>to:</div></div>"
    end
  end
  
  def cell_amount(transaction)
    if !transaction.type_transfer?
      best_in_place(transaction, :amount, :type => :input)
    else
      '<div><div>' +
      best_in_place(transaction, :amount, :type => :input) +
      '<div class="divider"></div>' +
      best_in_place(transaction, :trans_amount, :type => :input) +
      '</div></div>'
    end
  end

  def cell_account(transaction)
    if !transaction.type_transfer?
      best_in_place(transaction, :account_id, :type => :select, :collection => @accounts)
    else
      '<div><div>' +
      best_in_place(transaction, :account_id, :type => :select, :collection => @accounts) +
      '<div class="divider"></div>' +
      best_in_place(transaction, :trans_account_id, :type => :select, :collection => @accounts) +
      '</div></div>'
    end
  end

  def cell_control(transaction)
    '<ul class="nav nav-pills">' +
    '<li>' + link_to( glyph(:pencil), [:edit, transaction], remote: true, class: "transaction-edit")  + '</li>' +
    '<li>' + link_to( glyph(:trash), transaction, confirm: 'Are you sure?', method: :delete, :remote => true, class: "transaction-delete", "data-type" => :json) + '</li>' +
    '</ul>'
  end

end