describe 'Tests for Adding Comments', ->
	
	beforeEach =>
		@commentText = 'ABC123'
		@comments = new PopVidio.Collections.Comments()
		@comment = new PopVidio.Models.Comment()
		@comment.set({ text: @commentText })

	it 'collection should increment by 1 when comment creates', =>
		length = @comments.models.length
		@comment.create()
		expect(@comments.models.length).toBe(length+1)

	it 'last comment in collection should match new comment', =>
		@comment.create()
		expect(@comments.last().get('text')).toBe(@comment.get('text'))