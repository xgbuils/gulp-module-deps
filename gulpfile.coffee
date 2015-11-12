gulp       = require "gulp"
coffee     = require "gulp-coffee"
coffeelint = require "gulp-coffeelint"
mocha      = require "gulp-mocha"
sequence   = require "run-sequence"
clear      = require "clear"

gulp.task "build", (done) ->
	return gulp.src "src/**/*.coffee"
		.pipe coffeelint()
		.pipe coffeelint.reporter()
		.on "error", done
		.pipe coffee bare: true
		.on "error", done
		.pipe gulp.dest "dist"

gulp.task "test", ["build"], (done) ->
	return gulp.src "test/**/*.spec.coffee"
		.pipe coffeelint()
		.pipe coffeelint.reporter()
		.on "error", done
		.pipe mocha()
		.on "error", done

gulp.task "dev", (done) ->
	clear()
	sequence "test", done

gulp.task "default", () ->
	gulp.watch ["src/**", "test/**"], ["dev"]
	sequence "dev"
