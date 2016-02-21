cluster = require('cluster')
fs = require('fs')
process = require('process')
require('./const')

console.log("Starting App, pid = #{process.pid}")

fs.appendFile(PID_FILE, process.pid, flag: 'a+', (err) => throw err if err )

if (cluster.isMaster)
  console.log('Forking in Master')
  cluster.fork();

  cluster.on('exit', (worker, code, signal) ->
    console.log('Error happened, fork')
    cluster.fork()
  )


if (cluster.isWorker)
  console.log('Worker begin main')
  main = require('./server')
