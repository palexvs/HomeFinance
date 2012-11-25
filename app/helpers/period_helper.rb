module PeriodHelper

  def getCurrentPeriod
    {
      start: Date.today.at_beginning_of_month,
      end: Date.today.at_end_of_month,
    }
  end

  def parse_period(start)
    begin
      {
        start: start.to_datetime,
        end: (start.to_datetime + 1.month)
      }
    rescue ArgumentError, NoMethodError
      getCurrentPeriod()
    end
  end

end