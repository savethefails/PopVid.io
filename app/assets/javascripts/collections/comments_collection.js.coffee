class PopVidio.Collections.Comments extends Backbone.Collection
	model: PopVidio.Models.Comment
	url: '/comments'

	initialize: ->
		$.subscribe "new:comment", @newComment
		$.subscribe "new:time", @findComment

	newComment: (data) =>
		@create(data.comment)

	findComment: (data) =>
		time = data.time
		comment = @filter (comment) ->
			endTime=comment.get('timestamp') + comment.get('duration')
			endTime > time >= comment.get('timestamp')
		if comment.length > 0
			$.publish "new:popup", {popup: comment[0]}
