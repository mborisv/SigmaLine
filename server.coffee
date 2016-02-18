
url = require('url')

global.CONFIG_FILE = './config.ini'

config = require('./config.js')
logger = require('./logger.js')
sigma = require('./sigma.js')
logger.log('starting')

useHttps = config.useHttps()
server = if useHttps then require('https') else require('http')

process.on('uncaughtException', (err) ->
  logger.log('uncaughtException: ' + err.message)
  console.log(err)
)

parseSetConfig = (query) ->
  ## need simple auth
  ## will leave it blank for now
  return 'Not implemented yet'


parseSet = (query) ->
  ret = 'Wrong command'
  if query.string
    ret = sigma.setString(query.string)
  else if query.winString
    ret = sigma.setWinString(query.string)
  else if query.winNumber
    ret = sigma.setWinNumber(query.string)

  ret

listenCallback = ->
  s = if useHttps then 's' else ''
  logger.log("Server running at http#{s}://#{config.getHost()}:#{config.getPort()}/");

serverCallback = (req, res) ->
  ###
  url :
  /set/
    ?winString=text
    ?winNumber=num
    ?string=text
    config?param=value&...

  /getConfig

###
  parsed = url.parse(req.url, true)

  ret =
    status: 'OK'
    error: ''

  logger.log('new request')
  logger.log(req.url)
  logger.log(JSON.stringify(req.headers))
  logger.log(JSON.stringify(parsed))

  switch (parsed.pathname)
    when '/getConfig' then ret.result = config.getFullConfig()
    when '/set/config' then ret.result = parseSetConfig(parsed.query)
    when '/set' then ret.result = parseSet(parsed.query)
    when '/next' then ret.result = sigma.writeNextInQueue(parsed.query.message)
    else ret.error = 'Wrong command'


  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS, PUT')
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type')
  res.setHeader('Access-Control-Allow-Credentials', true);

  res.writeHead(200, "Content-Type": "text/plain");

  res.end(JSON.stringify(ret));


key = cert = ''
if !useHttps
  server = server.createServer(serverCallback)
else
  key = config.getHttpsKey()
  cert = config.getHttpsCert()
  fs = require('fs')
  server = server.createServer(
    key: fs.readFileSync(config.getHttpsKey())
    cert: fs.readFileSync(config.getHttpsCert())
  , serverCallback
  )

server.listen(config.getPort(), config.getHost(), listenCallback)

server.on('error', (e) ->
  logger.log('Error in server' + JSON.stringify(e))
  if e.code == 'EADDRINUSE'
    logger.log('Address in use, retrying...')
    setTimeout(() ->
      server.close();
      server.listen(config.getPort(), config.getHost(), listenCallback)
    , 1000
    )
)
