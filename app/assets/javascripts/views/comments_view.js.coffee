class PopVidio.Views.Comments extends Backbone.View

	initialize: (options) ->
		$.subscribe 'new:time', @checkForComment
		@render()

	render: =>
		console.log 'Comments Render'
		@$el

	appendComment: (comment) =>
		comment_view = new PopVidio.Views.Comment(model: comment)
		@$el.append(comment_view.render())

	updateTimer: (data) =>
		time=data.time
		@$el.find('#timer').html(time);

	checkForComment: (data) =>
		time=data.time
		comment=@collection.filter (comment) ->
										endTime=comment.get('timestamp') + comment.get('duration')
										time < endTime && time >= comment.get('timestamp')
		if comment.length > 0
			$.publish "new:popup", {popup: comment[0]}
		