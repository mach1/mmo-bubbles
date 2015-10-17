var socket = io();
var canvas;

function getCircle(coordinates) {
  return new fabric.Circle({
    radius: 20,
    fill: 'green',
    top: coordinates.top,
    left: coordinates.left
  });
}

function animateCircle(circle, coordinates) {
  circle.animate('top', coordinates.top, {
    onChange: canvas.renderAll.bind(canvas)
  });
  circle.animate('left', coordinates.left, {
    onChange: canvas.renderAll.bind(canvas)
  });
}

document.addEventListener('DOMContentLoaded', function() {
  canvas = new fabric.Canvas('c');
  var circle;
  var clients = [];
  canvas.setWidth(window.innerWidth);
  canvas.setHeight(window.innerHeight);

  socket.emit('client:getCoordinates');
  
  socket.on('server:setCoordinates', function(coordinates) {
    circle = getCircle(coordinates);
    canvas.add(circle);
    canvas.renderAll();
  });

  socket.on('server:new', function(data) {
    data.circle = getCircle(data.coordinates);
    canvas.add(data.circle);
    canvas.renderAll();
    clients.push(data);
  });

  socket.on('server:clients', function(clientsData) {
    clientsData.forEach(function(data) {
      data.circle = getCircle(data.coordinates);
      canvas.add(data.circle);
      clients.push(data);
    });

    canvas.renderAll();
  });

  socket.on('server:disconnected', function(id) {
    clients.forEach(function(client) {
      if (client.id === id) {
        canvas.remove(client.circle);
        return;
      }
    });
  });

  socket.on('server:animate', function(data) {
    clients.forEach(function(client) {
      if (client.id === data.id) {
        animateCircle(client.circle, data.coordinates);
        return;
      }
    });
  });

  canvas.on('mouse:down', function(options) {
    var radius = circle.getRadiusX();
    var top = options.e.clientY - radius;
    var left = options.e.clientX - radius;
    animateCircle(circle, {top: top, left: left});
    socket.emit('client:animate', { top: top, left: left });
  });
});

