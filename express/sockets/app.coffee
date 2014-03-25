module.exports = exports = (control) ->
  (socket) ->
    count_clients = Object.keys(control.io.connected).length
    socket.emit 'msg',
      count_clients

    socket.on 'load image', (ctx) ->
      console.log ctx