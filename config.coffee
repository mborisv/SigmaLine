ini = require('ini')
fs = require('fs')

class Config

  constructor: ->
    @config = ini.parse(fs.readFileSync(global.CONFIG_FILE, 'utf-8'))
    console.log("Config file #{global.CONFIG_FILE} loaded")

  getHost: -> ini.unsafe(@config.server.host)

  getPort: -> ini.unsafe(@config.server.port)

  getComPort: -> ini.unsafe(@config.com.port)

  getComConfig: ->
    {
      baudRate: parseInt(ini.unsafe(@config.com.baudRate))
      dataBits:  parseInt(ini.unsafe(@config.com.dataBits))
      stopBits:  parseInt(ini.unsafe(@config.com.stopBits))
      parity:  ini.unsafe(@config.com.parity)
    }

  getLogPath: -> ini.unsafe(@config.log.path)

  getLogSize: -> ini.unsafe(@config.log.size)

  getLogRotate: -> ini.unsafe(@config.log.rotate)

  useHttps: -> parseInt(ini.unsafe(@config.server.https))

  getHttpsKey: -> ini.unsafe(@config.server.httpsKey)

  getHttpsCert: -> ini.unsafe(@config.server.httpsCert)

  setComPort: (com) -> @config.com.port = ini.safe(com)

  getSigmaWindow: () -> ini.unsafe(@config.sigma.window)

  setSigmaWindow: (window) -> @config.sigma.window = ini.unsafe(window)

  setSigmaColor: (color) -> @config.sigma.color = ini.unsafe(color)

  setSigmaNumberColor: (color) -> @config.sigma.color = ini.unsafe(color)


  save: ->
    fs.writeFileSync(global.CONFIG_FILE, ini.stringify(@config))

  getFullConfig: ->
    @config


module.exports = new Config()