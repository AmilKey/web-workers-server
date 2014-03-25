img = new Image()
img.src = "img/test.jpg"
canvas = document.getElementById("my_canvas")
ctx = canvas.getContext("2d")

img.onload = ->
  ctx.clearRect 0, 0, canvas.width, canvas.height
  ctx.drawImage img, 0, 0
  return

fileOnload = (e) ->
  img.src = e.target.result

$("#exampleInputFile").change (e) ->
  file = e.target.files[0]
  imageType = /image.*/
  return unless file.type.match(imageType)
  reader = new FileReader()
  reader.onload = fileOnload
  reader.readAsDataURL file

draw = ->
  socket.emit 'load image',
    img.src

  return

myFunction = ->
  alert "Hello World!"
  return