class PopVidio.Models.Video extends Backbone.RelationalModel
	url: ->
		return "/videos/#{@id}"

	initialize: ->
		console.log 'model init'

	paramRoot: 'video'
	 	 
	relations: [
		type: Backbone.HasMany
		key: 'comments'
		relatedModel: 'PopVidio.Models.Comment'
		collectionType: 'PopVidio.Collections.CommentsCollection'
		includeInJSON: false
		reverseRelation:
		  key: 'post_id',
		  includeInJSON: 'id'
	]