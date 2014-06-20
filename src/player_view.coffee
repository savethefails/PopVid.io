class PlayerView extends Backbone.View
  currentTime: -1
  video: 'JsdAwdhd0Aw'
  youtubeURL: 'https://www.youtube.com/watch?v='

  el: 'body'

  events:
    'click .close': 'onCloseClick'
    'focus textarea': 'onFocusTextarea'
    'blur textarea': 'onBlurTextarea'
    'mouseenter textarea': 'onmouseenter'
    'mouseleave textarea': 'onmouseleave'
    'mouseenter .centererer': 'onmouseenter'
    'mouseleave .centererer': 'onmouseleave'
    'submit form': 'onFormSubmit'

  playerVars: =>
    start = if @video is 'JsdAwdhd0Aw' then 2 else 0

    controls: 1
    iv_load_policy: 3
    autoplay: 1
    autohide: 1
    modestbranding: 1
    rel: 0
    showinfo: 0
    start: start

  initialize: ->
    return @redirectToVideo() unless @getQueryString().v?

    $('html').on 'keydown', @onKeyDownHTML
    @on 'change:currentTime', @onTimeChange
    @initVideo()
    window.onYouTubeIframeAPIReady = @setupYoutube
    $('input').val "#{@youtubeURL}#{@video}"

  initVideo: ->
    @getVideoIdFromLocation()
    @preloadCaps()
    @model = new CaptionsModel @getSavedCaps(), video: @video

  getVideoIdFromLocation: -> @video = @getQueryString().v

  getVideoIdFromInput: ->
    split = @$('input').val().match(/.*v=(\w*)\W*/, '')
    @video = split[1] if split?

  getSavedCaps: ->
    savedCaptions = if localStorage[@video]? then JSON.parse localStorage[@video] else {}

  preloadCaps: ->
    localStorage[@video] = JSON.stringify(@[@video]) if @[@video]? and not localStorage[@video]?

  mockupPlayer: =>
    @player =
      count: -1
      state: 1
      getCurrentTime: ->
        # console.log 'before',@count
        @count += 1 if @state is 1
        # console.log 'after',@count
        # console.log 'time', (@count * 0.5)
        return (@count * 0.5)
      getPlayerState: -> @state
      pauseVideo: -> @state = 0
      playVideo: -> @state = 1

    window.YT =
      PlayerState:
        PAUSE: 0
        PLAYING: 1

    setInterval @getCurrentTime, 500

  width: "640"
  height: "390"

  setupYoutube: =>
    @player = new YT.Player "player",
      height: @height
      width: @width
      videoId: @video
      playerVars: @playerVars()

    @player.addEventListener 'onReady', @onPlayerReady

  onPlayerReady: (event) =>
    @player.setPlaybackQuality 'large'
    @_intervalId = setInterval @getCurrentTime, 250

  roundToHalfSecond: (input) => @roundToFractionOfSecond(input, 2)
  roundToThirdSecond: (input) => @roundToFractionOfSecond(input, 3)

  roundToFractionOfSecond: (input, timesPerSecond = 2) ->
    output = Math.floor input # strip decimals
    remainder = input % 1 # get remainder
    fractionOfSecond = (Math.floor((1/timesPerSecond) * 100))/100

    for i in [0..timesPerSecond-1]
      cutoff = (i * fractionOfSecond) + (fractionOfSecond/2)
      cutoff = (Math.floor(cutoff * 1000))/1000
      output += fractionOfSecond if remainder >= cutoff

    return output

  getCurrentTime: =>
    playerTime = @player.getCurrentTime()
    roundTime = @roundToThirdSecond playerTime
    if @currentTime isnt roundTime
      _oldTime = @currentTime
      @currentTime = roundTime
      @trigger 'change:currentTime', @currentTime, _oldTime
      # console.log 'currentTime', @currentTime


  onKeyDownHTML: (e) =>
    return unless e.target.tagName == 'BODY'
    @createCaptionsView()
    @$('textarea').focus()
    @$el.addClass('reveal');
    @player.pauseVideo()

  onFocusTextarea: ->
    @createCaptionsView()
    @player.pauseVideo()
    @$el.addClass('reveal');

  onBlurTextarea: ->
    setTimeout =>
      @$el.removeClass('reveal');
    , 50

  onCloseClick: ->
    # console.log '-----------------'
    # console.log ''
    # console.log '** onCloseClick'
    @captionsView?.delete()

  createCaptionsView: ->
    if not @captionsView? or @captionsView.done
      @captionsView = new CaptionView
                              parentView: @
                              model: @model
                              player: @player
                              startTime: @currentTime
    return @captionsView


  onTimeChange: (current, old) =>
    if @model.get(current)
      # console.log "@#{current}) FOUND -- #{@model.get(current)} -- currentView: #{@captionsView?}"
      @captionsView?.leave()
      @createCaptionsView().render()

  onmouseenter: ->
    return if @player.getPlayerState() is 5
    clearTimeout @_revealTimer
    @$el.addClass('reveal')

  onmouseleave: ->
    return if @$('textarea').is(":focus")
    @_revealTimer = setTimeout =>
                      @$el.removeClass('reveal')
                    , 50

  onFormSubmit: (e) ->
    e.preventDefault()
    @getVideoIdFromInput()
    @redirectToVideo()

  JsdAwdhd0Aw: {"11":"smells ok...","20":"c'mon I can take ya","5.33":"holy crap","7.66":"what's that?","13.99":"ERMAHGERD!!","17.659999999999997":"stay still!","22.659999999999997":"don't you get any closer","25.33":"nope","28.33":"skat","30.33":"(note the studio lighting...)","3.99":"doo doo doo","35.33":"outta here junior","43.989999999999995":"what's that thing again?","46.66":"ERMAGHERD!!","53.33":"[exit stage left]"}

  # http://stackoverflow.com/a/647272
  getQueryString: ->
    result = {}
    queryString = location.search.slice(1)
    re = /([^&=]+)=([^&]*)/g
    m = undefined
    result[decodeURIComponent(m[1])] = decodeURIComponent(m[2])  while m = re.exec(queryString)
    result

  redirectToVideo: (video = @video) ->
    location.href = "#{location.origin}#{location.pathname}?v=#{video}"
