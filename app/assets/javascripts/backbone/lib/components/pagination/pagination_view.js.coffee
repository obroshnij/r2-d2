@Artoo.module "Components.Pagination", (Pagination, App, Backbone, Marionette, $, _) ->
  
  class Pagination.PaginationView extends App.Views.ItemView
    template: 'pagination/pagination'
    
    className: 'clearfix'
    
    events:
      'click a.previous'    : 'getPreviousPage'
      'click a.page-number' : 'getPage'
      'click a.next'        : 'getNextPage'
      'keypress .per-page'  : 'setPerPage'
      
    getPreviousPage: (event) ->
      @collection.getPreviousPage()
      
    getPage: (event) ->
      @collection.getPage +event.target.text
      
    getNextPage: (event) ->
      @collection.getNextPage()
      
    setPerPage: (event) ->
      if event.keyCode is 13
        perPage = parseInt(event.target.value) || 25
        @collection.setPageSize perPage
    
    collectionEvents:
      'sync'                  : 'render'
      'collection:sync:start' : 'syncStart'
      'collection:sync:stop'  : 'syncStop'
      
    syncStart: ->
      @addOpacityWrapper()
      
    syncStop: ->
      @addOpacityWrapper false
      
    onDestroy: ->
      @addOpacityWrapper false
    
    totalItems: ->
      @collection.state.totalRecords
      
    pageSize: ->
      @collection.state.pageSize
      
    firstItemNumber: ->
      @_itemNumberOffset() + 1
      
    lastItemNumber: ->
      last = @_itemNumberOffset() + @perPage()
      if last < @totalItems() then last else @totalItems()
      
    _itemNumberOffset: ->
      (@currentPage() - 1) * @perPage()
      
    currentPage: ->
      @collection.state.currentPage
    
    totalPages: ->
      @collection.state.totalPages
      
    perPage: ->
      @collection.state.pageSize
      
    getPagesArray: (totalPages = @totalPages(), currentPage = @currentPage(), sideOffset = 2) ->
      if totalPages <= 2 * sideOffset + 5                   # too few pages, display them all
        startPage = 1
        endPage   = totalPages
      else if currentPage <= sideOffset + 3                 # currentPage is too close to the beginning
        startPage = 1
        endPage   = sideOffset + 5
      else if currentPage >= totalPages - (sideOffset + 2)  # currentPage is too close to the end
        startPage = totalPages - (sideOffset + 4)
        endPage   = totalPages
      else                                                  # regular case
        startPage = currentPage - sideOffset
        endPage   = currentPage + sideOffset
      
      result = []
      
      result.push 1           if startPage > 1
      result.push "..."       if startPage > 2
      
      result.push [startPage..endPage]
      
      result.push "..."       if endPage < totalPages - 1
      result.push totalPages  if endPage < totalPages
      
      _.flatten result
    
    serializeData: ->
      firstItemNumber:    @firstItemNumber()
      lastItemNumber:     @lastItemNumber()
      totalItems:         @totalItems()
      paginationRequired: @totalPages() > 1
      pagesArray:         @getPagesArray()
      currentPage:        @currentPage()
      previousIsDisabled: @currentPage() is 1
      nextIsDisabled:     @currentPage() is @totalPages()
      perPage:            @perPage()