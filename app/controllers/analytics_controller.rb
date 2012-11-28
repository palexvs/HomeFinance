class AnalyticsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @start_date = 3.month.ago.beginning_of_week
    @data = {
      start_date: @start_date.to_a[3..5].reverse,
      data: Transaction.chart_data(@start_date)
    }
  end

  def month
    @start_date = 1.month.ago
    amount_by_category = Transaction.amount_by_category(@start_date)
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