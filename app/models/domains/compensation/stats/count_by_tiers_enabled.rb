class Domains::Compensation::Stats::CountByTiersEnabled

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
    Domains::Compensation.where(created_at: @start_date..@end_date)
  end

  def tier_pricings
    Domains::Compensation::TierPricing.all
  end

  def count_cases product, compensations
    items = {pricings: []}
    tier_pricings.each { |p| items[:pricings] << { name: p.name, count: compensations.where(product_id: product.id, tier_pricing_id: p.id).count } }
    by_product = compensations.where(product_id: product.id)
    { product_id: product.id, product: product.name, total: by_product.count }.merge items
  end

  def count_total_cases(compensations)
    { product: 'Total', total: compensations.where('tier_pricing_id IS NOT NULL').count }
  end

end
