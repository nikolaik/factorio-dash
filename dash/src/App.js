import React, {useState, useEffect} from 'react';
import io from 'socket.io-client';

import soundfile from './airbus_seatbelt_sign.mp3';
import './App.css';

const Alert = () => {
    const myRef = React.createRef();
    return (
        <audio ref={myRef} src={soundfile} autoPlay />
    )
};

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
          {Boolean(events.length) && <Alert/>}
          {Array.from(events.entries()).map(([key, [eventName, ...values]]) => {
               return (
                   <div key={key}>
                      {`${eventName}: ${values.join(' ')}`}
                  </div>
               )
              }
          )}
      </header>
    </div>
  );
}

export default App;
