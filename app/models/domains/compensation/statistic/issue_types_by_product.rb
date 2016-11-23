class Domains::Compensation::Statistic::IssueTypesByProduct

  def initialize start_date, end_date
    @start_date, @end_date = start_date, end_date
  end

  def data
    items = compensations
    products.map { |product| count_cases(product, items) } + [count_total_cases(items)]
  end

  private

  def products
    Domains::Compensation::AffectedProduct.all
  end

  def compensations
    Domains::Compensation.eager_load(:issue_level).where(created_at: @start_date..@end_date)
  end

  def percent(p1, p2)
    return nil if p2.zero?
    (p1.to_f / p2.to_f * 100.0).round(2)
  end

  def issue_types
    Domains::Compensation::IssueLevel.all
  end

  def count_cases product, compensations
    by_product = compensations.where(affected_product_id: product.id)

    items = { types: [] }

    issue_types.each do |it|
      count = by_product.where(issue_level_id: it.id).count
      items[:types] << { name: it.name.split(' - ').last, count: count, percent: percent(count, by_product.count) }
    end

    items[:types] << { name: 'Total', count: by_product.count, percent: nil }

    { product: product.name, total: by_product.count }.merge items
  end

  def count_total_cases(compensations)
    items = { types: [] }

    issue_types.each do |it|
      count = compensations.where(issue_level_id: it.id).count
      items[:types] << { name: it.name.split(' - ').last, count: count, percent: percent(count, compensations.count) }
    end

    items[:types] << { name: 'Total', count: compensations.count, percent: nil }

    { product: 'Total', total: compensations.count }.merge items
  end

end
