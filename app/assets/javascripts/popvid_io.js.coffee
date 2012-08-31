window.PopVidio =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
  	window.app = new PopVidio.Routers.Videos
  	Backbone.history.start(pushState: true)

$(document).ready ->
  PopVidio.init()