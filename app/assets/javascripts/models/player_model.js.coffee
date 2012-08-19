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

	onPlayerReady: (event) ->
		# event.target.playVideo()

	onPlayerStateChange: (event) =>
		console.log 'player state change'
		console.log @
		@set({state: event.data})
		if @get('state') == YT.PlayerState.PLAYING
			@intervalID = setInterval (=>
				@set ({currentTime: @YTPlayer.getCurrentTime()})
				console.log @get('currentTime')
				), 1000
		else
			clearInterval @intervalID
		
