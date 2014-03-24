module.exports = exports = (control) ->
  (socket) ->
    socket.broadcast.emit 'msg', 'Welcome to Brunch with Express...'