# Source: https://coderwall.com/p/j3gxsa
module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-sass')

  grunt.initConfig
    watch:
      coffee:
        files: ['src/*.coffee', 'sass/*.scss', './index.html']
        tasks: ['default']
        options:
          livereload: true

    coffee:
      compile:
        expand: true,
        flatten: true,
        cwd: "#{__dirname}/src/",
        src: ['*.coffee'],
        dest: 'js/',
        ext: '.js'
      options:
        bare: true
        sourceMap: false

    clean:
      dirs:
        src: ['js', '.sass-cache']
      app:
        src: ['./application.js', './application.css']


    concat:
        squash:
          src: ['js/captions_model.js', 'js/caption_view.js', 'js/ytplayer_view.js', 'js/application.js']
          dest: './application.js'

    connect:
      server:
        options:
          port: 4000,
          base: '',
          hostname: '*'

     sass:
      dist:
        options:
          style: 'expanded'
        files:
          'application.css': 'sass/application.scss'


  # grunt.registerTask 'default',
  #   'cleans, compiles, squashes',
  #   ['clean:dirs', 'clean:app', 'coffee:compile', 'concat:squash', 'sass:dist', 'clean:dirs']

  grunt.registerTask 'default',
    'cleans, compiles, squashes',
    ['clean:dirs', 'clean:app', 'coffee:compile', 'sass:dist', 'concat:squash', 'clean:dirs']



  grunt.registerTask 'development',
  'runs tasks for dev environment',
  ['default', 'server']

  grunt.registerTask 'server',
  'creates server and watches',
  ['connect', 'watch']
