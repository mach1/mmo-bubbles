Player = require './player.coffee'
Dispatcher = require './dispatchers/dispatcher.coffee'
EventEmitter = require('events').EventEmitter

class PlayerManager extends EventEmitter

  constructor: ->
    Dispatcher.register @invokeOnDispatch
    @players = []

  emitChange: ->
    @emit 'change'

  addChangeListener: (callback) =>
    @on 'change', callback

  setPlayerCoordinates: (id, coordinates) =>
    player = new Player id, coordinates
    @player = player unless @player
    @players.push player
    @emitChange()

  removePlayer: (id) =>
    @players = @players.filter (other) ->
      other.id isnt id
    @emitChange()

  getPlayer: ->
    @player

  getOtherPlayers: ->
    @players

  invokeOnDispatch: (payload) =>
    if payload.messageType is 'ADD_PLAYER'
      @setPlayerCoordinates payload.id, payload.coordinates
    if payload.messageType is 'REMOVE_PLAYER'
      @removePlayer payload.id
    if payload.messageType is 'MOVE_PLAYER'
      @player.setCoordinates payload.coordinates

  @instance: ->
    PlayerManager::instance ?= new PlayerManager()



module.exports = PlayerManager
