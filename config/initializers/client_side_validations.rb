# ClientSideValidations Initializer

# Uncomment to disable uniqueness validator, possible security issue
ClientSideValidations::Config.disabled_validators = []

# Uncomment to validate number format with current I18n locale
# ClientSideValidations::Config.number_format_with_locale = true

# Uncomment the following block if you want each input field to have the validation messages attached.
#
# Note: client_side_validation requires the error to be encapsulated within
# <label for="#{instance.send(:tag_id)}" class="message"></label>
#
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  unless html_tag =~ /^<label/
    %{<div class="field_with_errors" message="#{instance.error_message.first}">#{html_tag}</div>}.html_safe
  else
    %{#{html_tag}}.html_safe
  end
end

