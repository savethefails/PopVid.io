class PopVidio.Views.VideoEdit extends Backbone.View
	
	template: JST['videos/edit']

	youtube_script_template: JST['videos/youtube_api_script']

	initialize: ->
		console.log 'view init'
		@model.on('change', @render, this)

	render: ->
		console.log 'view render'
		console.log JSON.stringify(@model)
		@$el.html(@template(video: @model))
		@comments_view=new PopVidio.Views.Comments(
													collection: @model.get('comments'), 
													el: @$('#comments')
													)
		if !@added_youtube_scripts
			@added_youtube_scripts = true
			$('body').append(@youtube_script_template())
		this

	createYoutubePlayer: ->
		console.log 'createYoutubePlayer'
		window.player = new YT.Player 'youtube_player', {
				height: '390'
				width: '640'
				videoId: @model.get('youtube_id')
			}