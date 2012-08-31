class PopVidio.Routers.Videos extends Backbone.Router
	routes:
		'': 'index'
		'videos/:id/edit': 'loadVideoComments'

	index: ->
		console.log 'index'

	loadVideoComments: (id) ->
		@video = new PopVidio.Models.Video(id: id)
		@video.fetch()
		new PopVidio.Views.VideoEdit(model: @video, el: '#content')
		
		

	data: "LOCAL DATA"

	publish: (data) =>
		console.log data
		console.log @data
