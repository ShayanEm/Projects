import sqlite3

# Establishing connection to the SQLite database
conn = sqlite3.connect("expenses.db")

# Creating a cursor object to execute SQL commands
cur = conn.cursor()

# Creating the 'expenses' table if it doesn't exist
cur.execute('''CREATE TABLE IF NOT EXISTS expenses (
            id INTEGER PRIMARY KEY,
            date DATE,
            description TEXT,
            category TEXT,
            price REAL
            )''')

# Committing changes to the database
conn.commit()

# Closing the database connection
conn.close()
