module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?
    messages = resource.errors.full_messages.join("; ")
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)
    flash.now[:alert] = sentence + messages
  end
end