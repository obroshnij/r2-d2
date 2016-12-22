class Domains::Compensation::Statistic::ClientSatisfactionByDept

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
    Domains::Compensation.where(created_at: @start_date..@end_date)
  end

  def percent(p1, p2)
    return nil if p2.zero?
    (p1.to_f / p2.to_f * 100.0).round(2)
  end

  def count_cases dept, compensations
    by_dept       = compensations.where(department: dept)
    satisfied     = by_dept.where(client_satisfied: true).count
    not_satisfied = by_dept.where(client_satisfied: false).count
    not_sure      = by_dept.where(client_satisfied: nil).count

    {
      department: dept,
      count: {
        satisfied:     satisfied,
        not_satisfied: not_satisfied,
        not_sure:      not_sure
      },
      percent: {
        satisfied:     percent(satisfied, by_dept.count),
        not_satisfied: percent(not_satisfied, by_dept.count),
        not_sure:      percent(not_sure, by_dept.count)
      }
    }
  end

  def count_total_cases(compensations)
    satisfied     = compensations.where(client_satisfied: true).count
    not_satisfied = compensations.where(client_satisfied: false).count
    not_sure      = compensations.where(client_satisfied: nil).count

    {
      department:     'Total',
      count: {
        satisfied:     satisfied,
        not_satisfied: not_satisfied,
        not_sure:      not_sure
      },
      percent: {
        satisfied:     percent(satisfied, compensations.count),
        not_satisfied: percent(not_satisfied, compensations.count),
        not_sure:      percent(not_sure, compensations.count)
      }
    }
  end

end
