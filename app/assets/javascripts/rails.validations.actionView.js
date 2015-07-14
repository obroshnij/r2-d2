window.ClientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'] = {
  
  add: function(element, settings, message) {
    var formField = element.closest('.form-field');
    if (formField.find('small.error')[0] == null) {
      var small = $('<small></small>').text(message).addClass('error');
      formField.addClass('error');
      formField.append(small);
    } else {
      formField.find('small.error').text(message);
    }
  },

  remove: function(element, settings) {
    var formField = element.closest('.form-field');
    var small = formField.find('small.error');
    if (small[0]) {
      formField.removeClass('error');
      small.remove();
    }
  }
}