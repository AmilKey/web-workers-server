Canvas = require('canvas')

module.exports = exports = (control) ->
  (socket) ->
    count_clients = Object.keys(control.io.connected).length
    socket.emit 'clients',
      count_clients

    # canvas = new Canvas(300, 400)
    # img = new Canvas.Image()
    # img.dataMode = Canvas.Image.MODE_MIME | Canvas.Image.MODE_IMAGE
    # ctx = canvas.getContext('2d')
    # socket.on 'load image', (data) ->
    #   img.src = data
    #   ctx.drawImage img, 0, 0, img.width, img.height
    #   r = ctx.getImageData 0, 0, 20, 20
    #   console.log r
    #   socket.emit 'result image',
    #     data

    socket.on 'load image', (workers) ->
      # socketid = socket.id
      socketsId = Object.keys(control.io.connected)
      workers.forEach (worker, i) ->
        socketid = socketsId[i]
        control.io.sockets.socket(socketid).emit 'source image',
          worker