map = require "through2-map"

module.exports = () ->
	return map.obj (file) ->
		o = { id: file.relative, deps: { } }
		o.source = file.contents.toString "utf-8"
		o.entry if file.md?.entry
		o.deps if file.md?.deps
		return o
