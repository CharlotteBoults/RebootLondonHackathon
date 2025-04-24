import React from 'react';
import './Products.css'; // Assuming you'll add styles here
import ProductList from './ProductList'; // Import the new component

function Products() {
  const products = [
    { id: 1, name: 'Product 1', badge: 'New', link: '/product1' },
    { id: 2, name: 'Product 2', badge: 'Hot', link: '/product2' },
    { id: 3, name: 'Product 3', badge: 'Sale', link: '/product3' },
  ];

  return (
    <div>
      <header className="dashboard-header">
        <h1>Our Products</h1>
        <p>Explore our range of products</p>
      </header>
      {/* Use the ProductList component */}
      <ProductList products={products} />
      <div className="chat-window">
        <div className="chat-header">Chat with us</div>
        <input
          type="text"
          className="chat-input"
          placeholder="Type your message here..."
        />
      </div>
    </div>
  );
}

export default Products;