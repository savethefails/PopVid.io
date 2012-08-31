@PopVidio =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
  	new PopVidio.Routers.Videos
  	Backbone.history.start(pushState: true)

$(document).ready ->
  PopVidio.init()