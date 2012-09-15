class PopVidio.Models.Comment extends Backbone.RelationalModel
	paramRoot: 'comment'

	defaults:
		text: ""

	create: =>
		$.publish "new:comment", {comment: @}
