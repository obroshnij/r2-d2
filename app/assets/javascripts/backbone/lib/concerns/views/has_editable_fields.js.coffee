@Artoo.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->
  
  Concerns.HasEditableFields =
          
    onShow: ->
      @manageEditables()
              
    manageEditables: ->
      @$(".editable .value").each (index, element) =>
        text = $(element).text()
        truncated = @truncateLines(text)
        unless text.length is truncated.length
          $(element).data 'text', text
          $(element).html "<span>" + truncated + "\n</span><a class='toggle'><i class='fa fa-angle-double-down'></i></a>"
          
      @$(".toggle").on 'click', (event) =>
        $val = $(event.target).closest('.value')
        
        if $val.find('a').hasClass('expanded')
          $val.find('span').html @truncateLines($val.data('text')) + "\n"
        else
          $val.find('span').html "<textarea>#{$val.data('text')}</textarea>"
          
        $val.find('a').toggleClass 'expanded'
        $val.find('i').toggleClass 'fa-rotate-180'
            
    truncateLines: (text, count = 3) ->
      lines = s.lines(text)
      if lines.length <= count
        s.truncate(text, 250).trim()
      else
        _.first(lines, count).join("\n") + "..."