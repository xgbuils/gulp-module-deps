through = require "through2"

args = (constructor) ->
	return (options, agg, onItem, onFinish) ->
		if typeof agg is "function"
			onFinish = onItem
			onItem   = agg
			agg      = options
			options  = { }

		return constructor options,
			(chunc, enc, done) ->
				agg = onItem? agg, chunc
				done null, chunc
			(done) ->
				onFinish?(agg)
				done()

module.exports      = args through
module.exports.ctor = args through.ctor
module.exports.obj  = args through.obj
