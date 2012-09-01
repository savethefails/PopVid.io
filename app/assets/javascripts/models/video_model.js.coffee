class PopVidio.Models.Video extends Backbone.RelationalModel
	url: ->
		return "/videos/#{@id}"

	initialize: (options) ->
		console.log 'model init'

	paramRoot: 'video'
	 	 
	relations: [
		type: Backbone.HasMany
		key: 'comments'
		relatedModel: 'PopVidio.Models.Comment'
		collectionType: 'PopVidio.Collections.Comments'
		includeInJSON: false
		reverseRelation:
		  key: 'video_id',
		  includeInJSON: 'id'
	]