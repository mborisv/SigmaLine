url = require('url')
config = require('./config')
logger = require('./logger')
sigma = require('./sigma')
logger.log('Starting ...')

useHttps = config.useHttps()
server = if useHttps then require('https') else require('http')

process.on('uncaughtException', (err) ->
  logger.log('uncaughtException: ' + err.message)
  logger.log(err.stack)
  console.log(err)
)

parseSet = (query) ->
  ret = 'Wrong command'
  key = config.getAdminKey()

  if key and query.key == key
    config.setSigmaColor(query.sigmaColor) if query.sigmaColor
    config.setSigmaNumberColor(query.sigmaNumberColor) if query.sigmaNumberColor
    config.setSigmaWindow(query.sigmaWindow) if query.sigmaWindow
    config.setComPort(query.comPort) if query.comPort
    config.setServerHost(query.serverHost) if query.serverHost
    config.setServerPort(query.serverPort) if query.serverPort
    config.save()
    sigma.readConfig()
    ret = 'Saved'

  ret

listenCallback = ->
  s = if useHttps then 's' else ''
  logger.log("Server running at http#{s}://#{config.getHost()}:#{config.getPort()}/");

indexPage = ->
  """
  <html>
  <body>
    <br>Message text line to sigma:
    <div><form target='frame' action="/line/" method="GET"><input name='message' type='text'/> <button type='submit'>send text</button></form></div>
    Possible colors in message: dark-red(\\a),&nbsp;&nbsp;&nbsp;red(\\b),&nbsp;&nbsp;&nbsp;light-yellow(\\d),&nbsp;&nbsp;&nbsp;yellow-green(\\p)<br>
    dark-orange (\\c),&nbsp;&nbsp;&nbsp;light-orange(\\e),&nbsp;&nbsp;&nbsp;green(\\g),&nbsp;&nbsp;&nbsp;,orange-red(\\o),&nbsp;&nbsp;&nbsp;light-green(\\h)<br>
    rainbow(\\i),&nbsp;&nbsp;&nbsp;red-orange(\\k),&nbsp;&nbsp;&nbsp;green-red(\\l)
    <br>New number in queue:
    <div><form target='frame' action="/next/" method="GET"><input name='message' type='text'/> <button type='submit'>send next in queue</button></form></div>
    <br>Setup:
    <div><form target='frame' action="/set/" method="GET">
      SigmaWindowColor: <input name='sigmaColor' type='text' value='#{config.getSigmaColor()}'/><br>
      SigmaNumberColor: <input name='sigmaNumberColor' type='text' value='#{config.getSigmaNumberColor()}'/><br>
      SigmaWindowText: <input name='sigmaWindow' type='text' value='#{config.getSigmaWindow()}'/><br>
      SigmaComPort: <input name='comPort' type='text' value='#{config.getComPort()}'/><br>
      ServerHost: <input name='serverHost' type='text' value='#{config.getHost()}'/><br>
      ServerPort: <input name='serverPort' type='text' value='#{config.getPort()}'/><br>
      <button type='submit'>send Config</button>
    </form></div>
  <iframe name='frame'>
  </iframe>
  </body>
  </html>
  """


serverCallback = (req, res) ->
  parsed = url.parse(req.url, true)
  ret =
    status: 'OK'
    error: ''

  logger.log('new request')
  logger.log(req.url)

  switch (parsed.pathname)
    when '/set/' then ret.result = parseSet(parsed.query)
    when '/line/' then ret.result = sigma.write(parsed.query.message)
    when '/next/' then ret.result = sigma.writeNextInQueue(parsed.query.message)
    when '/'
      key = config.getAdminKey()
      if key and parsed.query.key == key
        res.writeHead(200, "Content-Type": "text/html")
        return res.end(indexPage())
    else ret.error = 'Wrong command'

  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS, PUT')
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type')
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.writeHead(200, "Content-Type": "text/plain");
  res.end(JSON.stringify(ret));

server = if useHttps then server.createServer(config.getHttpsConfig(), serverCallback) else server.createServer(serverCallback)

server.listen(config.getPort(), config.getHost(), listenCallback)

server.on('error', (e) ->
  logger.log('Error in server' + JSON.stringify(e))
  if e.code == 'EADDRINUSE'
    logger.log('Address in use, retrying...')
    setTimeout(() ->
      server.close();
      server.listen(config.getPort(), config.getHost(), listenCallback)
    , 2000
    )
)
