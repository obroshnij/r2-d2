class Domains::Compensation::Statistic::FreeItemsCountByProduct

  def initialize start_date, end_date
    @start_date, @end_date = start_date, end_date
  end

  def data
    items = compensations
    products.map { |product| count_cases(product, items) } + [count_total_cases(items)]
  end

  private

  def products
    Domains::Compensation::NamecheapProduct.where.not(id: 10)
  end

  def compensations
    Domains::Compensation.eager_load(:compensation_type).where(created_at: @start_date..@end_date)
        .where("domains_compensation_types.name = 'Free item'")
  end

  def departments
    Domains::Compensation.select(:department).distinct.pluck(:department).sort
  end

  def count_cases product, compensations
    items = { depts: [] }

    departments.each do |dept|
      items[:depts] << { name: dept, count: compensations.where(product_id: product.id, department: dept).count }
    end

    items[:depts] << { name: 'Total', count: compensations.where(product_id: product.id).count }

    by_product = compensations.where(product_id: product.id)

    { product: product.name, total: by_product.count }.merge items
  end

  def count_total_cases(compensations)
    items = { depts: [] }

    departments.each do |dept|
      items[:depts] << { name: dept, count: compensations.where(department: dept).count }
    end

    items[:depts] << { name: 'Total', count: compensations.count }

    { product: 'Total', total: compensations.count }.merge items
  end

end
