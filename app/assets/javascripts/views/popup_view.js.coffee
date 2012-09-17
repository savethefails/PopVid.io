class PopVidio.Views.PopUp extends Backbone.View

	initialize: ->
		console.log 'Pop Up Init'
		$.subscribe "new:time", @monitorTime
		@render @model.get('text')

	render: (text) =>
		console.log "Pop Up Render '#{text}'"
		@$el.val(text)

	monitorTime: (data) =>
		
		time = data.time

		endTime = @model.get('timestamp') + @model.get('duration')

		if time >= endTime || time < @model.get('timestamp')
			console.log "Removing Pop-up for '#{@model.get('text')}'"
			$.unsubscribe "new:time", @monitorTime
			@render ''
			@$el=$("");
			@remove
			Backbone.View.prototype.remove.call(@);


