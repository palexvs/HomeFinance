class AnalyticsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @start_date = 1.month.ago
    @data = {
      start_date: @start_date.to_a[3..5].reverse,
      data: Transaction.chart_data(@start_date)
    }

  end
end