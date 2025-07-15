const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8080 });

let rooms = {};

wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(message) {
    const data = JSON.parse(message);
    const { type, room, payload } = data;

    if (type === 'join') {
      ws.room = room;
      rooms[room] = rooms[room] || [];
      rooms[room].push(ws);
      // Notify others in the room
      rooms[room].forEach(client => {
        if (client !== ws) client.send(JSON.stringify({ type: 'joined' }));
      });
    } else if (type === 'signal') {
      // Relay signaling data to other peers in the room
      rooms[room].forEach(client => {
        if (client !== ws) client.send(JSON.stringify({ type: 'signal', payload }));
      });
    }
  });

  ws.on('close', function () {
    if (ws.room && rooms[ws.room]) {
      rooms[ws.room] = rooms[ws.room].filter(client => client !== ws);
      if (rooms[ws.room].length === 0) delete rooms[ws.room];
    }
  });
});

console.log('Signaling server running on ws://localhost:8080');
