exports.index = (title, version) ->
  (req, res) ->
    res.render 'index', {title: title, version: version}

exports.error = (title, errnum) ->
  (req, res, next) ->
    res.render errnum, {title: title, errnum: errnum}, (err, html) ->
      return next err if err
      res.send errnum, html

exports.test = (title) ->
  (req, res) ->
    res.render 'test', {title: title}