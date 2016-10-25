class Domains::Compensation::Stats

  def initialize date_range = nil
    @start_date, @end_date = parse_date_range(date_range)
  end

  def date_range
    "#{@start_date.strftime('%d %B %Y')} - #{@end_date.strftime('%d %B %Y')}"
  end

  def method_missing name, *args, &block
    klass = "Domains::Compensation::Stats::#{name.to_s.classify}".constantize
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
