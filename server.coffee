express = require('express')
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)

Client = require './client.coffee'

clients = []

app.use(express.static('app'))

app.get '/', (req, res) ->
  res.sendfile 'index.html'

io.on 'connection', (socket) ->
  client = new Client(socket)
  clients.push client

  socket.on 'client:getCoordinates', ->
    client.setCoordinates(Math.random() * 500, Math.random() * 500)
    socket.emit 'server:setCoordinates', client.getCoordinates()

    clients.forEach (other) ->
      other.socket.emit 'server:new', client.getData() unless other is client

    otherClients = clients.filter (other) ->
      other isnt client
    .map (other) ->
      other.getData()

    socket.emit 'server:clients', otherClients

  socket.on 'client:animate', (coordinates) ->
    client.setCoordinates coordinates.top, coordinates.left
    clients.forEach (other) ->
      return if other is client
      other.socket.emit 'server:animate', id: client.id, coordinates: coordinates

  socket.on 'disconnect', ->
    clients.forEach (other) ->
      return if other is client
      other.socket.emit 'server:disconnected', client.id

    clients = clients.filter (client) -> client.socket isnt socket

http.listen 3000, ->
  console.log 'listening on *.3000'
