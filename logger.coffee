config = require('./config.js')

class Logger extends require('./log.js')

  ###
    @param file file path for log
    @param fileSize размер файла после чего запускать rotate 0 - unlimited
    @param count - количество файлов для rotate 0 - отключено
  ###
  constructor: () ->
    super config.getLogPath() + 'sigma.log', config.getLogSize(), config.getLogRotate()


module.exports = new Logger()