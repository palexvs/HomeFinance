class AnalyticsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :json

  def index
    @start_date = 3.month.ago.beginning_of_week

    category_date_amount = current_user.transactions.amount_by_day(@start_date)
    categories = current_user.categories.outlay.order("depth DESC")
    categories = categories.each_with_object({ }){ |r, h| h[r.id] = r.attributes }

    days = (Time.now - @start_date).to_i / 86400 + 1
    data_h = Hash.new{|hp,kp| hp[kp] = { value: [0] * days, sum: 0 } }
    data_h[:summary][:meta] = {name: "Summary", depth: 0}
    categories.each do |id,c|
      (@start_date.to_date..Date.today).each_with_index do |d,i|
        data_h[id][:value][i] += category_date_amount[id][d]
        data_h[id][:meta] = c

        data_h[c["parent_id"] || :summary][:value][i] += data_h[id][:value][i]
      end
    end

    @data = {
      start_date: @start_date.to_a[3..5].reverse,
      data: data_h
    }

    respond_with(@data)
  end

  def accounts
    @period = process_period(params[:period], 1.month.ago.to_date, Date.today)

    accounts = current_user.accounts
    transactions = current_user.transactions.period(@period[:start], @period[:finish]).order("date DESC")

    @data = {
      start_date: @period[:start],
      finish_date: @period[:finish],
      accounts: accounts.map { |a| {id: a.id, name: a.name, cents: a.balance_cents, currency_symbol: a.balance.currency.symbol} },
      transactions: transactions.map { |t| {id: t.id, date: t.date, type_id: t.transaction_type_id, cents: t.amount_cents, account_id: t.account_id, t_cents: t.trans_amount_cents, t_account_id: t.trans_account_id, } }
    }

    respond_with(@data)
  end

  def month
    @period = process_period(params[:period], 1.month.ago.to_date, Date.today)

    outlay_amount_by_category = current_user.transactions.outlay.amount_by_category(@period[:start],@period[:finish])
    outlay_categories = current_user.categories.outlay.order("depth DESC")
    outlay_categories_sum = sumarize_categories_tree(outlay_categories, outlay_amount_by_category)

    income_amount_by_category = current_user.transactions.income.amount_by_category(@period[:start],@period[:finish])
    income_categories = current_user.categories.income.order("depth DESC")
    income_categories_sum = sumarize_categories_tree(income_categories, income_amount_by_category)

    @data = {
      start_date: [@period[:start].year, @period[:start].month, @period[:start].day],
      outlay: { data: get_parent_categories(outlay_categories_sum) },
      income: { data: get_parent_categories(income_categories_sum) }
    }

    respond_with(@data)
  end  

  private

  def process_period(input_period, def_start, def_finish)
    def_period = {start: def_start, finish: def_finish}

    return def_period if !input_period

    alert = "Start date is incorect" if input_period[:start].blank? || input_period[:start].is_a?(Date)
    alert = "Finish date is incorect" if input_period[:finish].blank? || input_period[:finish].is_a?(Date)
    alert = "Start date can't be > then Finish date" if input_period[:start] > input_period[:finish]

    if alert
      def_period[:alert] = alert
      def_period
    else
      { start: params[:period][:start].to_date,
        finish: params[:period][:finish].to_date }
    end
  end

  def get_parent_categories(categories_tree)
    categories_tree.select { |id,v| v["depth"] == 0 && v["sum"] != 0}
                    .values.map { |v| [v["name"], v["sum"] ] }
                    .sort {|x,y| x[1] <=> y[1] }
  end

  def sumarize_categories_tree(categories, data)
    categories = categories.each_with_object({ }){ |r, h| h[r.id] = r.attributes.merge("sum" => 0) }
    categories.each do |id, c|
      c["sum"] += data[id] || 0
      categories[c["parent_id"]]["sum"] += c["sum"] if c["parent_id"]
    end
  end
end