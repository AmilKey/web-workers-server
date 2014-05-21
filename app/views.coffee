img = new Image()
img.src = "img/test.jpg"
canvas = document.getElementById("my_canvas")
ctx = canvas.getContext("2d")

canvas_result = document.getElementById("your_canvas")
ctx_result = canvas_result.getContext("2d")
ctx_result.clearRect 0, 0, canvas_result.width, canvas_result.height

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

myFunction = ->
  alert "Hello World!"
  return