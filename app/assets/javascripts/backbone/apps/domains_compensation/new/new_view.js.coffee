@Artoo.module 'DomainsCompensationApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.LayoutView
    template: 'domains_compensation/new/layout'

    regions:
      formRegion: '#form-region'

  class New.FormSchema extends Marionette.Object

    schema: ->
      [
        legend: 'Reference Info'
        id:     'general'

        fields: [
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
          name:    'product'
          label:   'Product the Cleint had Issues With'
          type:    'collection_radio_buttons'
          options: [
            id:   'domains'
            name: 'Domains'
          ,
            id:   'hosting'
            name: 'Hosting'
          ,
            id:   'ncpe'
            name: 'NCPE'
          ,
            id:   'ssl_namecheap_com'
            name: 'SSL (Namecheap.com)'
          ,
            id:   'ssl_ssls_com'
            name: 'SSL (SSLs.com)'
          ,
            id:   'ssl_sslcertificate_com'
            name: 'SSL (SSLcertificate.com)'
          ,
            id:   'whoisguard'
            name: 'WhoisGuard'
          ,
            id:   'premium_dns'
            name: 'PremiumDNS'
          ,
            id:   'apps'
            name: 'Apps'
          ]
          default: 'domains'
        ,
          name:    'product_compensated'
          label:   'Product Compensated'
          type:    'collection_radio_buttons'
          options: [
            id:   'domains'
            name: 'Domains'
          ,
            id:   'hosting'
            name: 'Hosting'
          ,
            id:   'ncpe'
            name: 'NCPE'
          ,
            id:   'ssl_namecheap_com'
            name: 'SSL (Namecheap.com)'
          ,
            id:   'ssl_ssls_com'
            name: 'SSL (SSLs.com)'
          ,
            id:   'ssl_sslcertificate_com'
            name: 'SSL (SSLcertificate.com)'
          ,
            id:   'whoisguard'
            name: 'WhoisGuard'
          ,
            id:   'premium_dns'
            name: 'PremiumDNS'
          ,
            id:   'apps'
            name: 'Apps'
          ,
            id:   'credit'
            name: 'Credit (funds added to account balance)'
          ]
          hint:    'The product you gave discount for / refunded beyond the refundable period / provided as a compensation. Related services fees should be qualified as the product itself (e.g. for redemption fee waive select Domains, for hosting backup fee waive select Hosting, etc.)'
          default: 'domains'
        ,
          name:    'service_compensated'
          label:   'Service Compensated'
          hint:    'E.g.: redemption fee/value 4g/positive ssl/business office/.club'
        ,
          name:    'issue_level'
          label:   'Issue Level'
          type:    'collection_radio_buttons'
          options: [
            id:   '1'
            name: '1 - \'Subjective\' issues'
          ,
            id:   '2'
            name: '2 - System bugs'
          ,
            id:   '3'
            name: '3 - Human factor errors / Service not working as expected'
          ]
          default: '1'
          hint:    "- 'Subjective' issues - customer overlooked a notification, no fault from our side, not satisfied with the product features, 3rd-party issues, adding funds as a gift\n- System bugs - site, admin, upstream issues, outages/maintenances\n- Human factor errors - staff-related, e.g. service canceled by mistake\n- Service not working as expected - repetitive outages during a short period of time"
        ,
          name:    'compensation_type'
          label:   'Compensation Type'
          type:    'collection_radio_buttons'
          options: [
            id:   '1'
            name: 'Discount'
          ,
            id:   '2'
            name: 'Free item'
          ,
            id:   '3'
            name: 'Service prolongation'
          ,
            id:   '4'
            name: 'Refund'
          ,
            id:   '5'
            name: 'Fee concession'
          ,
            id:   '6'
            name: 'Credit'
          ,
            id:   '7'
            name: 'Tier pricing assginment'
          ]
          hint:    '- Discount - a discount for new purchase/existing service was provided\n- Free item - a free service was provided for the client\n- Service prolongation - upcoming renewal date was shifted and service prolonged\n- Refund - a refund was issued although the client is not eligible for a refund according to our official refund policy\n- Fee concession - a fee was waived or decreased\n- Credit - added funds to account balance'
          default: '1'
        ,
          name:    'is_discount_recurring'
          label:   'Discount is Recurring?'
          type:    'radio_buttons'
          options: [{ name: "Yes", id: true }, { name: "No", id: false }]
          default: 'true'
          dependencies:
            'compensation_type':  value: ['1', '7']
          callback: (fieldValues) ->
            if fieldValues.compensation_type is '7'
              @trigger('disable:options', 'false')
            else
              @trigger('enable:options', 'false')
        ,
          name:    'compensation_usd'
          label:   'Compensation Provided in USD'
          hint:    "If it's a discount indicate the difference between the regular and the discount prices for the service. If the item was given for free enter the full price of the item. If billing date shifted, calculate the prorated amount. In case of a tier assignment leave blank"
          dependencies:
            'compensation_type': value: ['1', '2', '3', '4', '5', '6']
        ,
          name:    'tier_name'
          label:   'Tier Pricing Name'
          dependencies:
            'compensation_type': value: '7'
        ]
      ,
        legend: 'Conclusion'
        id:     'conclusion'

        fields: [
          name:    'is_satisfied'
          label:   'The Client Left Satisfied with the Provided Compensation?'
          type:    'radio_buttons'
          options: [{ name: "Yes", id: true }, { name: "No", id: false }, { name: "I don't know/not sure", id: null }]
          default: 'true'
        ,
          name:    'comments'
          label:   'Additional Comments'
          tagName: 'textarea'
          hint:    'Any comments which would clarify the case. E.g., you can indicate whether the compensation was approved by the SME/SL'
        ]
      ]
