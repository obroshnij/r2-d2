object :@report, root: nil

extends 'legal/pdf_reports/_base'

attributes :order

node(:pages) do |r|
  sorted_keys = r.pages.keys.sort_by { |k| r.order.index(k) || 99999 }

  sorted_keys.map do |key|
    val = r.pages[key]
    result = {
      id:          key,
      name:        val['page'],
      title:       val['page'].titleize,
      type:        val['type'],
      exported_at: Time.parse(val['exported_at']).strftime('%b/%d/%Y, %H:%M'),
      items:       val['data'].count
    }
    if result[:name] == 'order_list'
      result[:order_list_items] = val['data'].map { |d| d['Items'].count }.inject(:+)
    end
    result
  end
end
