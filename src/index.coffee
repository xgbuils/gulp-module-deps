generate    = require "./lib/generate"
serialize   = require "./lib/serialize"
deserialize = require "./lib/deserialize"
mdep2vinyl  = require "./lib/mdep2vinyl"
vinyl2mdep  = require "./lib/vinyl2mdep"

module.exports             = generate
module.exports.serialize   = serialize
module.exports.deserialize = deserialize
module.exports.mdep2vinyl  = mdep2vinyl
module.exports.vinyl2mdep  = vinyl2mdep
