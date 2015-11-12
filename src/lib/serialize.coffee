through    = require "through2"
multipipe  = require "multipipe"
vinyl      = require "vinyl"
JSONStream = require "JSONStream"
vinyl2mdep = require "./vinyl2mdep"

module.exports = (path) ->
	json = multipipe vinyl2mdep(), JSONStream.stringify()

	file = new vinyl \
		path: path,
		contents: json

	pushToJson = (file, enc, done) ->
		json.write file
		done()

	flush = (done) ->
		json.end()
		done()

	out = through.obj pushToJson, flush
	out.push file

	json.on "error", (error) ->
		out.emit "error", error

	return out
