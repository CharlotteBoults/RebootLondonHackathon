import React from 'react';
import { useNavigate } from 'react-router-dom';
import './Page1.css'; // Assuming you'll add styles here

function Page1() {
  const navigate = useNavigate();

  const handleNavigation = (path) => {
    navigate(path); // Navigate to the specified path
  };

  return (
  <div>
      <header class="dashboard-header">
        <h1>Welcome to Cinder</h1>
        <p>Click anywhere to get started</p>
      </header>
      <div class="dashboard-grid">
        <div class="grid-item">
          <button class="grid-button">I want to Travel</button>
        </div>
        <div class="grid-item">
          <button class="grid-button">I want to Start an ISA</button>
        </div>
        <div class="grid-item">
          <button class="grid-button">I want to get Phone Insurance</button>
        </div>
        <div class="grid-item">
          <button class="grid-button">I want to Get Club Lloyds</button>
        </div>
      </div>
    </div>
  );
}

export default Page1;