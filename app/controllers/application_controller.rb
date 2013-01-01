class ApplicationController < ActionController::Base
  # protect_from_forgery

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

end
