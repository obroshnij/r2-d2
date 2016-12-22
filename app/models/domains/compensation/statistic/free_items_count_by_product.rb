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
    Domains::Compensation::NamecheapProduct.where.not(id: 8)
  end

  def services(compensations)
    values = []

    departments.each do |d|
      services_count(compensations, d).each_pair { |k, v| values << {name: k, depts: [{name: d, count: v}]} }
    end
    services_count(compensations).each_pair do |k, v|
      values << { name: k, depts: [{ name: 'Total', count: v }] }
    end
    values.group_by {|h| h[:name] }.map { |_, hs| hs.reduce {|accum, value| accum.merge(value) {|key, old, new| old.is_a?(Array) && new.is_a?(Array) ? old + new : new }}}
  end

  def services_count(compensations, department=nil)
    with_services = compensations.eager_load(:service_compensated)
    with_services = with_services.where(department: department)  if department
    with_services.group('domains_nc_services.name').count.delete_if { |k, v| k.nil?}
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
    by_product = compensations.where(product_compensated_id: product.id)

    departments.each do |dept|
      dept_product_compensations = by_product.where(department: dept)
      items[:depts] << {name: dept, count: dept_product_compensations.count}
    end

    items[:depts] << {name: 'Total', count: by_product.count}
    { product: product.name, total: by_product.count, services: services(by_product) }.merge items
  end

  def count_total_cases(compensations)
    items = { depts: [] }

    departments.each do |dept|
      items[:depts] << {name: dept, count: compensations.where(department: dept).count}
    end

    items[:depts] << {name: 'Total', count: compensations.count}

    { product: 'Total', total: compensations.count, services: services(compensations) }.merge items
  end

end
