Dispatcher = require '../dispatchers/dispatcher.coffee'

class PlayerActions

  @addPlayer: (id, coordinates) ->
    Dispatcher.dispatch
      messageType: 'ADD_PLAYER'
      id: id
      coordinates: coordinates

  @addOtherPlayer: (id, coordinates) ->
    Dispatcher.dispatch
      messageType: 'ADD_OTHER_PLAYER'
      id: id
      coordinates: coordinates

  @addOtherPlayers: (players) ->
    Dispatcher.dispatch
      messageType: 'ADD_OTHER_PLAYERS'
      players: players

  @removePlayer: (id) ->
    Dispatcher.dispatch
      messageType: 'REMOVE_PLAYER'
      id: id

  @movePlayer: (id, coordinates) ->
    Dispatcher.dispatch
      messageType: 'MOVE_PLAYER'
      id: id
      coordinates: coordinates

module.exports = PlayerActions
