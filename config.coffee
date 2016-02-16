ini = require('ini')
fs = require('fs')

class Config

  constructor: ->
    @config = ini.parse(fs.readFileSync(global.CONFIG_FILE, 'utf-8'))
    console.log("Config file #{global.CONFIG_FILE} loaded")

  getHost: ->
    return ini.unsafe(@config.server.host)

  getPort: ->
    return ini.unsafe(@config.server.port)

  getComPort: ->
    return ini.unsafe(@config.com.port)

  getLogPath: ->
    return ini.unsafe(@config.log.path)

  getLogSize: ->
    return ini.unsafe(@config.log.size)

  getLogRotate: ->
    return ini.unsafe(@config.log.rotate)

  useHttps: ->
    return parseInt(ini.unsafe(@config.server.https))

  getHttpsKey: ->
    return ini.unsafe(@config.server.httpsKey)

  getHttpsCert: ->
    return ini.unsafe(@config.server.httpsCert)

  setComPort: (com) ->
    @config.com.port = ini.safe(com)

  setSigmaWindow: (window) ->
    @config.sigma.window = ini.unsafe(window)

  setSigmaColor: (color) ->
    @config.sigma.color = ini.unsafe(color)

  setSigmaNumberColor: (color) ->
    @config.sigma.color = ini.unsafe(color)


  save: ->
    fs.writeFileSync(global.CONFIG_FILE, ini.stringify(@config))

  getFullConfig: ->
    @config


module.exports = new Config()