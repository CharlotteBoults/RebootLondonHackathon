import React, { useState } from 'react';
import './Dashboard.css';
import PersonalDashboard from './PersonalDashboard';
import SocialDashboard from './SocialDashboard';
import { FaUser, FaUsers, FaComments, FaTimes, FaPaperPlane } from 'react-icons/fa';

function Dashboard() {
  const [activeTab, setActiveTab] = useState('personal');
  const [isChatOpen, setIsChatOpen] = useState(false);
  const [message, setMessage] = useState('');

  const handleSendMessage = (e) => {
    e.preventDefault();
    if (message.trim()) {
      // Add your message sending logic here
      console.log('Sending message:', message);
      setMessage('');
    }
  };

  return (
    <div className="dashboard-container">
      <div className="tab-buttons">
        <button 
          className={`tab-btn ${activeTab === 'personal' ? 'active' : ''}`}
          onClick={() => setActiveTab('personal')}
        >
          <FaUser size={24} />
        </button>
        <button 
          className={`tab-btn ${activeTab === 'social' ? 'active' : ''}`}
          onClick={() => setActiveTab('social')}
        >
          <FaUsers size={24} />
        </button>
      </div>

      <div className="tab-content">
        {activeTab === 'personal' ? <PersonalDashboard /> : <SocialDashboard />}
      </div>

      {/* Chat Button */}
      <button 
        className="chat-button"
        onClick={() => setIsChatOpen(true)}
      >
        <FaComments size={24} />
      </button>

      {/* Chat Dialog */}
      {isChatOpen && (
        <div className="chat-dialog">
          <div className="chat-header">
            <h3>Chat</h3>
            <button 
              className="close-button"
              onClick={() => setIsChatOpen(false)}
            >
              <FaTimes />
            </button>
          </div>
          <div className="chat-content">
            {/* Add your chat messages here */}
          </div>
          <form className="chat-input-area" onSubmit={handleSendMessage}>
            <input
              type="text"
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              placeholder="Type a message..."
              className="chat-input"
            />
            <button type="submit" className="send-button">
              <FaPaperPlane />
            </button>
          </form>
        </div>
      )}
    </div>
  );
}

export default Dashboard;