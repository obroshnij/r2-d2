class Domains::Compensation::Statistic::CreditsAmountByDept

  include ActionView::Helpers::NumberHelper

  def initialize start_date, end_date
    @start_date, @end_date = start_date, end_date
  end

  def data
    items = compensations
    departments.map { |dept| count_cases(dept, items) } + [count_total_cases(items)]
  end

  private

  def products
    Domains::Compensation::AffectedProduct.all
  end

  def compensations
    Domains::Compensation.where(created_at: @start_date..@end_date, compensation_type_id: 6)
  end

  def departments
    Domains::Compensation.select(:department).distinct.pluck(:department).sort
  end

  def count_cases dept, compensations
    items = { products: [] }

    products.each do |product|
      items[:products] << {
        product: product.name,
        amount:  number_to_currency(compensations.where(affected_product_id: product.id, department: dept).sum(:compensation_amount))
      }
    end

    items[:products] << {
      product: 'Total',
      amount: number_to_currency(compensations.where(department: dept).sum(:compensation_amount))
    }

    by_dept = compensations.where(department: dept)

    {
      department: dept,
      total: number_to_currency(by_dept.sum(:compensation_amount))
    }.merge items
  end

  def count_total_cases(compensations)
    items = { products: [] }

    products.each do |product|
      items[:products] << {
        product: product.name,
        amount:  number_to_currency(compensations.where(affected_product_id: product.id).sum(:compensation_amount))
      }
    end

    items[:products] << {
      product: 'Total',
      amount: number_to_currency(compensations.sum(:compensation_amount))
    }

    {
      department: 'Total',
      total: number_to_currency(compensations.sum(:compensation_amount))
    }.merge items
  end

end
