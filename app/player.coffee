fabric = require('fabric').fabric

class Player

  constructor: (@id, @coordinates) ->
    @drawable = @getCircle(@coordinates)

  getCircle: (coordinates) ->
    new fabric.Circle
      radius: 20
      fill: 'green'
      top: coordinates.top
      left: coordinates.left

  move: (@coordinates, callback) ->
    # Coordinates are given as top left corner
    centerY = @coordinates.top - @drawable.getRadiusX()
    centerX = @coordinates.left - @drawable.getRadiusX()

    @drawable.animate 'top', centerY,
      onChange: callback

    @drawable.animate 'left', centerX,
      onChange: callback

  getCoordinates: ->
    @coordinates

  getDrawable: ->
    @drawable

module.exports = Player
