class YTPlayer extends Backbone.View
  currentTime: 0

  initialize: ->
    # @model = new Backbone.Model currentTime: 0
    @on 'change:currentTime', -> console.log arguments
    window.onYouTubeIframeAPIReady = @setupYoutube

  setupYoutube: =>
    @player = new YT.Player "player",
      height: "390"
      width: "640"
      videoId: "SLffdgotHEA"
      playerVars:
        controls: 1

    @player.addEventListener 'onReady', @onPlayerReady
    @player.addEventListener 'onStateChange', @onPlayerStateChange

  onPlayerReady: (event) => @player.setPlaybackQuality 'large'

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
    if event.data == YT.PlayerState.PLAYING
      @getCurrentTime()
      @_intervalId = setInterval @getCurrentTime, 250
    else
      clearInterval @_intervalId


ytPlayer = new YTPlayer()