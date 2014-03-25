module.exports = exports = (control) ->
  (socket) ->
    socket.emit 'msg', 'Welcome to Brunch with Express...'