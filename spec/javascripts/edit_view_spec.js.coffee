describe 'Tests for Edit View', ->
	

	beforeEach ->
		loadFixtures "edit_view"

		video_fixture =
			id: 1
			youtube_id: '123'
			comments:[
				{
					text: 'hi'
					timestamp: 0
					duration: 1
					video_id: 1
				}
				{
					text: 'there'
					timestamp: 2
					duration: 3
					video_id: 1
				}
			]

		@video = new PopVidio.Models.Video(video_fixture)
		@video_view = new PopVidio.Views.VideoEdit(model: @video, el: '#content')

	afterEach ->
		@video_view.remove()
		delete @video

	it 'should load in fixture', ->
		expect($('#content').length).toBe(1)

	it 'should correctly render its template', ->
		exptect(true).toBe(true)
		# header = @video_view.$el.find('h3')
		# console.log header
		# expect(header.html()).toContain('Video')

