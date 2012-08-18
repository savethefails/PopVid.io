class PopVidio.Views.VideoEdit extends Backbone.View
	
	template: JST['videos/edit']

	initialize: ->
		console.log 'view init'
		@model.on('change', @render, this)

	render: ->
		console.log 'view render'
		console.log JSON.stringify(@model)
		@$el.html(@template(video: @model))
		this

	reset: ->
		console.log 'reset!'