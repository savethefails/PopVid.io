class PopVidio.Views.Comments extends Backbone.View
	
	tagName: 'ul'

	initialize: (options) ->
		$.subscribe 'new:time', @updateTimer
		$.subscribe 'new:time', @checkForComment
		@collection.on 'add', @appendComment

	render: =>
		console.log 'Comments Render'
		@$el.append("<li id='timer'>0</li>");
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
		