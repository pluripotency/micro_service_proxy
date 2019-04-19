express = require('express')
bodyParser = require('body-parser')
session = require('express-session')
connectRedis = require('connect-redis')(session)

config = require('config')

sessionMiddleware = session
    secret: config.session.secret
    rolling: true
    resave: true
    saveUninitialized: true
    cookie: maxAge: 20 * 60 * 1000
    store: new connectRedis
      ttl: 6 * 60 * 60
      prefix: 'creg:'
      host: config.redis.ip
      port: config.redis.port

app = express()
server = require('http').createServer(app)

app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use sessionMiddleware

app.use "#{config.url_root}/", require('./routes/')

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next err

if app.get('env') == 'development'
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.send
      message: err.message
      error: err

app.use (err, req, res, next) ->
  res.status err.status or 500
  res.send
    message: err.message
    error: {}

app.set 'port', process.env.PORT || config.server.port

server.listen app.get('port'), ()->
  console.log('API Server listening on port ' + server.address().port)
