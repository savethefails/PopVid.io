class PopVidio.Views.VideoEdit extends Backbone.View
	
	template: JST['videos/edit']

	youtube_script_template: JST['videos/youtube_api_script']

	initialize: (options) ->
		console.log 'view init'
		@model.on('change', @render, this)
		$.subscribe "new:popup", @addPopUp
		$.subscribe 'new:time', @updateMarker


	render: ->
		console.log 'view render'
		console.log JSON.stringify(@model)
		@$el.html(@template(video: @model))

		if !@player_init
			@player_init = true
			@player = new PopVidio.Models.Player({youtube_id: @model.get('youtube_id')})
			$('body').append(@youtube_script_template())

		app.comments = @model.get('comments')
		@comments_view = new PopVidio.Views.Comments(
							collection: app.comments)
		@$('#comments').html(@comments_view.render());

		@

	addPopUp: (data) =>
		console.log 'addPopup'
		popup = data.popup
		popUpView = new PopVidio.Views.PopUp(model: popup)
		@$el.find('#pop_up').html(popUpView.$el)

	updateMarker: (data) =>
		percentDone = data.time / data.player.get('duration')
		@$el.find('#marker').css left: percentDone*640+'px'


