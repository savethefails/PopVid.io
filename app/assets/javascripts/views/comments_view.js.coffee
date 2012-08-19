class PopVidio.Views.Comments extends Backbone.View

	initialize: ->
		@render()

	render: ->
		@collection.each(@appendComment)

	appendComment: (comment) =>
		comment_view = new PopVidio.Views.Comment(model: comment, parent: @$el)
		# @$el.append(comment_view.render())