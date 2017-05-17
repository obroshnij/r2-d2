class Legal::CfcRequestSerializer < ApplicationSerializer

  has_many :relations
  has_many :logs

  attrs = Legal::CfcRequest.attribute_names + [
    :submitted_by,
    :processed_by,
    :verified_by,
    :investigation_approved_by,
    :previous_relations,
    :previous_find_relations_requests_count
  ]

  attributes *attrs

  methods = [
    :submitted_by,
    :processed_by,
    :verified_by,
    :investigation_approved_by
  ]

  methods.each do |method_name|
    define_method method_name do
      object.send(method_name).try(:name)
    end
  end

  def created_at
    object.created_at.strftime '%b/%d/%Y, %H:%M'
  end

  def processed_at
    object.processed_at.try :strftime, '%b/%d/%Y, %H:%M'
  end

  def verified_at
    object.verified_at.try :strftime, '%b/%d/%Y, %H:%M'
  end

  def signup_date
    object.signup_date.strftime '%b/%d/%Y'
  end

  def previous_find_relations_requests_count
    object.previous_find_relations_requests.count
  end

  def previous_relations
    object.previous_find_relations_requests.map do |r|
      {
        created_at:   r.created_at.strftime('%b/%d/%Y, %H:%M'),
        processed_at: r.processed_at.try(:strftime, '%b/%d/%Y, %H:%M'),
        processed_by: r.processed_by.try(:name),
        relations:    r.relations.as_json(methods: [:relation_type_ids])
      }
    end
  end

end
