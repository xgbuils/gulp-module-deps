vinyl = require "vinyl"
map   = require "through2-map"
path  = require "path"

module.exports = (base) ->
	return map.obj (item) ->
		file = new vinyl \
			base: base,
			path: item.id,
			contents: new Buffer item.source

		file.md = { deps: { } }
		if item.entry
			file.md.entry = true
		for own k, depid of item.deps
			f = new vinyl \
				base: base,
				path: depid,
				contents: new Buffer ""
			file.md.deps[k] = f.relative
		return file
