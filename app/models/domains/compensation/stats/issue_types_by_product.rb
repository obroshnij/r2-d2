class Domains::Compensation::Stats::IssueTypesByProduct

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
    Domains::Compensation.eager_load(:issue_level).where(created_at: @start_date..@end_date)
  end

  def percent(p1, p2)
    (p1.to_f / p2.to_f * 100.0).round(2)
  end

  def issue_types
    Domains::Compensation::IssueLevel.all
  end

  def count_cases product, compensations
    by_product = compensations.where(product_id: product.id)
    items = {types: []}
    issue_types.each do |it|
      count = compensations.where(product_id: product.id, issue_level_id: it.id).count
      items[:types] << { name: it.name, count: count, percent: percent(count, by_product.count) }
    end
    { product_id: product.id, product: product.name, total: by_product.count }.merge items
  end

  def count_total_cases(compensations)
    { product: 'Total', total: compensations.count }
  end

end
