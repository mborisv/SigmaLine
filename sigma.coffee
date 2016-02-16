SerialPort = require("serialport").SerialPort
config = require('./config.js')
class Sigma

  constructor: ->
    @port = new SerialPort(config.getComPort(), {}, false)

  writeLine: ->
    @port.open( (err) =>
      @port.write( (err, res) =>
      )
    )

module.exports new Sigma