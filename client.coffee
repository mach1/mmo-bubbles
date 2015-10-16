class Client
  @id: 0
  @getId: ->
    ++@id

  constructor: (@socket) ->
    @id = Client.getId()

  setCoordinates: (@top = 0, @left = 0) ->

  getCoordinates: ->
    top: @top
    left: @left

  getData: ->
    id: @id,
    coordinates: @getCoordinates()

module.exports = Client
