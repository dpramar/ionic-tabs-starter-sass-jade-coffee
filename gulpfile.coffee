argv        = require('yargs').alias('p', 'production').argv
bower       = require 'bower'
browserSync = require('browser-sync').create()
cache       = require 'gulp-cached'
coffee      = require 'gulp-coffee'
coffeelint  = require 'gulp-coffeelint'
coffeStylish= require 'coffeelint-stylish'
del         = require 'del'
gulp        = require 'gulp'
gutil       = require 'gulp-util'
inject      = require 'gulp-inject'
jade        = require 'gulp-jade'
minifyCss   = require 'gulp-minify-css'
path        = require 'path'
runSequence = require 'run-sequence'
sass        = require 'gulp-sass'
scssLint    = require 'gulp-scss-lint'
scssStylish = require 'gulp-scss-lint-stylish'
series      = require 'stream-series'
uglify      = require 'gulp-uglify'

vendor      = require './vendor.json'

paths =
  sass: ['src/app/**/*.scss']
  jade: ['src/app/**/*.jade']
  coffee: ['src/app/**/*.coffee']
  img: './src/app/img/**/*.*'
  dest: './www/'
  vendor: './www/lib/'
  index: './www/index.html'
  sources: [ './www/**/*.js', './www/**/*.css', '!./www/**/*.module.js', '!./www/blocks/router/*', '!./www/core/*', '!./www/layout/*', '!./www/lib/**/*.js']
  modules: ['./www/**/*.module.js', '!./www/blocks/router/*', '!./www/core/*', '!./www/layout/*']

# Add your bower_components vendors to vendor.js
vendorPaths =
  if argv.production then vendor.production
  else vendor.dev

gulp.task 'vendor', ->
  absolutePaths = vendorPaths.map (p) -> path.resolve("./bower_components", p)
  gulp.src absolutePaths, base: './bower_components'
    .pipe gulp.dest paths.vendor

gulp.task 'images', ->
  gulp.src paths.img
    .pipe gulp.dest path.join paths.dest, 'img'

gulp.task 'sass', ->
  gulp.src paths.sass
    .pipe cache 'sass'
    .pipe scssLint customReport: scssStylish
    .pipe sass errLogToConsole: true
    .pipe if argv.production then minifyCss() else gutil.noop()
    .pipe gulp.dest(paths.dest)

gulp.task 'jade', ->
  gulp.src paths.jade
    .pipe cache 'jade'
    .pipe jade if argv.production then gutil.noop() else pretty: true
    .pipe gulp.dest(paths.dest)

gulp.task 'coffee', ->
  gulp.src paths.coffee
    .pipe cache 'coffee'
    .pipe coffeelint()
    .pipe coffeelint.reporter coffeStylish
    .pipe coffee().on('error', gutil.log)
    .pipe if argv.production then uglify() else gutil.noop()
    .pipe gulp.dest(paths.dest)

gulp.task 'index', ->
  # Inject in the correct order to startup app
  vendor = gulp.src [paths.vendor+'**/*.js'], read: false
  blocks = gulp.src ['./www/blocks/router/*.module.js', './www/blocks/router/*.js'], read: false
  core = gulp.src ['./www/core/core.module.js', './www/core/core.*.js'], read: false
  layout = gulp.src ['./www/layout/layout.module.js', './www/layout/layout.route.js'], read: false
  modules = gulp.src paths.modules, read: false
  sources = gulp.src paths.sources, read: false
  target = gulp.src paths.index

  target.pipe inject series(vendor, blocks, core, layout, modules, sources), relative: true
    .pipe gulp.dest paths.dest

gulp.task 'clean', (done) ->
  cache.caches = {}
  del [paths.dest], done

gulp.task 'sass-watch', ['sass'], -> browserSync.reload()
gulp.task 'jade-watch', ['jade'], -> browserSync.reload()
gulp.task 'coffee-watch', ['coffee']

gulp.task 'serve', ->
  browserSync.init
    server:
      baseDir: 'www'

  gulp.watch paths.sass, ['sass-watch']
  gulp.watch paths.jade, ['jade-watch']
  gulp.watch paths.coffee, (event) ->
    if event.type is 'added' or event.type is 'deleted'
      runSequence 'coffee-watch', 'index'
    else runSequence 'coffee-watch'
    browserSync.reload()

gulp.task 'bowerInstall',  ->
  bower.commands.install()
  .on 'log', (data) ->
    gutil.log 'bower', gutil.colors.cyan(data.id), data.message

gulp.task 'dev', (done) ->
  runSequence 'build', 'serve', done

gulp.task 'build', (done) ->
  runSequence 'clean', 'bowerInstall', 'vendor', ['sass', 'jade', 'coffee', 'images'], 'index', done

# Default task: development build
gulp.task 'default', ['build']