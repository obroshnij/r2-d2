class Legal::PdfReport::Handler

  include ActiveModel::Model
  include ActiveModel::Validations

  def initialize user_id
    @report = Legal::PdfReport.find_by edited_by: user_id
    errors.add(:base, "Can't find any reports marked for edit") unless @report.present?
  end

  def import params
    return false if errors.present?

    hash = hash_from_params params
    if hash.values.any?(&:blank?) || params[:id].blank?
      errors.add(:base, "Ivalid data received ") 
    end

    return false if errors.present?

    @report.pages[params[:id]] = hash
    @report.save
  end

  def hash_from_params params
    data = if params[:data].is_a?(Array)
      params[:data]
    elsif params[:data].is_a?(Hash)
      params[:data].values
    else
      nil
    end

    {
      type:        params[:type],
      page:        params[:page],
      data:        data,
      exported_at: Time.now.as_json
    }
  end

end
