from flask import g
import os
import mysql.connector
import bcrypt

def get_db():
    if 'db' not in g:
        g.db = mysql.connector.connect(
                user="root",
                password=os.getenv('DB_PASSWORD'),
                host="mysql",
                port="8098",
                database="db"
            )
    return g.db

def init_db():
    db = get_db()
    cursor = db.cursor(buffered=True)
    cursor.execute("CREATE TABLE IF NOT EXISTS users(id INT PRIMARY KEY AUTO_INCREMENT, username TEXT NOT NULL, email TEXT NOT NULL, password TEXT NOT NULL);")
    db.close()

def hash_password(password):
    asBytes = password.encode('utf-8')

    # generating the salt
    salt = bcrypt.gensalt()

    # Hashing the password
    return bcrypt.hashpw(asBytes, salt)

def check_password(unhashed, hashed):
    unashedBytes = unhashed.encode('utf-8')
    hashedBytes = hashed.encode('utf-8')
    result = bcrypt.checkpw(unashedBytes, hashedBytes)
    return result