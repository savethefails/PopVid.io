class PopVidio.Models.Video extends Backbone.RelationalModel
	url: ->
		return "/videos/#{@id}"

	initialize: ->
		console.log 'model init'
							# console.log data
		# @fetch(success: (data) ->
		# 					console.log 'model init'
		# 					console.log data
		# 		)