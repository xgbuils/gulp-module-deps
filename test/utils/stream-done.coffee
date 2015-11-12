through = require "through2"

module.exports = (callback) ->
	return (done) ->
		stream = callback.apply this, { }
		stream.pipe through.obj null, null, (d) ->
			d()
			done()
