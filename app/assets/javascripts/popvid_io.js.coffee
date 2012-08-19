window.PopVidio =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
  	@video_router = new PopVidio.Routers.Videos
  	Backbone.history.start(pushState: true)

$(document).ready ->
  PopVidio.init()