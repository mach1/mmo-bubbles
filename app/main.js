var socket = require('socket.io-client')();
var canvas;
var Player = require('./player.coffee');
var fabric = require('fabric').fabric;

document.addEventListener('DOMContentLoaded', function() {
  canvas = new fabric.Canvas('c');
  var circle;
  var clients = [];
  var player;
  canvas.setWidth(window.innerWidth);
  canvas.setHeight(window.innerHeight);

  socket.emit('client:getCoordinates');

  socket.on('server:setCoordinates', function(coordinates) {
    player = new Player(null, coordinates);
    canvas.add(player.getDrawable());
    canvas.renderAll();
  });

  socket.on('server:new', function(data) {
    var other = new Player(data.id, data.coordinates);
    canvas.add(other.getDrawable());
    canvas.renderAll();
    clients.push(other);
  });

  socket.on('server:clients', function(clientsData) {
    clientsData.forEach(function(data) {
      var other = new Player(data.id, data.coordinates);

      canvas.add(other.getDrawable());
      clients.push(other);
    });

    canvas.renderAll();
  });

  socket.on('server:disconnected', function(id) {
    clients.forEach(function(client) {
      if (client.id === id) {
        canvas.remove(client.getDrawable());
        return;
      }
    });
  });

  socket.on('server:animate', function(data) {
    clients.forEach(function(client) {
      if (client.id === data.id) {
        client.move(data.coordinates, canvas.renderAll.bind(canvas));
        return;
      }
    });
  });

  canvas.on('mouse:down', function(options) {
    player.move({ top: options.e.clientY, left: options.e.clientX}, canvas.renderAll.bind(canvas));
    socket.emit('client:animate', player.getCoordinates()); 
  });
});

