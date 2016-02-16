SerialPort = require("serialport").SerialPort
logger = require('./logger.js')
config = require('./config.js')
class Sigma

  constructor: ->
    @port = new SerialPort(config.getComPort(), config.getComConfig(), false)

    @LETTER_CODES =
      'А': 'A'
      'Б': 0x81
      'В': 'B'
      'Г': 0x83
      'Д': 0x84
      'Е': 'E'
      'Ё': 0x86
      'Ж': 0x87
      'З': 0x88
      'И': 0x89
      'Й': 0x8A
      'К': 'K'
      'Л': 0x8C
      'М': 'M'
      'Н': 'H'
      'О': 'O'
      'П': 0x90
      'Р': 'P'
      'С': 'C'
      'Т': 'T'
      'У': 0x94
      'Ф': 0x95
      'Х': 'X'
      'Ц': 0x97
      'Ч': 0x98
      'Ш': 0x99
      'Щ': 0x9A
      'Ъ': 0x9B
      'Ы': 0x9C
      'Ь': 'b'
      'Э': 0x9E
      'Ю': 0x9F
      'Я': 0xA0

      'а': 'a'
      'б': 0xA2
      'в': 0xA3
      'г': 0xA4
      'д': 0xA5
      'е': 'e'
      'ё': 0xA7
      'ж': 0xA8
      'з': 0xA9
      'и': 0xAA
      'й': 0xAB
      'к': 'k'
      #'к': 0xAC
      'л': 0xAD
      'м': 0xAE
      'н': 0xAF
      'о': 'o'
      'п': 0xB1
      'р': 'p'
      'с': 'c'
      'т': 0xE0
      'у': 0xE1
      'ф': 0xE2
      'х': 'x'
      'ц': 0xE4
      'ч': 0xE5
      'ш': 0xE6
      'щ': 0xE7
      'ъ': 0xE8
      'ы': 0xE9
      'ь': 0xEA
      'э': 0xEB
      'ю': 0xEC
      'я': 0xED


  send: (buffer) ->
    logger.log(buffer.toString())
    @port.open( (err) =>
      @port.write( buffer, (err, res) =>

      )
    )

  codeString: (str) ->
    buffer = new Buffer(str)
    for i, ch in buffer
      if ch < 0x7f && ch > 0
        buffer[i] = ch
      else if @LETTER_CODES[ch]
        buffer[i] = @LETTER_CODES[ch]
      else
        buffer[i] = '.'
    return buffer

  write: (message = "ОКНО 1 ->  \\g1") ->
    buffer = @codeString("~128~f01B\\b#{message}")
    Buffer.concat([buffer, new Buffer([0, 0x0d, 0x0d, 0x0d])])
    @send(buffer)

module.exports = new Sigma()