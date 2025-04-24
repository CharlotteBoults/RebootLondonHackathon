import logo from './lbg-logo.jpeg';
import './App.css';
import { useNavigate } from 'react-router-dom';
import React from 'react';

function App() {
  const navigate = useNavigate();
  const handleLogin = () => {
    // In a real application, you would authenticate the user here
    navigate('/chat');
  };
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <button onClick={handleLogin} className="login-btn">Login</button>
      </header>
    </div>
  );
}

export default App;
