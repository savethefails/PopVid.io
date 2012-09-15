class PopVidio.Routers.Videos extends Backbone.Router
	routes:
		'': 'index'
		'videos/:id/edit': 'loadVideoComments'

	index: ->
		console.log 'index'

	loadVideoComments: (id) ->
		console.log "Routing to videos/#{id}/edit"
		@video = new PopVidio.Models.Video(id: id)
		@edit_view = new PopVidio.Views.VideoEdit(model: @video, el: '#content')
		@video.fetch()
