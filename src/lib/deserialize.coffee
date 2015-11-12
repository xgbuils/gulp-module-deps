map        = require "through2-map"
multipipe  = require "multipipe"
JSONStream = require "JSONStream"
mdep2vinyl = require "./mdep2vinyl"

module.exports = (base) ->
	contents = map.obj (file) ->
		return file.contents
	parse    = JSONStream.parse [true]
	tovinyl  = mdep2vinyl base

	return multipipe contents, parse, tovinyl
