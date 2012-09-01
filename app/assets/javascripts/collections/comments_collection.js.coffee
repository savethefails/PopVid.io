class PopVidio.Collections.Comments extends Backbone.Collection
	model: PopVidio.Models.Comment
	url: '/comments'

	initialize: ->
		$.subscribe "new:comment", @newComment

	newComment: (data) =>
		@.create(data.comment)