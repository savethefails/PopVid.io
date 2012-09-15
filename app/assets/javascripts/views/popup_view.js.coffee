class PopVidio.Views.PopUp extends Backbone.View

	tagName: 'span'

	initialize: ->
		console.log 'Pop Up Init'
		$.subscribe "new:time", @monitorTime

	render: =>
		console.log 'Pop Up Render'

		@model.get('text')

	monitorTime: (data) =>
		console.log "monitorTime for #{@model.get('text')}"
		time = data.time

		endTime = @model.get('timestamp') + @model.get('duration')

		if time > endTime || time < @model.get('timestamp')
			console.log 'Removing Pop-up'
			$.unsubscribe "new:time", @monitorTime
			@remove
			Backbone.View.prototype.remove.call(@);


