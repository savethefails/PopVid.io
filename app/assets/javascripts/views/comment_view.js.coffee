class PopVidio.Views.Comment extends Backbone.View

	tagName: 'li'

	template: JST['comments/show']

	render: ->
		console.log 'comment render'
		@$el.html(@template(comment: @model))