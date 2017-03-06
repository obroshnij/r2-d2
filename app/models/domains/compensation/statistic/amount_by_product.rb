class Domains::Compensation::Statistic::AmountByProduct

  include ActionView::Helpers::NumberHelper

  def initialize start_date, end_date
    @start_date, @end_date = start_date, end_date
  end

  def data
    items = compensations
    products.map { |product| count_cases(product, items) } + [count_total_cases(items)]
  end

  private

  def products
    Domains::Compensation::NamecheapProduct.where.not(id: 8)
  end

  def compensations
    Domains::Compensation.where(created_at: @start_date..@end_date, compensation_type_id: [1, 2, 3, 4, 5])
  end

  def count_cases product, compensations
    by_product = compensations.where(affected_product_id: product.id)
    {
      product_id: product.id,
      product: product.name,
      total: number_to_currency(by_product.sum(:compensation_amount))
    }
  end

  def count_total_cases(compensations)
    {
      product: 'Total',
      total: number_to_currency(compensations.sum(:compensation_amount))
    }
  end

end
