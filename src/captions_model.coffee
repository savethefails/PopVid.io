class CaptionsModel extends Backbone.Model

  initialize: (model, options) ->
    @video = options.video
    @on 'change', @saveToLocalStorage

  saveToLocalStorage: =>
    localStorage[@video] = JSON.stringify @toJSON()
