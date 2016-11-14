class Domains::Compensation::Stats::FreeItemsCountByProduct

  def initialize start_date, end_date
    @start_date, @end_date = start_date, end_date
  end

  def data
    items = compensations
    products.map { |product| count_cases(product, items) } + [count_total_cases(items)]
  end

  private

  def products
    Domains::Compensation::NamecheapProduct.all
  end

  def compensations
    Domains::Compensation.eager_load(:compensation_type).where(created_at: @start_date..@end_date)
        .where("domains_compensation_types.name = 'Free item'")
  end

  def departments
    Domains::Compensation.select(:department).distinct.pluck(:department).sort
  end

  def count_cases product, compensations
    items = {deps: []}
    departments.each { |dept| items[:deps] << { name: dept, count: compensations.where(product_id: product.id, department: dept).count} }
    by_product = compensations.where(product_id: product.id)
    { product_id: product.id, product: product.name, total: by_product.count }.merge items
  end

  def count_total_cases(compensations)
    { product: 'Total', total: compensations.count }
  end

end
