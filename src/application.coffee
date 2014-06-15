class YTPlayer extends Backbone.View

  initialize: ->
    @tempTime = {}
    window.onYouTubeIframeAPIReady = @setupYoutube

  setupYoutube: =>
    @player = new YT.Player "player",
      height: "390"
      width: "640"
      videoId: "SLffdgotHEA"
      playerVars:
        controls: 1

    @player.addEventListener 'onReady', @onPlayerReady
        # 'onStateChange': onPlayerStateChange


  # 4. The API will call this function when the video player is ready.
  onPlayerReady: (event) =>
    setInterval @storeTime, 50

  storeTime: =>

    time = @roundToFractionOfSecond @player.getCurrentTime(), 4
    time = "#{time}x"
    return if @tempTime[time]
    console.log "#{time} is null" unless localStorage[time]?
    count = parseInt(localStorage[time] || 0) + 1
    console.log "#{time}: #{count}"
    localStorage[time] = count
    @tempTime[time] = true

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

  testForHalfSecond:
    '0x': 0
    '0.1x': 0
    '0.2x': 0
    '0.25x': 0.5
    '0.3x': 0.5
    '0.5x': 0.5
    '0.74x': 0.5
    '0.75x': 1
    '1x': 1
    '1.1x': 1
    '1.2x': 1
    '1.24x': 1
    '1.25x': 1.5

  testForThirdSecond:
    '0x': 0
    '0.1x': 0
    '0.165x': 0.33
    '0.2x': 0.33
    '0.33x': 0.33
    '0.494x': 0.33
    '0.495x': 0.66
    '0.5x': 0.66
    '0.65x': 0.66
    '0.66x': 0.66
    '0.824x': 0.66
    '0.825x': 0.99

  test: ->
    algo = @roundToHalfSecond
    _.each @testForHalfSecond, (v, k) ->
      k = parseFloat(k.substring(0, k.length - 1))
      console.log "*** #{k} == #{v} #{algo(k) == v} - #{algo(k)}"




  # event.target.playVideo();

  # 5. The API calls this function when the player's state changes.
  #    The function indicates that when playing a video (state=1),
  #    the player should play for six seconds and then stop.
  # var done = false;
  # function onPlayerStateChange(event) {
  #   if (event.data == YT.PlayerState.PLAYING && !done) {
  #     setTimeout(stopVideo, 6000);
  #     done = true;
  #   }
  # }
  # function stopVideo() {
  #   player.stopVideo();
  # }


ytPlayer = new YTPlayer()