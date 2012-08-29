class PopVidio.Views.Comments extends Backbone.View

	initialize: (options) ->
		$.subscribe 'new:time', @updateTimer
		@render()

	render: =>
		@collection.each(@appendComment)
		@$el.append("<li id='timer'>0</li>");

	appendComment: (comment) =>
		comment_view = new PopVidio.Views.Comment(model: comment)
		@$el.append(comment_view.render())

	updateTimer: (data) =>
		console.log 'updateTimer'
		console.log data
		time=data.time
		@$el.find('#timer').html(time);

