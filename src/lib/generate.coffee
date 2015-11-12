mdeps      = require "module-deps"
map        = require "through2-map"
multipipe  = require "multipipe"
mdep2vinyl = require "./mdep2vinyl"
pass       = require "../../test/utils/through2-pass"

module.exports = (opts) ->
	md      = mdeps opts
	tomd    = map.obj (file) ->
		return { file: file.path }
	tovinyl = mdep2vinyl opts?.base

	return multipipe tomd, md, tovinyl
