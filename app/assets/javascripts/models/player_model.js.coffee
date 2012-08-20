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
					'onReady': @onPlayerReady
					'onStateChange': @onPlayerStateChange
			}

	onPlayerReady: (event) =>
		# event.target.playVideo()

	onPlayerStateChange: (event) =>
		console.log 'player state change'
		@set({state: event.data})
		if @get('state') == YT.PlayerState.PLAYING
			@intervalID = setInterval (=>
				rounded_timed = Math.floor(@YTPlayer.getCurrentTime()/0.5)*0.5
				@set ({currentTime: rounded_timed})
				@trigger("new:time", @get('currentTime'))
				), 413
		else
			clearInterval @intervalID
		
