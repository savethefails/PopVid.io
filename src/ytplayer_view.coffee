class YTPlayerView extends Backbone.View
  currentTime: 0
  video: 'HkMNOlYcpHg'

  el: 'body'

  events:
    'focus textarea': 'onFocusTextarea'

  initialize: ->
    $('html').on 'keydown', @onKeyDownHTML
    @on 'change:currentTime', @onTimeChange
    window.onYouTubeIframeAPIReady = @setupYoutube
    savedCaptions = if localStorage[@video]? then JSON.parse localStorage[@video] else {}
    @model = new CaptionsModel savedCaptions, video: @video
    @listenTo @model, 'all', => console.log arguments

    @mockupPlayer()

  mockupPlayer: ->
    @player =
      count: -1
      state: 1
      getCurrentTime: ->
        @count++ if @state is 1
        @count * 0.5
      getPlayerState: -> @state
      pauseVideo: -> @state = 0
      playVideo: -> @state = 1

    window.YT =
      PlayerState:
        PAUSE: 0
        PLAYING: 1

    setInterval @getCurrentTime, 500

  setupYoutube: =>
    @player = new YT.Player "player",
      height: "390"
      width: "640"
      videoId: @video
      playerVars:
        controls: 1

    @player.addEventListener 'onReady', @onPlayerReady
    @player.addEventListener 'onStateChange', @onPlayerStateChange

  onPlayerReady: (event) =>
    @player.setPlaybackQuality 'large'
    @_intervalId = setInterval @getCurrentTime, 250

  roundToHalfSecond: (input) => @roundToFractionOfSecond(input, 2)

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
    roundTime = @roundToHalfSecond playerTime
    if @currentTime isnt roundTime
      _oldTime = @currentTime
      @currentTime = roundTime
      @trigger 'change:currentTime', @currentTime, _oldTime
      console.log 'currentTime', @currentTime

  onPlayerStateChange: (event) =>
    # @locked = false if event.data is YT.PlayerState.PLAYING

  onKeyDownHTML: (e) =>
    return unless e.currentTarget.tagName == 'HTML'
    @createCaptionsView()
    @$('textarea').focus()
    @player.pauseVideo()

  onFocusTextarea: ->
    @createCaptionsView()
    @player.pauseVideo()

    # playerState = @player.getPlayerState()
    # @$('textarea').focus()
    # @player.pauseVideo() if playerState isnt YT.PlayerState.PAUSE
    # unless @locked?
    #   @startTime = @currentTime
    #   @locked = true

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
      console.log 'found "', @model.get(current), '" at', current
      @createCaptionsView().render()