class PopVidio.Collections.CommentsCollection extends Backbone.Collection
  
  model: PopVidio.Models.Comment
  
  url: '/comments'

  initialize: ->
  	$.subscribe 'new:comment', @createComment

  createComment: (data) =>
  	@.create(data.comment)