through = require "through2"

args = (constructor) ->
	return (options, onItem, onFinish) ->
		if typeof options is "function"
			onFinish = onItem
			onItem   = options
			options  = { }

		return constructor options,
			(chunc, enc, done) ->
				onItem? chunc
				done null, chunc
			(done) ->
				onFinish?()
				done()

module.exports      = args through
module.exports.ctor = args through.ctor
module.exports.obj  = args through.obj
