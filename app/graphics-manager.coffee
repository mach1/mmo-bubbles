fabric = require('fabric').fabric
_ = require 'lodash'
Dispatcher = require './dispatchers/dispatcher.coffee'

PlayerManager = require './player-manager.coffee'

class GraphicsManager

  constructor: ->
    @playerManager = PlayerManager.instance()
    @playerManager.addChangeListener @playerChanged
    @canvas = new fabric.Canvas 'c'
    @canvas.setWidth(window.innerWidth)
    @canvas.setHeight(window.innerHeight)
    @others = []

    Dispatcher.register @invokeOnDispatch


  playerChanged: =>
    @canvas.clear()

    removed = @others.filter (other) =>
      @playerManager.getOtherPlayers().indexOf(other) is -1

    added = @playerManager.getOtherPlayers().filter (other) =>
      @others.indexOf(other) is -1

    removed.forEach (removedPlayer) =>
      @canvas.remove removedPlayer.getDrawable()

    added.forEach (addedPlayer) =>
      @canvas.add addedPlayer.getDrawable()

    @others = _.clone @playerManager.getOtherPlayers()
    @player = @playerManager.getPlayer()

    @canvas.add @player.getDrawable() if not @canvas.contains @player?.getDrawable()
    @canvas.renderAll()

  addPlayersToCanvas: (players) =>
    players.map (player) =>
      player.getDrawable()
    .forEach (drawable) =>
      @canvas.add drawable if not @canvas.contains drawable

  invokeOnDispatch: (payload) =>
    if payload.messageType is 'MOVE_PLAYER'
      if @player.id is payload.id
        @player.move payload.coordinates, @canvas.renderAll.bind(@canvas)
      else
        player.move(payload.coordinates, @canvas.renderAll.bind(@canvas)) for player in @others when player.id is payload.id

  getCanvas: ->
    @canvas

  @instance: ->
    GraphicsManager::instance ?= new GraphicsManager()

module.exports = GraphicsManager
