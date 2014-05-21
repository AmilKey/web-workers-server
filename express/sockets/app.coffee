Canvas = require('canvas')

module.exports = exports = (control) ->
  (socket) ->
    count_clients = Object.keys(control.io.connected).length
    control.io.sockets.emit 'clients',
      count_clients

    socket.on 'disconnect', ->
      control.io.sockets.emit 'clients',
        --count_clients

    socket.on 'load image', (workers) ->
      # socketid = socket.id
      socketsId = Object.keys(control.io.connected)
      workers.forEach (worker, i) ->
        socketid = socketsId[i]
        control.io.sockets.socket(socketid).emit 'source image',
          worker

    socket.on 'build image', (res_img) ->
      socket.broadcast.emit 'build image',
        res_img