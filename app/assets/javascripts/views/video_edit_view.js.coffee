class PopVidio.Views.VideoEdit extends Backbone.View
	
	template: JST['videos/edit']

	youtube_script_template: JST['videos/youtube_api_script']

	initialize: (options) ->
		console.log 'view init'
		@model.on('change', @render, this)

	render: ->
		console.log 'view render'
		console.log JSON.stringify(@model)
		@$el.html(@template(video: @model))
		@comments_view = new PopVidio.Views.Comments(
												    collection: @model.get('comments'), 
												    el: @$('#comments')
												   )
		if !@player_init
			@player_init = true
			@player = new PopVidio.Models.Player({youtube_id: @model.get('youtube_id')})
			$('body').append(@youtube_script_template())
		this