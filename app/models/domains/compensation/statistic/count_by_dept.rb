class Domains::Compensation::Statistic::CountByDept

  def initialize start_date, end_date
    @start_date, @end_date = start_date, end_date
  end

  def data
    items = compensations
    departments.map { |dept| count_cases(dept, items) } + [count_total_cases(items)]
  end

  private

  def departments
    Domains::Compensation.select(:department).distinct.pluck(:department).sort
  end

  def compensations
    Domains::Compensation.where(created_at: @start_date..@end_date).select(:reference_id).distinct
  end

  def count_cases dept, compensations
    by_dept = compensations.where(department: dept)
    {
      department: dept,
      total:      by_dept.count,
      correct:    by_dept.where(used_correctly: true).count,
      incorrect:  by_dept.where(used_correctly: false).count,
      pending:    by_dept.where(used_correctly: nil).count
    }
  end

  def count_total_cases compensations
    {
      department: "Total",
      total:      compensations.count,
      correct:    compensations.where(used_correctly: true).count,
      incorrect:  compensations.where(used_correctly: false).count,
      pending:    compensations.where(used_correctly: nil).count
    }
  end

end
