PlayerManager = require './player-manager.coffee'

class SocketManager

  constructor: ->
    @socket = io()
    @addSocketBindings()
    @socket.emit 'client:getCoordinates'
    @PlayerManager = PlayerManager.instance()

  addSocketBindings: ->
    @socket.on 'server:setCoordinates', @playerManager.setPlayerCoordinates
    @socket.on 'server:new', @playerManager.addOtherPlayer

  setPlayerCoordinates: (coordinates) ->


module.exports = SocketManager
