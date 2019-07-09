const chokidar = require('chokidar');
const fs = require('fs');
const express = require('express');
const http = require('http');
const socketIO = require('socket.io');

require('dotenv').config();

const FACTORIO_DATA_PATH = process.env.FACTORIO_DATA_PATH || '../script-output';
const EVENTS_PATH = `${FACTORIO_DATA_PATH}/Dash-events.csv`;


// Init data
let eventData = loadEvents();

// Init webserver
const app = express();
const server = http.Server(app);
const io = socketIO(server);

function loadEvents() {
    const eventData = fs.readFileSync(EVENTS_PATH);
    return eventData.toString().trim().split('\n').map((line) => line.split(','));
}

function onFileChanged(path) {
    const fileName = path.split('/').slice(-1)[0];
    console.log(`file ${fileName} changed`);

    if (path === EVENTS_PATH) {
        const freshEvents = loadEvents();
        const newEvents = freshEvents.slice(eventData.length);
        eventData = freshEvents;

        io.emit('event', newEvents);
    }
}

function onConnection(socket) {
    socket.emit('init', eventData);
    socket.on('register', (data) => {
        console.log('registered a new client with clientId:', data.clientId)
    });
}

// Watch for factorio file changes
const watcher = chokidar.watch(`${FACTORIO_DATA_PATH}/*.csv`, {
    persistent: true
});
watcher.on('change', onFileChanged);

// Listen for socket connections
io.on('connection', onConnection);

// Start server
server.listen(process.env.PORT || 8000);