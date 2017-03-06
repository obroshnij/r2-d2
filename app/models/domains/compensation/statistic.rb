class Domains::Compensation::Statistic

  def initialize date_range = nil
    start_date, end_date = parse_date_range(date_range)
    @start_date = start_date.beginning_of_day
    @end_date   = end_date.end_of_day
  end

  def date_range
    "#{@start_date.strftime('%d %B %Y')} - #{@end_date.strftime('%d %B %Y')}"
  end

  def method_missing name, *args, &block
    klass = "Domains::Compensation::Statistic::#{name.to_s.classify}".constantize
    klass.new(@start_date, @end_date).data
  rescue NameError
    super
  end

  private

  def parse_date_range range
    dates = range.split(' - ')
    raise ArgumentError if dates.count != 2
    dates.map { |d| Date.parse d }
  rescue Exception
    [Date.today.beginning_of_month, Date.today.end_of_month]
  end

end
