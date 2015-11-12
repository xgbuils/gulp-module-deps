vinyl = require "vinyl"
map   = require "through2-map"

module.exports = (base) ->
	return map.obj (item) ->
		file = new vinyl \
			base: base,
			path: item.id,
			contents: new Buffer item.source

		file.md =
			entry: item.entry,
			deps: item.deps

		return file
