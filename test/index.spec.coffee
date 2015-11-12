path    = require "path"
chai    = require "chai"
sinon   = require "sinon"
sinonc  = require "sinon-chai"
gulp    = require "gulp"
debug   = require "gulp-debug"
buffer  = require "vinyl-buffer"
through = require "through2"
pass    = require "through2-spy"
pass    = require "./utils/through2-pass"
reduce  = require "./utils/through2-reduce"
sdone   = require "./utils/stream-done"
mdeps   = require "../src/index"
expect  = chai.expect

chai.use sinonc

describe "single file", () ->
	before () ->
		@entry = path.join \
			__dirname, "cases", "01-single", "entry.js"

	describe "generate", () ->
		beforeEach () ->
			@stream = gulp.src @entry
				.pipe mdeps()

		it "should return single item", sdone () ->
			return @stream
				.pipe reduce.obj 0,
					(sum, file) -> sum + 1
					(sum) -> expect(sum).equals 1

		it "should have .md.entry flag", sdone () ->
			return @stream
				.pipe pass.obj (file) ->
					expect(file.md.entry).equals true

		it "should have empty .md.deps", sdone () ->
			return @stream
				.pipe pass.obj (file) ->
					expect(file.md.deps).deep.equals { }

	describe "serialize", () ->
		beforeEach () ->
			@stream = gulp.src @entry
				.pipe mdeps()
				.pipe mdeps.serialize "compiled.json"

		it "should produce JSON with a single item", sdone () ->
			expected = require "./cases/01-single/expected.json"

			return @stream
				.pipe buffer()
				.pipe pass.obj (file) ->
					parse = () ->
						JSON.parse file.contents.toString "utf-8"
					expect(parse()).deep.equals expected

describe "resolving single dependency", () ->
	before () ->
		@entry = path.join \
			__dirname, "cases", "02-single-dependency", "entry.js"

	describe "generate", () ->
		beforeEach () ->
			@stream = gulp.src @entry
				.pipe mdeps()

		it "should return two files", sdone () ->
			return @stream
				.pipe reduce.obj 0,
					(sum, file) -> sum + 1
					(sum) -> expect(sum).equals 2

		it "should return entry.js and dep.js", sdone () ->
			return @stream
				.pipe reduce.obj [],
					(arr, file) -> arr.push(file.basename) and arr
					(arr) ->
						expect(arr).contains "entry.js"
						expect(arr).contains "dep.js"

	describe "serialize", () ->
		beforeEach () ->
			@stream = gulp.src @entry
				.pipe mdeps()
				.pipe mdeps.serialize "compiled.json"

		it "should produce JSON with a two items", sdone () ->
			expected = require "./cases/02-single-dependency/expected.json"

			return @stream
				.pipe buffer()
				.pipe pass.obj (file) ->
					parse = () ->
						JSON.parse file.contents.toString "utf-8"
					expect(parse()).deep.equals expected

	describe "deserialize", () ->
		beforeEach () ->
			@stream = gulp.src @entry
				.pipe mdeps()
				.pipe mdeps.serialize "compiled.json"
				.pipe buffer()
				.pipe mdeps.deserialize()

		it "should have two files", sdone () ->
			return @stream
				.pipe reduce.obj [],
					(arr, file) -> arr.push(file.basename) and arr
					(arr) ->
						expect(arr).contains "entry.js"
						expect(arr).contains "dep.js"
