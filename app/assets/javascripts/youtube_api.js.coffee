window.onYouTubeIframeAPIReady = ->
	console.log 'onYouTubeIframeAPIReady'
	PopVidio.video_router.edit_view.createYoutubePlayer()