class PopVidio.Views.Comments extends Backbone.View
	
	tagName: 'ul'

	initialize: (options) ->
		# $.subscribe 'new:time', @checkForComment
		@collection.on 'add', @appendComment

	render: =>
		console.log 'Comments Render'
		@$el

	appendComment: (comment) =>
		comment_view = new PopVidio.Views.Comment(model: comment)
		@$el.append(comment_view.render())

	checkForComment: (data) =>
		console.log @collection
		time=data.time
		comment=@collection.findComment time
		if comment.length > 0
			$.publish "new:popup", {popup: comment[0]}
		