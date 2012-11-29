class AnalyticsController < ApplicationController
  before_filter :authenticate_user!

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
  end

  def month
    @start_date = 1.month.ago
    amount_by_category = current_user.transactions.amount_by_category(@start_date)
    categories = current_user.categories.outlay.order("depth DESC")
    categories_sum = sumarize_categories_tree(categories, amount_by_category)
    @data = {
      start_date: @start_date.to_a[3..5].reverse,
      data: get_parent_categories(categories_sum)
    }
  end  

  private

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