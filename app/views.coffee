img = new Image()

fileOnload = (e) ->
  img.src = e.target.result

$("#exampleInputFile").change (e) ->
  file = e.target.files[0]
  imageType = /image.*/
  return  unless file.type.match(imageType)
  reader = new FileReader()
  reader.onload = fileOnload
  reader.readAsDataURL file

img.src = 'img/test.jpg'

draw = (canvas_name) ->
  canvas = document.getElementById(canvas_name)
  ctx = canvas.getContext("2d")

  ctx.clearRect 0, 0, canvas.width, canvas.height
  ctx.drawImage img, 0, 0, img.width, img.height, 0, 0, img.width, img.height
  return

myFunction = ->
  alert "Hello World!"
  return