import React, { useState } from "react";
import { useSpring, animated } from "react-spring";
import "./ChatScreen.css";  // Make sure to add the CSS file for styles

export const ChatScreen = () => {
  // This state holds messages for different chats, indexed by chatId.
  const [chats, setChats] = useState({
    1: [{ id: 1, sender: "user", text: "Hello! How are you?" }],
  });

  const [input, setInput] = useState("");
  const [currentChat, setCurrentChat] = useState(1); // Initially chatId 1

  // Handle sending a message in the current chat
  const handleSend = (text) => {
    if (text.trim() === "") return;

    const newMessage = { id: Date.now(), sender: "user", text };

    setChats((prevChats) => {
      const updatedMessages = [...prevChats[currentChat], newMessage];
      return {
        ...prevChats,
        [currentChat]: updatedMessages,
      };
    });

    // Simulate a bot response
    setTimeout(() => {
      const botMessage = {
        id: Date.now() + 1, 
        sender: "bot",
        text: "This is a bot response!",
      };

      setChats((prevChats) => {
        const updatedMessages = [...prevChats[currentChat], botMessage];
        return {
          ...prevChats,
          [currentChat]: updatedMessages,
        };
      });
    }, 500);
  };

  const messageAnimation = useSpring({
    opacity: 1,
    transform: "translateY(0px)",
    from: { opacity: 0, transform: "translateY(30px)" },
    config: { tension: 300, friction: 20 },
  });

  const handleChange = (e) => {
    setInput(e.target.value);
  };

  const handleKeyDown = (e) => {
    if (e.key === "Enter") {
      handleSend(input);
      setInput("");
    }
  };

  // Handle chat switching (if you want to dynamically switch between chats)
  const switchChat = (chatId) => {
    setCurrentChat(chatId);
  };

  return (
    <div className="chat-screen">
      <div className="chat-switch">
        <button onClick={() => switchChat(1)}>Chat 1</button>
        <button onClick={() => switchChat(2)}>Chat 2</button>
      </div>

      <h2>Chat with {`Person ${currentChat}`}</h2>
      <div className="chat-window">
        {chats[currentChat]?.map((msg) => (
          <animated.div key={msg.id} style={messageAnimation}>
            <div
              className={`chat-message ${msg.sender === "user" ? "user" : "bot"}`}
            >
              <p>{msg.text}</p>
            </div>
          </animated.div>
        ))}
      </div>

      <div className="chat-input">
        <input
          type="text"
          value={input}
          onChange={handleChange}
          onKeyDown={handleKeyDown}
          placeholder="Type a message..."
        />
      </div>
    </div>
  );
};
