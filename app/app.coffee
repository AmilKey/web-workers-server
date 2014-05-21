socket = io.connect()
clients = null
work_height = null

socket.on 'clients', (count_clients)->
  clients = count_clients
  return

# canvas_result = document.getElementById("your_canvas")
# ctx_result = canvas_result.getContext("2d")
# ctx_result.clearRect 0, 0, canvas_result.width, canvas_result.height

draw = ->
  console.log clients
  # imageData = canvas.toDataURL "image/jpeg"
  workers = []
  imagedata_work = []
  imagedata_result = []
  num_workers = clients
  work_height = Math.ceil canvas.height / num_workers
  radius = 5

  for i in [0...num_workers]
    if i
      imagedata_work[i] = ctx.getImageData 0, work_height * i - radius , canvas.width, work_height + radius
      imagedata_result[i] = ctx.getImageData 0, 0, canvas.width, work_height
    else
      imagedata_work[i] = ctx.getImageData 0, 0, canvas.width, work_height + radius
      imagedata_result[i] = ctx.getImageData 0, 0, canvas.width, work_height

  for i in [0...num_workers]
    workers.push
      # Передача ImageData в worker
      imagedata_work: imagedata_work[i]
      imagedata_result: imagedata_result[i]
      width: canvas.width
      height_end: work_height + 2 * radius
      radius: radius
      number: i

  socket.emit 'load image',
    workers
  return

socket.on 'source image', (source_worker) ->
  console.log "SOURCE IMAGE"
  if Worker?
    worker = new Worker("javascripts/worker.js")
    worker.onmessage = callback

    console.log source_worker.imagedata_work

    img_res = ctx.createImageData source_worker.imagedata_result.width, source_worker.imagedata_result.height
    # img_res.data = source_worker.imagedata_result.data

    img_source = ctx.createImageData source_worker.imagedata_work.width, source_worker.imagedata_work.height
    # img_source.data.set new Uint8ClampedArray source_worker.imagedata_work.data

    # source_worker.imagedata_result = img_res
    # source_worker.imagedata_work = img_source
    i = 0

    while i < source_worker.imagedata_work.data.length
      img_source.data[i] = source_worker.imagedata_work.data[i]
      i++
    console.log img_source

    worker.postMessage source_worker

callback = (event) ->
  status = event.data.status
  imagedata = event.data.imagedata
  number = event.data.number
  progress = event.data.progress

  #рисуем часть изображения
  if status is "complite" # Если фильтр выполнил работу
     # Переместить принятую Image Data в контекст canvas
    if canvas_result.getContext

      # img = ctx_result.createImageData imagedata.width, imagedata.height
      # img.data.set imagedata.data

      ctx.putImageData imagedata, 0, work_height * number
  return