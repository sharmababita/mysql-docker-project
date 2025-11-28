import mysql.connector


db = mysql.connector.connect(
    host="127.0.0.1",
    user="root",
    password="MySecretPassword"
)

cursor = db.cursor()
cursor.execute("CREATE DATABASE IF NOT EXISTS ga_bibliotek")
db.commit()
db.close()

# Connect to the database
db = mysql.connector.connect(
    host="127.0.0.1",
    user="root",
    password="MySecretPassword",
    database="ga_bibliotek"
)

cursor = db.cursor()
cursor.execute("SELECT 1")
print(cursor.fetchone())

db.close()
