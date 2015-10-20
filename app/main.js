var socket = require('socket.io-client')();
var canvas;
var Player = require('./player.coffee');
var PlayerActions = require('./actions/player-actions.coffee');
var playerManager = require('./player-manager.coffee').instance();
var graphicsManager = require('./graphics-manager.coffee').instance();

document.addEventListener('DOMContentLoaded', function() {
  var circle;
  var clients = [];
  var player;
  var canvas = graphicsManager.getCanvas();

  socket.emit('join');

  socket.on('new player', function(data) {
    PlayerActions.addPlayer(data.id, data.coordinates);
  });

  socket.on('server:disconnected', function(id) {
    PlayerActions.removePlayer(id);
  });

  socket.on('server:animate', function(data) {
    PlayerActions.movePlayer(data.id, data.coordinates);
  });

  canvas.on('mouse:down', function(options) {
    var coordinates = {
      top: options.e.clientY,
      left: options.e.clientX
    };
    var id = playerManager.getPlayer().id
    PlayerActions.movePlayer(id, coordinates);
    socket.emit('client:animate', coordinates);
  });
});

