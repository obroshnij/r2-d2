class Domains::Compensation::Stats::CreditsAmountByDept

  def initialize start_date, end_date
    @start_date, @end_date = start_date, end_date
  end

  def data
    items = compensations
    departments.map { |dept| count_cases(dept, items) } + [count_total_cases(items)]
  end

  private

  def products
    Domains::Compensation::NamecheapProduct.all
  end

  def compensations
    Domains::Compensation.where(created_at: @start_date..@end_date)
  end

  def departments
    Domains::Compensation.select(:department).distinct.pluck(:department).sort
  end

  def count_cases dept, compensations
    items = {products: []}
    products.each { |product| items[:products] << { product: product.name, product_id: product.id, amount: compensations.where(product_id: product.id, department: dept).sum(:compensation_amount) } }
    by_dept = compensations.where(department: dept)
    { department: dept, total: by_dept.sum(:compensation_amount) }.merge items
  end

  def count_total_cases(compensations)
    { product: 'Total', total: compensations.sum(:compensation_amount) }
  end

end
