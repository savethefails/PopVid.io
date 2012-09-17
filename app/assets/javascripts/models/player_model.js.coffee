class PopVidio.Models.Player extends Backbone.Model

	defaults:
		id: null
		width: '640'
		height: '390'
		youtube_id: null
		state: null
		currentTime: 0

	initialize: ->
		console.log 'player model initialize'

		#local functions hook directly into changes on the model
		@.on('change:state', @setCurrentTime)

		#changes on the model are also broadcast out since this is a popular model
		@.on 'change:state', -> $.publish 'change:playerState', {state: @get('state')}
		@.on 'change:currentTime', => $.publish "new:time", {time: @get('currentTime'), player: @}

		$.subscribe "change:time", @skipToTime
		$.subscribe "input:clicked", @pause

		# Create a function that the Youtube API can reach,
		# that references this model so we can keep all calls in here
		window.onYouTubeIframeAPIReady = =>
			console.log 'onYouTubeIframeAPIReady'
			@createYoutubePlayer()



	createYoutubePlayer: =>
		console.log 'create player initalized'
		@YTPlayer = new YT.Player 'youtube_player', {
				height: @get('height')
				width: @get('width')
				videoId: @get('youtube_id')
				events:
					'onReady': (event) =>
									@set duration: @YTPlayer.getDuration()
									@set currentTime: 0
									
					'onStateChange': @setPlayerState
			}

	setPlayerState: (event) =>
		console.log "player state change to #{event.data}"
		@set({state: event.data})

	setCurrentTime: =>
		if @get('state') == YT.PlayerState.PLAYING
			@intervalID = setInterval (=>
				@set ({currentTime: @roundedTime()})
				), 413

		else if @get('state') == YT.PlayerState.PAUSED
			@set ({currentTime: @roundedTime()})

		else
			clearInterval @intervalID

	roundedTime: ->
		Math.floor(@YTPlayer.getCurrentTime()/0.5)*0.5

	skipToTime: (data) =>
		@YTPlayer.seekTo data.time

		if data.status.pause
			@YTPlayer.pauseVideo()

	pause: =>
		@YTPlayer.pauseVideo()


		
