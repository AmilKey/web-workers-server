socket = io.connect()
clients = null
work_height = null

socket.on 'clients', (count_clients)->
  clients = count_clients
  console.log "count clients " + clients
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
    num_workers = clients
    work_height = Math.ceil canvas.height / num_workers

    worker = new Worker("javascripts/worker.js")
    worker.onmessage = callback

    ####################
    #Result source
    ####################
    img_res = ctx.createImageData source_worker.imagedata_result.width, source_worker.imagedata_result.height
    # img_res.data = source_worker.imagedata_result.data

    ####################
    #Source_worker
    ####################
    img_source = ctx.createImageData source_worker.imagedata_work.width, source_worker.imagedata_work.height
    #преобразование объекта в массив
    length = Object.keys(source_worker.imagedata_work.data).length
    source_worker.imagedata_work.data.length = length + 1
    array = Array.prototype.slice.apply(source_worker.imagedata_work.data)
    i = 0
    while i < array.length
      img_source.data[i] = array[i]
      i++
    ######################

    # img_source.data.set new Uint8ClampedArray(array) #error Source is too large

    source_worker.imagedata_work = img_source
    source_worker.imagedata_result = img_res

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
      socket.emit 'build image',
        imagedata: imagedata
        number: number
        work_height: work_height
      ctx_result.putImageData imagedata, 0, work_height * number
  return

socket.on 'build image', (res_img) ->
  number = res_img.number
  img_source = ctx.createImageData res_img.imagedata.width, res_img.imagedata.height
  #преобразование объекта в массив
  length = Object.keys(res_img.imagedata.data).length
  res_img.imagedata.data.length = length + 1
  array = Array.prototype.slice.apply(res_img.imagedata.data)
  i = 0
  while i < array.length
    img_source.data[i] = array[i]
    i++
  ctx_result.putImageData img_source, 0, res_img.work_height * number