import React from 'react';

function ProductList({ products }) {
  return (
    <div className="products-container">
      {products.map((product) => (
        <div key={product.id} className="product-box">
          <div className="badge">{product.badge}</div>
          <h2>{product.name}</h2>
          <div className="product-actions">
            <button className="like-button">❤️</button>
            <a href={product.link} className="product-link">
              View
            </a>
            <button className="dislike-button">👎</button>
          </div>
        </div>
      ))}
    </div>
  );
}

export default ProductList;