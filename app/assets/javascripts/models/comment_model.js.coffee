class PopVidio.Models.Comment extends Backbone.RelationalModel
	paramRoot: 'comment'

	create: =>
		$.publish "new:comment", {comment: @}
