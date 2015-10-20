Player = require './player.coffee'
Dispatcher = require './dispatchers/dispatcher.coffee'
EventEmitter = require('events').EventEmitter

class PlayerManager extends EventEmitter

  constructor: ->
    Dispatcher.register @invokeOnDispatch
    @others = []

  emitChange: ->
    @emit 'change'

  addChangeListener: (callback) =>
    @on 'change', callback

  setPlayerCoordinates: (id, coordinates) =>
    @player = new Player null, coordinates
    @emitChange()

  addOtherPlayer: (id, coords) =>
    @others.push new Player(id, coords)
    @emitChange()

  removePlayer: (id) =>
    @others = @others.filter (other) ->
      other.id isnt id
    @emitChange()

  addOtherPlayers: (players) =>
    players = players.map (data) =>
      return new Player(data.id, data.coordinates)
    @others = @others.concat players
    @emitChange()

  getPlayer: ->
    @player

  getOtherPlayers: ->
    @others

  invokeOnDispatch: (payload) =>
    if payload.messageType is 'ADD_PLAYER'
      @setPlayerCoordinates payload.id, payload.coordinates
    if payload.messageType is 'ADD_OTHER_PLAYER'
      @addOtherPlayer payload.id, payload.coordinates
    if payload.messageType is 'REMOVE_PLAYER'
      @removePlayer payload.id
    if payload.messageType is 'ADD_OTHER_PLAYERS'
      @addOtherPlayers payload.players
    if payload.messageType is 'MOVE_PLAYER'
      @player.setCoordinates payload.coordinates

  @instance: ->
    PlayerManager::instance ?= new PlayerManager()



module.exports = PlayerManager
