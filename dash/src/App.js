import React, {useState, useEffect} from 'react';
import io from 'socket.io-client';

import './App.css';

function App() {
    const [events, setEvents] = useState([]);

    useEffect(() => {
        const socket = io.connect('http://localhost:8000');
        socket.on('init', function (data) {
            console.log('got initial event data', data);
            setEvents(data);
            socket.emit('register', { clientId: Math.floor(Math.random() * Math.floor(100000)) });
        });
        socket.on('event', function (data) {
            console.log('got new event', data);
            setEvents(data);
        });
    }, []);

  return (
    <div className="App">
      <header className="App-header">
          <h1>Dashboard</h1>
          {events.map(([eventName, value]) => (
              <div>{`${eventName}: ${value}`}</div>
            )
          )}
      </header>
    </div>
  );
}

export default App;
