import os
import pyodbc
from flask import Flask, jsonify
import creds as c

# Flask app initialization
app = Flask(__name__)

# Load database connection details from environment variables
DB_SERVER = c.DB_SERVER
DB_DATABASE = c.DB_DATABASE
DB_USERNAME = c.DB_USERNAME
DB_PASSWORD = c.DB_PASSWORD

CONNECTION_STRING = (
    'Driver={ODBC Driver 17 for SQL Server};'
    f'Server={DB_SERVER};'
    f'Database={DB_DATABASE};'
    f'Uid={DB_USERNAME};'
    f'Pwd={DB_PASSWORD};'
    'Encrypt=yes;'
    'TrustServerCertificate=no;'
    'Connection Timeout=30;'
)

def get_db_connection():
    """
    Establishes and returns a new database connection.
    """
    return pyodbc.connect(CONNECTION_STRING)

@app.route("/getProducts", methods=["GET"])
def get_products():
    """
    HTTP endpoint handler that retrieves all products from the database
    and returns them as JSON.
    """
    conn = get_db_connection()
    cursor = conn.cursor()

    # Execute the query
    cursor.execute("SELECT * FROM products")

    # Fetch column names and rows
    columns = [column[0] for column in cursor.description]
    rows = cursor.fetchall()

    # Transform rows into list of dicts
    products = [dict(zip(columns, row)) for row in rows]

    # Clean up
    cursor.close()
    conn.close()

    return jsonify(products)

if __name__ == "__main__":
    # Run the Flask development server
    app.run(host="0.0.0.0", port=5000, debug=True)
