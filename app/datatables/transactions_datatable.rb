class TransactionsDatatable
  delegate :dom_id, :best_in_place, :link_to, :glyph, :h, to: :@view

  def initialize(view, transaction, accounts)
    @view = view
    @transaction = transaction
    @accounts = accounts
  end

  def as_json(options = {})
    {
        date:  best_in_place(@transaction, :date, :type => :date),
        desc:  best_in_place(@transaction, :text, :type => :input),
        type:  @transaction.transaction_type_name,
        amount:  best_in_place(@transaction, :amount, :type => :input),
        account:  best_in_place(@transaction, :account_id, :type => :select, :collection => @accounts.collect{ |u| [u.id,u.name]}),
        category: @transaction.category_name,
        control: cotrols(),
        DT_RowClass: @transaction.transaction_type_name,
        DT_RowId: dom_id(@transaction) 
    }
  end

private

  def cotrols
    '<ul class="nav nav-pills">' +
    '<li>' + link_to( glyph(:pencil), [:edit, @transaction], remote: true, class: "transaction-edit")  + '</li>' +
    '<li>' + link_to( glyph(:trash), @transaction, confirm: 'Are you sure?', method: :delete, :remote => true, class: "transaction-delete", "data-type" => :json) + '</li>' +
    '</ul>'
  end

end