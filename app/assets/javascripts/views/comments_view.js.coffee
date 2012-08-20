class PopVidio.Views.Comments extends Backbone.View

	initialize: (options) ->
		
		@player = options.player
		@player.on('new:time', (time) =>
								@updateTimer(time)
				  )
		@render()

	render: =>
		@collection.each(@appendComment)
		@$el.append("<li id='timer'>#{@player.get('currentTime')}</li>");

	appendComment: (comment) =>
		comment_view = new PopVidio.Views.Comment(model: comment)
		@$el.append(comment_view.render())

	updateTimer: (time) ->
		@$el.find('#timer').html(time);

