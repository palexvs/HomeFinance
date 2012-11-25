module ApplicationHelper

  def select_period(selected_period = nil)
    periods_array = (1..(Date.today.month)).map { |month| [Date.new(2012,month,1), Date.new(2012,month,1)] }
    selected_period ||=  Date.today.at_beginning_of_month
    select(Transaction, 'period', options_for_select(periods_array.reverse, selected_period)).html_safe
  end

end
