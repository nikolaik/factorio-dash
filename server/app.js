const chokidar = require('chokidar');
const fs = require('fs');

require('dotenv').config();

const app = require('express')();
const server = require('http').Server(app);
const io = require('socket.io')(server);

const FACTORIO_DATA_PATH = process.env.FACTORIO_DATA_PATH || '../script-output';
const EVENTS_PATH = `${FACTORIO_DATA_PATH}/Dash-events.csv`;

function loadEvents() {
    const eventData = fs.readFileSync(EVENTS_PATH);
    return eventData.toString().trim().split('\n').map((line) => line.split(','));
}

server.listen(process.env.PORT || 8000);


// app.get('/', function (req, res) {
//     res.sendFile(__dirname + '/index.html');
// });

const watcher = chokidar.watch(`${FACTORIO_DATA_PATH}/*.json`, {
    ignored: /(^|[\/\\])\../,
    persistent: true
});

let eventData = loadEvents();

io.on('connection', function (socket) {
    socket.emit('init', eventData);
    socket.on('register', (data) => {
        console.log('registered a new client with clientId:', data.clientId)
    });

    watcher.on('change', (path) => {
        if (path === EVENTS_PATH) {
            const freshEvents = loadEvents();
            const newEvents = freshEvents.slice(eventData.length);
            eventData = freshEvents;
            socket.emit('event', newEvents);
        }
    })
});