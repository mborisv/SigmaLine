cluster = require('cluster')

console.log('Starting App')

if (cluster.isMaster)
  console.log('Forking in Master')
  cluster.fork();

  cluster.on('exit', (worker, code, signal) ->
    console.log('Error happened, fork')
    ##cluster.fork()
  )


if (cluster.isWorker)
  console.log('Worker begin main')
  main = require('./server.js')
