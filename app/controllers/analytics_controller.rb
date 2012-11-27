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
    @data = {
      start_date: @start_date.to_a[3..5].reverse,
      data: Transaction.amount_by_category(@start_date)
    }
  end  
end