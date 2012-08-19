class PopVidio.Views.Comment extends Backbone.View

	tagName: 'li'

	template: JST['comments/show']

	initialize: (options)->
		@parent=options.parent
		@parent.append(@render())


	render: ->
		console.log 'comment render'
		@$el.html(@template(comment: @model))