class PopVidio.Routers.Videos extends Backbone.Router
	routes:
		'': 'index'
		'videos/:id/edit': 'editVideoComments'

	index: ->
		console.log 'index'

	editVideoComments: (id) ->
		@video = new PopVidio.Models.Video(id: id)
		@video.fetch()
		@edit_view = new PopVidio.Views.VideoEdit(model: @video, el: '#content')

	data: "LOCAL DATA"

	publish: (data) =>
		console.log data
		console.log @data
