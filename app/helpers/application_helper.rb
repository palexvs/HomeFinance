module ApplicationHelper

  def select_period(selected_period = nil)
    periods_array = (1..(Date.today.month)).map { |month| [Date.new(2012, month, 1), Date.new(2012, month, 1)] }
    selected_period ||= Date.today.at_beginning_of_month
    select(Transaction, 'period', options_for_select(periods_array.reverse, selected_period)).html_safe
  end

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip Devise :timeout and :timedout flags
      next if type == :timeout
      next if type == :timedout
      type = :success if type == :notice
      type = :error if type == :alert
      text = content_tag(:div,
                         content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                             message, :class => "alert fade in alert-#{type}")
      flash_messages << text if message
    end
    flash_messages.join("\n").html_safe
  end

  def glyph(*names)
    content_tag :i, nil, :class => names.map { |name| "icon-#{name.to_s.gsub('_', '-')}" }
  end

end
