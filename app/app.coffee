socket = io.connect()
socket.on 'msg', (msg)->
  console.log msg
  return