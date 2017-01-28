@Artoo.module 'DomainsCompensationApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.LayoutView
    template: 'domains_compensation/new/layout'

    regions:
      formRegion: '#form-region'

  class New.FormSchema extends Marionette.Object

    onShow: ->
      _.defer ->
        $('#compensation_type_id_1').trigger('change')
        $('#product_compensated_id_1').trigger('change')

    schema: ->
      [
        legend: 'Reference Info'
        id:     'general'

        fields: [
          name:     'status'
          type:     'hidden'
          value:    '_new'
        ,
          name:     'submitted_by_id'
          type:     'hidden'
          default:  App.request('get:current:user').id
        ,
          name:    'reference_id'
          label:   'Reference ID'
        ,
          name:    'reference_item'
          label:   'Reference Item'
          type:    'radio_buttons'
          options: [{ name: "Ticket", id: 'ticket' }, { name: "Chat", id: 'chat' }]
          default: 'ticket'
        ]
      ,
        legend: 'Service / Compensation'
        id:     'service-compensation'

        fields: [
          name:    'affected_product_id'
          label:   'Affected Service'
          type:    'collection_radio_buttons'
          options: App.request('domains:compensation:affected:product:entities').toJSON()
          default: '1'
          hint:    'Product the client had issues with'
        ,
          name:    'product_compensated_id'
          label:   'Product Compensated'
          type:    'collection_radio_buttons'
          options: App.request('domains:compensation:product:entities').toJSON()
          default: '1'
          hint:    'The product you gave discount for / refunded beyond the refundable period or against our refund policy / provided as a compensation. Related services fees should be qualified as the product itself (e.g. for redemption fee waive select Domains, for hosting backup fee waive select Hosting, etc.)'
          onChange: () ->
            $('#service_compensated_id').val('').trigger('change')
        ,
          name:    'hosting_type_id'
          label:   'Hosting Type'
          type:    'collection_radio_buttons'
          options: App.request('domains:compensation:hosting:type:entities').toJSON()
          default: '1'
          onChange: () ->
            $('#service_compensated_id').val('').trigger('change')
          dependencies:
            'product_compensated_id': value: '2'
        ,
          name:    'service_compensated_id'
          label:   'Service Compensated'
          tagName: 'select'
          type:    'select2_ajax'
          options: []
          initVal:
            idAttr:   'service_compensated_id'
            textAttr: 'service_compensated'
          url:     '/domains/namecheap_services'
          data:    (data) ->
            search =
              name_cont:     data.term
              product_id_eq: $("[name='product_compensated_id']:checked").val()
            if $('#hosting_type_id_input').is(':visible')
              search.hosting_type_id_eq = $("[name='hosting_type_id']:checked").val()
            q: search
          dependencies:
            'product_compensated_id': value: ['1', '2', '3', '4', '7']
        ,
          name:    'issue_level_id'
          label:   'Issue Level'
          type:    'collection_radio_buttons'
          options: App.request('domains:compensation:issue:level:entities').toJSON()
          default: '1'
          hint:    "- 'Subjective' issues - customer overlooked a notification, no fault from our side, not satisfied with the product features, 3rd-party issues, adding funds as a gift\n- System bugs - site, admin, upstream issues, outages/maintenances\n- Human factor errors - staff-related, e.g. service canceled by mistake\n- Service not working as expected - repetitive outages during a short period of time"
        ,
          name:    'compensation_type_id'
          label:   'Compensation Type'
          type:    'collection_radio_buttons'
          options: App.request('domains:compensation:type:entities').toJSON()
          hint:    '- Discount - a discount for new purchase/existing service was provided\n- Free item - a new service was provided for the client for free\n- Service prolongation - upcoming renewal date of the existing service was shifted and service prolonged\n- Refund - a refund was issued although the client is not eligible for a refund according to our official refund policy\n- Fee concession - a fee was waived or decreased\n- Credit - added funds to account balance'
          default: '1'
          callback: (fieldValues) ->
            if fieldValues.product_compensated_id is '8'
              @trigger('disable:options', ['1', '2', '3', '4', '5', '7'])
              @trigger('enable:options', '6')

            else if fieldValues.product_compensated_id is '1' and $('#service_compensated_id').select2('data')?[0]?.text is 'coupon code NCFREEDOM'
              @trigger('enable:options', ['2'])
              @trigger('disable:options', ['1', '3', '4', '5', '6', '7'])

            else if fieldValues.product_compensated_id is '2' and $('#service_compensated_id').select2('data')?[0]?.text is 'coupon code NCFREEHOST'
              @trigger('enable:options', ['2'])
              @trigger('disable:options', ['1', '3', '4', '5', '6', '7'])

            else
              @trigger('enable:options', ['1', '2', '3', '4', '5', '7'])
              @trigger('disable:options', '6')

        ,
          name:    'discount_recurring'
          label:   'Discount is Recurring?'
          type:    'radio_buttons'
          options: [{ name: "Yes", id: true }, { name: "No", id: false }]
          default: 'true'
          dependencies:
            'compensation_type_id':  value: ['1', '7']
          callback: (fieldValues) ->
            if fieldValues.compensation_type_id is '7'
              @trigger('disable:options', 'false')
            else
              @trigger('enable:options', 'false')
        ,
          name:    'compensation_amount'
          label:   'Compensation Provided in USD'
          hint:    "If it's a discount indicate the difference between the regular and the discount prices for the service. If the item was given for free enter the full price of the item. If billing date shifted, calculate the prorated amount. In case of a tier assignment leave blank"
          callback: (fieldValues) ->
            if fieldValues.product_compensated_id is '1' and $('#service_compensated_id').select2('data')?[0]?.text is 'coupon code NCFREEDOM'
              @trigger('disable:input', '20')
            else if fieldValues.product_compensated_id is '2' and $('#service_compensated_id').select2('data')?[0]?.text is 'coupon code NCFREEHOST'
              @trigger('disable:input', '29.88')
            else
              @trigger('enable:input')

          dependencies:
            'compensation_type_id': value: ['1', '2', '3', '4', '5', '6']
        ,
          name:    'tier_pricing_id'
          tagName: 'select'
          type:    'select2'
          label:   'Tier Pricing Name'
          options: App.request('domains:compensation:tier:pricing:entities').toJSON()
          dependencies:
            'compensation_type_id': value: '7'
        ]
      ,
        legend: 'Conclusion'
        id:     'conclusion'

        fields: [
          name:    'client_satisfied'
          label:   'The Client Left Satisfied with the Provided Compensation?'
          type:    'radio_buttons'
          options: [{ name: "Yes", id: true }, { name: "No", id: false }, { name: "I don't know/not sure", id: "n/a" }]
          default: 'true'
        ,
          name:    'comments'
          label:   'Additional Comments'
          tagName: 'textarea'
          hint:    'Any comments which would clarify the case. E.g., you can indicate whether the compensation was approved by the SME/SL'
        ]
      ]
