class YTPlayer extends Backbone.View
  currentTime: 0
  video: 'SLffdgotHEA'
  captionDuration: 2
  ENTER: 13
  ESC: 27

  el: 'body'

  initialize: ->
    $('html').on 'keydown', @onKeyDown
    @on 'change:currentTime', @onTimeChange
    window.onYouTubeIframeAPIReady = @setupYoutube
    @model = new Backbone.Model localStorage[@video]

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

  onPlayerStateChange: (event) =>
    @locked = false if event.data is YT.PlayerState.PLAYING

  onKeyDown: (e) =>
    return unless e.currentTarget.tagName == 'HTML'
    playerState = @player.getPlayerState()
    if playerState isnt YT.PlayerState.PAUSED
      @player.pauseVideo()
      @$('textarea').focus()




  onTimeChange: (current, old) =>




ytPlayer = new YTPlayer()