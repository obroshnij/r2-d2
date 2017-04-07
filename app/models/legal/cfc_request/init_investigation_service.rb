class Legal::CfcRequest::InitInvestigationService

  def initialize request
    @request = request
  end

  def perform
    ability = Ability.new User.find(request.submitted_by_id)
    form = Legal::CfcRequest::SubmitForm.new nil, ability
    form.submit request_attrs
  end

  private

  attr_reader :request

  def request_attrs
    {
      submitted_by_id:              request.submitted_by_id,
      nc_username:                  request.nc_username,
      signup_date:                  request.signup_date,
      request_type:                 'find_relations',
      find_relations_reason:        'internal_investigation',
      reference:                    request.reference,
      service_type:                 request.service_type,
      domain_name:                  request.domain_name,
      service_id:                   request.service_id,
      pe_subscription:              request.pe_subscription,
      abuse_type:                   request.abuse_type,
      other_description:            request.other_description,
      service_status:               request.service_status,
      service_status_reference:     request.service_status_reference,
      comments:                     request.comments,
      log_comments:                 'Created automatically per request from the submitter',
      investigation_approved_by_id: request.investigation_approved_by_id,
      investigate_unless_fraud:     request.investigate_unless_fraud,
      certainty_threshold:          request.certainty_threshold
    }
  end

end
