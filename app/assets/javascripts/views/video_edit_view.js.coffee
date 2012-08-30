class PopVidio.Views.VideoEdit extends Backbone.View
	
	template: JST['videos/edit']

	youtube_script_template: JST['videos/youtube_api_script']

	initialize: (options) ->
		console.log 'view init'
		@model.on('change', @render, this)
		$.subscribe "new:popup", @addPopUp

	render: ->
		console.log 'view render'
		console.log JSON.stringify(@model)
		@$el.html(@template(video: @model))

		if !@player_init
			@player_init = true
			@player = new PopVidio.Models.Player({youtube_id: @model.get('youtube_id')})
			$('body').append(@youtube_script_template())

		@comments_view = new PopVidio.Views.Comments(
												    collection: @model.get('comments'), 
												    el: @$('#comments')
												    )

		this

	addPopUp: (data) =>
		console.log 'addPopup'
		popup = data.popup
		popUpView = new PopVidio.Views.PopUp(model: popup)
		@$el.find('#pop_up').html(popUpView.$el)