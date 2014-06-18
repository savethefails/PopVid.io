class CaptionView extends Backbone.View

  el: 'textarea'

  duration: 2
  ENTER: 13
  ESC: 27
  done: false

  events:
    'keydown': 'onKeyDownTextarea'
    'blur': 'saveCaptions'

  initialize: (options = {}) ->
    console.log 'create view', @cid
    @model = options.model
    @player = options.player
    @parentView = options.parentView
    @startTime = options.startTime
    @listenTo @parentView, 'change:currentTime', @onTimeChange

  render: ->
    @$el.val @model.get "#{@startTime}"

  onTimeChange: (currentTime) ->
    console.log 'parentView time', currentTime
    @leave() if currentTime >= @startTime + @duration
    @leave() if currentTime < @startTime


  onKeyDownTextarea: (e) =>
    if e.keyCode is @ENTER
      e.preventDefault()
      @$el.blur()
      return false

  saveCaptions: =>
    @model.set "#{@startTime}", @$el.val()
    @player.playVideo() if @player.getPlayerState() isnt YT.PlayerState.PLAYING

  leave: ->
    console.log 'leave view', @cid, "-- #{@model.get(@startTime)}"
    console.log ''
    @undelegateEvents()
    @stopListening @parentView
    @$el.val('')
    @$el.blur()
    @done = true