class PopVidio.Routers.Videos extends Backbone.Router
	routes:
		'': 'index'
		'videos/:id/edit': 'editComments'

	index: ->
		console.log 'index'

	editComments: (id) ->
		video = new PopVidio.Models.Video(id: id)
		video.fetch()
		view = new PopVidio.Views.VideoEdit(model: video, el: '#content')
		