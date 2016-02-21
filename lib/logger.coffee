config = require('./config')

class Logger extends require('./log')

  ###
    @param file file path for log
    @param fileSize размер файла после чего запускать rotate 0 - unlimited
    @param count - количество файлов для rotate 0 - отключено
  ###
  constructor: () ->
    super config.getLogPath() + LOG_FILE_NAME, config.getLogSize(), config.getLogRotate()


module.exports = new Logger()