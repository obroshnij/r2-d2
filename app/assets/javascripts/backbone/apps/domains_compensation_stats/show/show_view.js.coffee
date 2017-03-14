@Artoo.module 'DomainsCompensationStatsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.LayoutView
    template: 'domains_compensation_stats/show/layout'

    regions:
      panelRegion:  '#panel-region'
      searchRegion: '#search-region'
      statsRegion:  '#stats-region'


  class Show.Panel extends App.Views.ItemView
    template: 'domains_compensation_stats/show/panel'


  class Show.StatsView extends App.Views.LayoutView
    template: 'domains_compensation_stats/show/stats'

    regions:
      countByDept:             '#count-by-dept'
      amountByProduct:         '#amount-by-product'
      creditsAmountByDept:     '#credits-amount-by-dept'
      clientSatisfationByDept: '#client-satisfaction-by-dept'
      freeItemsCountByProduct: '#free-items-count-by-product'
      countByTiersEnabled:     '#count-by-tiers-enabled'
      issueTypesByProduct:     '#issue-types-by-product'

    onShow: ->
      countByDeptView = new Show.CountByDept model: @model
      @countByDept.show countByDeptView

      amountByProductView = new Show.AmountByProduct model: @model
      @amountByProduct.show amountByProductView

      creditsAmountByDeptView = new Show.CreditsAmountByDept model: @model
      @creditsAmountByDept.show creditsAmountByDeptView

      clientSatisfationByDeptView = new Show.ClientSatisfationByDept model: @model
      @clientSatisfationByDept.show clientSatisfationByDeptView

      freeItemsCountByProductView = new Show.FreeItemsCountByProduct model: @model
      @freeItemsCountByProduct.show freeItemsCountByProductView

      countByTiersEnabledView = new Show.CountByTiersEnabled model: @model
      @countByTiersEnabled.show countByTiersEnabledView

      issueTypesByProductView = new Show.IssueTypesByProduct model: @model
      @issueTypesByProduct.show issueTypesByProductView

    onDomRefresh: ->
      new Foundation.Tabs @$('#compensation-reports')

    onDestroy: ->
      @$('#compensation-reports').foundation 'destroy'


  class Show.CountByDept extends App.Views.ItemView
    template: 'domains_compensation_stats/show/_count_by_dept'

    modelEvents:
      'change': 'render'

    onDomRefresh: ->
      ctx  = document.getElementById('count-by-dept-chart').getContext('2d')
      data = @model.get('count_by_dept').filter (i) -> i.department isnt 'Total'

      new Chart ctx,
        type: 'bar'
        data:
          labels: data.map (i) -> i.department
          datasets: [
            label: 'Correct'
            data: data.map (i) -> i.correct
            backgroundColor: '#43AC6A'
          ,
            label: 'Incorrect'
            data: data.map (i) -> i.incorrect
            backgroundColor: '#f04124'
          ,
            label: 'Pending'
            data: data.map (i) -> i.pending
            backgroundColor: '#a0d3e8'
          ,
            label: 'Total'
            data: data.map (i) -> i.total
            backgroundColor: '#008CBA'
          ]


  class Show.AmountByProduct extends App.Views.ItemView
    template: 'domains_compensation_stats/show/_amount_by_product'

    modelEvents:
      'change': 'render'

    onDomRefresh: ->
      ctx   = document.getElementById('amount-by-product-chart').getContext('2d')
      data  = @model.get('amount_by_product').filter (i) -> i.product isnt 'Total'
      total = @model.get('amount_by_product').find((i) -> i.product is 'Total').total.replace(/[$,]/g, '')

      new Chart ctx,
        type: 'doughnut'
        data:
          labels: data.map (i) -> i.product
          datasets: [{
            data: data.map (i) -> (
              val = Number(i.total.replace(/[$,]/g, ''))
              Math.round(val / total * 10000) / 100
            )
            backgroundColor: [
              '#008CBA',
              '#e5e500',
              '#f04124',
              '#43AC6A',
              '#f08a24',
              '#a0d3e8',
              '#800080'
            ]
          }]
        options:
          tooltips:
            custom: (tooltip) ->
              if tooltip.body
                text = tooltip.body[0].lines[0]
                tooltip.body[0].lines[0] = "#{text}%"
              if tooltip.width
                tooltip.width += 10


  class Show.CreditsAmountByDept extends App.Views.ItemView
    template: 'domains_compensation_stats/show/_credits_amount_by_dept'

    modelEvents:
      'change': 'render'

    onDomRefresh: ->
      ctx1   = document.getElementById('credits-amount-by-dept-one').getContext('2d')
      data1  = @model.get('credits_amount_by_dept').filter (i) -> i.department isnt 'Total'
      total1 = @model.get('credits_amount_by_dept').find((i) -> i.department is 'Total').total.replace(/[$,]/g, '')

      ctx2     = document.getElementById('credits-amount-by-dept-two').getContext('2d')
      products = @model.get('credits_amount_by_dept').find((i) -> i.department is 'Total').products
      data2    = products.filter (i) -> i.product isnt 'Total'
      total2   = products.find((i) -> i.product is 'Total').amount.replace(/[$,]/g, '')

      new Chart ctx1,
        type: 'doughnut'
        data:
          labels: data1.map (i) -> i.department
          datasets: [{
            data: data1.map (i) -> (
              val = Number(i.total.replace(/[$,]/g, ''))
              Math.round(val / total1 * 10000) / 100
            )
            backgroundColor: [
              '#008CBA',
              '#e5e500',
              '#f04124',
              '#43AC6A',
              '#f08a24',
              '#a0d3e8',
              '#800080',
              '#ff8da1',
              '#008080'
            ]
          }]
        options:
          tooltips:
            custom: (tooltip) ->
              if tooltip.body
                text = tooltip.body[0].lines[0]
                tooltip.body[0].lines[0] = "#{text}%"
              if tooltip.width
                tooltip.width += 10

      new Chart ctx2,
        type: 'doughnut'
        data:
          labels: data2.map (i) -> i.product
          datasets: [{
            data: data2.map (i) -> (
              val = Number(i.amount.replace(/[$,]/g, ''))
              Math.round(val / total2 * 10000) / 100
            )
            backgroundColor: [
              '#008CBA',
              '#e5e500',
              '#f04124',
              '#43AC6A',
              '#f08a24',
              '#a0d3e8',
              '#800080',
              '#ff8da1',
              '#008080'
            ]
          }]
        options:
          tooltips:
            custom: (tooltip) ->
              if tooltip.body
                text = tooltip.body[0].lines[0]
                tooltip.body[0].lines[0] = "#{text}%"
              if tooltip.width
                tooltip.width += 10


  class Show.ClientSatisfationByDept extends App.Views.ItemView
    template: 'domains_compensation_stats/show/_client_satisfaction_by_dept'

    modelEvents:
      'change': 'render'

    onDomRefresh: ->
      ctx  = document.getElementById('client-satisfaction-by-dept-chart').getContext('2d')
      data = @model.get('client_satisfaction_by_dept').filter (i) -> i.department isnt 'Total'

      new Chart ctx,
        type: 'bar'
        data:
          labels: data.map (i) -> i.department
          datasets: [
            label: 'Yes'
            data: data.map (i) -> i.count.satisfied
            backgroundColor: '#43AC6A'
          ,
            label: 'No'
            data: data.map (i) -> i.count.not_satisfied
            backgroundColor: '#f04124'
          ,
            label: 'Not Sure'
            data: data.map (i) -> i.count.not_sure
            backgroundColor: '#a0d3e8'
          ]


  class Show.FreeItemsCountByProduct extends App.Views.ItemView
    template: 'domains_compensation_stats/show/_free_items_count_by_product'

    modelEvents:
      'change': 'render'

    events:
      'click .product-element' : 'toggleClicked'

    toggleClicked: (e)->
      $element = $(e.currentTarget)

      unless $element.hasClass('detailed-empty')
        $detailed = $element.next().next()
        $detailed.toggleClass                      'expanded'
        $element.find('a.toggle').toggleClass      'expanded'
        $element.find('a.toggle icon').toggleClass 'fa-rotate-180'

    onDomRefresh: ->
      ctx1   = document.getElementById('free-items-count-by-product-one').getContext('2d')
      depts  = @model.get('free_items_count_by_product').find((i) -> i.product is 'Total').depts
      data1  = depts.filter (i) -> i.name isnt 'Total'
      total1 = depts.find((i) -> i.name is 'Total').count

      ctx2   = document.getElementById('free-items-count-by-product-two').getContext('2d')
      data2  = @model.get('free_items_count_by_product').filter (i) -> i.product isnt 'Total'
      total2 = @model.get('free_items_count_by_product').find((i) -> i.product is 'Total').total

      new Chart ctx1,
        type: 'doughnut'
        data:
          labels: data1.map (i) -> i.name
          datasets: [{
            data: data1.map (i) -> (
              Math.round(i.count / total1 * 10000) / 100
            )
            backgroundColor: [
              '#008CBA',
              '#e5e500',
              '#f04124',
              '#43AC6A',
              '#f08a24',
              '#a0d3e8',
              '#800080',
              '#ff8da1',
              '#008080'
            ]
          }]
        options:
          tooltips:
            custom: (tooltip) ->
              if tooltip.body
                text = tooltip.body[0].lines[0]
                tooltip.body[0].lines[0] = "#{text}%"
              if tooltip.width
                tooltip.width += 10

      new Chart ctx2,
        type: 'doughnut'
        data:
          labels: data2.map (i) -> i.product
          datasets: [{
            data: data2.map (i) -> (
              Math.round(i.total / total2 * 10000) / 100
            )
            backgroundColor: [
              '#008CBA',
              '#e5e500',
              '#f04124',
              '#43AC6A',
              '#f08a24',
              '#a0d3e8',
              '#800080',
              '#ff8da1',
              '#008080'
            ]
          }]
        options:
          tooltips:
            custom: (tooltip) ->
              if tooltip.body
                text = tooltip.body[0].lines[0]
                tooltip.body[0].lines[0] = "#{text}%"
              if tooltip.width
                tooltip.width += 10


  class Show.CountByTiersEnabled extends App.Views.ItemView
    template: 'domains_compensation_stats/show/_count_by_tiers_enabled'

    modelEvents:
      'change': 'render'

    onDomRefresh: ->
      ctx   = document.getElementById('count-by-tiers-enabled-chart').getContext('2d')
      data  = @model.get('count_by_tiers_enabled').filter (i) -> i.tier isnt 'Total'
      total = @model.get('count_by_tiers_enabled').find((i) -> i.tier is 'Total').total

      new Chart ctx,
        type: 'doughnut'
        data:
          labels: data.map (i) -> i.tier
          datasets: [{
            data: data.map (i) -> i.total
            backgroundColor: [
              '#008CBA',
              '#e5e500',
              '#f04124',
              '#43AC6A',
              '#f08a24',
              '#a0d3e8'
            ]
          }]


  class Show.IssueTypesByProduct extends App.Views.ItemView
    template: 'domains_compensation_stats/show/_issue_types_by_product'

    modelEvents:
      'change': 'render'

    onDomRefresh: ->
      ctx  = document.getElementById('issue-types-by-product-chart').getContext('2d')
      data = @model.get('issue_types_by_product').filter (i) -> i.product isnt 'Total'

      new Chart ctx,
        type: 'bar'
        data:
          labels: data.map (i) -> i.product
          datasets: [
            label: "'Subjective' issues"
            data: data.map (i) -> i.types.find((i) -> i.name is "'Subjective' issues").count
            backgroundColor: '#43AC6A'
          ,
            label: 'System bugs'
            data: data.map (i) -> i.types.find((i) -> i.name is 'System bugs').count
            backgroundColor: '#f04124'
          ,
            label: 'Human factor errors / Service not working as expected'
            data: data.map (i) -> i.types.find((i) -> i.name is 'Human factor errors / Service not working as expected').count
            backgroundColor: '#a0d3e8'
          ]


  class Show.SearchSchema extends Marionette.Object

    form:
      buttons:
        primary:   'Search'
        cancel:    false
        placement: 'left'
      syncingType: 'buttons'
      focusFirstInput: false
      search: true

    schema: ->
      [
        legend:    'Filters'
        isCompact: true

        fields: [
          name:     'date_range'
          label:    'Date Range'
          type:     'date_range_picker'
        ]
      ]
