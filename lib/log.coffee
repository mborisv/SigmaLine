rotate = require('log-rotate')
fs = require('fs')

class Log

  ###
    @param file file path for log
    @param fileSize размер файла после чего запускать rotate 0 - unlimited
    @param count - количество файлов для rotate 0 - бесконечено
  ###
  constructor: (@file, @fileSize, @count) ->
    @count = if @count then 'count': @count else {}


  log: (msg) ->
    console.log(msg)
    throw new Error('Logger file is not ready') if !@file
    ## сделать log rotate по необходимости
    fs.appendFile(@file, @modifyMessage(msg), flag: 'a+', (err) =>
      throw err if err
      if @fileSize
        stat = fs.statSync(@file)
        if stat.size > @fileSize
          rotate(@file, @count, (err) =>
            throw err if err
          )
    )


  modifyMessage: (msg) ->
    date = new Date()
    date = date.toISOString().slice(0,10) + ' ' \
      + ('0'+date.getHours()).slice(-2) + ':'\
      + ('0'+date.getMinutes()).slice(-2) + ':' \
      + ('0'+date.getSeconds()).slice(-2)
    try
      file = new Error().stack.split("\n")[3].split("/").slice(-1)[0].split(")")[0].replace('.coffee', '')
    catch
      file = "undefined"
    "#{date}|#{file}\t|#{msg}\n"


module.exports = Log