"""
Oppgave 4 – Python program that connects to MySQL and reads data
Author: Babita Sharma
Date: 2025-11-10
"""

import mysql.connector

def connect_database():
    """Connect to the MySQL database running in Docker."""
    return mysql.connector.connect(
        host="localhost",
        port=3307,                # IMPORTANT: This is the port of your new Docker container
        user="root",
        password="Babita@123",   # IMPORTANT: This is your correct MySQL root password
        database="ga_bibliotek"
    )


def show_all_books(cursor):
    """Select and print all books in the system."""
    print("\n--- ALL BOOKS ---")
    cursor.execute("SELECT ISBN, Tittel, Forfatter, UtgittAar FROM bok;")
    for row in cursor.fetchall():
        print(row)


def show_all_borrowers(cursor):
    """Select and print all borrowers."""
    print("\n--- ALL BORROWERS ---")
    cursor.execute("SELECT LNr, Fornavn, Etternavn FROM laaner;")
    for row in cursor.fetchall():
        print(row)


def show_active_loans(cursor):
    """Select and print loans that are not returned."""
    print("\n--- ACTIVE LOANS (not returned) ---")
    cursor.execute("""
        SELECT UtlansNr, LNr, ISBN, EksNr, Utlansdato 
        FROM utlaan 
        WHERE Levert = 0;
    """)
    for row in cursor.fetchall():
        print(row)


def main():
    """Main program flow."""
    try:
        db = connect_database()
        cursor = db.cursor()

        show_all_books(cursor)
        show_all_borrowers(cursor)
        show_active_loans(cursor)

        cursor.close()
        db.close()
        print("\nConnection closed.")

    except mysql.connector.Error as err:
        print("\nERROR while connecting to database:")
        print(err)


if __name__ == "__main__":
    main()
