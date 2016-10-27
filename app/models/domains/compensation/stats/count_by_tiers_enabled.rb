class Domains::Compensation::Stats::CountByTiersEnabled

  def initialize start_date, end_date
    @start_date, @end_date = start_date, end_date
  end

  def data
    items = compensations
    tier_pricings.map { |tier| count_cases(tier, items) } + [count_total_cases(items)]
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

  def count_cases tier, compensations
    by_tier = compensations.where(tier_pricing_id: tier.id)
    { tier_id: tier.id, tier: tier.name, total: by_tier.count }
  end

  def count_total_cases(compensations)
    { product: 'Total', total: compensations.where('tier_pricing_id IS NOT NULL').count }
  end

end
