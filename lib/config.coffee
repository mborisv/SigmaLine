ini = require('ini')
fs = require('fs')

class Config

  constructor: ->
    @config = ini.parse(fs.readFileSync(CONFIG_FILE, 'utf-8'))
    console.log("Config file #{CONFIG_FILE} loaded")

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
  getHttpsConfig: ->
    key: fs.readFileSync(ini.unsafe(@config.server.httpsKey))
    cert: fs.readFileSync(ini.unsafe(@config.server.httpsCert))

  getAdminKey: -> ini.unsafe(@config.admin.key)

  getSigmaWindow: () -> ini.unsafe(@config.sigma.window)
  getSigmaColor: () -> ini.unsafe(@config.sigma.color)
  getSigmaNumberColor: () -> ini.unsafe(@config.sigma.numberColor)

  setSigmaWindow: (window) -> @config.sigma.window = ini.unsafe(window)
  setSigmaColor: (color) -> @config.sigma.color = ini.unsafe(color)
  setSigmaNumberColor: (color) -> @config.sigma.numberColor = ini.unsafe(color)

  setServerHost: (host) -> @config.server.host = ini.unsafe(host)
  setServerPort: (port) -> @config.server.port = ini.unsafe(port)

  setComPort: (com) -> @config.com.port = ini.safe(com)

  save: ->
    fs.writeFileSync(CONFIG_FILE, ini.stringify(@config))

module.exports = new Config()