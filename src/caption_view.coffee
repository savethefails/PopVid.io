class CaptionView extends Backbone.View

  el: 'textarea'

  duration: 2
  ENTER: 13
  ESC: 27
  done: false

  events:
    'keydown': 'onKeyDownTextarea'
    'blur': 'onBlur'

  initialize: (options = {}) ->

    @model = options.model
    @player = options.player
    @parentView = options.parentView
    @startTime = options.startTime
    @initialState = @player.getPlayerState()
    @backupCaption = @model.get @startTime
    @$el.data('current-view', @cid)
    # console.log 'CREATE view', @cid, "-- #{@model.get(@startTime)}"
    @listenTo @parentView, 'change:currentTime', @onTimeChange

  render: ->
    @$el.val @model.get "#{@startTime}"

  onTimeChange: (currentTime) ->
    @currentTime = currentTime
    @leave() if currentTime >= @startTime + @duration
    @leave() if currentTime < @startTime


  onKeyDownTextarea: (e) =>
    if e.keyCode is @ENTER
      e.preventDefault()
      @$el.blur()
      return false

    if e.keyCode is @ESC
      e.preventDefault()
      @_preventWrite = true
      @$el.blur()
      delete @_preventWrite
      # console.log @_preventWrite
      return false

  onBlur: =>
    if @_preventWrite
      @resetCaption()
    else
      @saveCaption()

    @player.playVideo() if @player.getPlayerState() isnt YT.PlayerState.PLAYING

  saveCaption: => @model.set("#{@startTime}", val) if (val = @$el.val()) isnt ''

  resetCaption: => @$el.val @backupCaption if @backupCaption?

  delete: =>
    # console.log ''
    # console.log "deleting --- #{@model.get("#{@startTime}")}"
    @model.unset("#{@startTime}")
    @leave()

  leave: ->
    # console.log @currentTime, 'LEAVE', @cid, "-- #{@model.get(@startTime)}"
    # console.log ''
    @undelegateEvents()
    @stopListening @parentView
    # Another view may have control of this view
    if @$el.data('current-view') is @cid
      @$el.val('')
      @$el.blur()
    @done = true