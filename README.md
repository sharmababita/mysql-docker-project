# mysql-docker-project
# ga_bibliotek — Library Database Project

## Purpose
The `ga_bibliotek` database is a small library system managing books, physical copies, borrowers, and loan transactions.

**Technologies:** MySQL, Docker, SQL scripts

---

## Tables Overview
The database contains four main tables:

- **`bok`** — Stores book metadata.
- **`eksemplar`** — Stores individual physical copies of books.
- **`låner`** — Stores library borrowers.
- **`utlån`** — Stores loan transactions.

---

## Table: bok
- **Description:** Stores information about each book title.
- **Columns:**
  - `ISBN` — `VARCHAR(20)` — **PRIMARY KEY**
  - `Tittel` — `VARCHAR(255)` — title of the book (`NOT NULL`)
  - `Forfatter` — `VARCHAR(255)` — author name (`NOT NULL`)
  - `Forlag` — `VARCHAR(255)` — publisher
  - `UtgittÅr` — `YEAR` or `INT` — publication year
  - `AntallSider` — `INT` — number of pages

---

## Table: eksemplar
- **Description:** Individual copies of a book (one book can have many copies)
- **Columns:**
  - `ISBN` — `VARCHAR(20)` — **FOREIGN KEY** referencing `bok(ISBN)`
  - `EksNr` — `INT` — copy number
- **Primary Key:** Composite (`ISBN`, `EksNr`)

---

## Table: låner
- **Description:** Borrower information
- **Columns:**
  - `LNr` — `INT` — **PRIMARY KEY**, `AUTO_INCREMENT`
  - `Fornavn` — `VARCHAR(100)` — first name (`NOT NULL`)
  - `Etternavn` — `VARCHAR(100)` — last name (`NOT NULL`)
  - `Adresse` — `VARCHAR(255)` — address

---

## Table: utlån
- **Description:** Loan transactions
- **Columns:**
  - `UtlånsNr` — `INT` — **PRIMARY KEY**, `AUTO_INCREMENT`
  - `LNr` — `INT` — **FOREIGN KEY** referencing `låner(LNr)`
  - `ISBN` — `VARCHAR(20)` — **FOREIGN KEY** referencing `eksemplar(ISBN)`
  - `EksNr` — `INT` — used with `ISBN` to identify the copy
  - `Utlånsdato` — `DATE` — loan date
  - `Levert` — `TINYINT` or `BOOLEAN` — 0 or 1; indicates return status

---

## Relationships
- **bok(ISBN)** → parent table for book info  
- **eksemplar(ISBN, EksNr)** references `bok(ISBN)` (1:N relationship)  
- **låner(LNr)** → referenced by `utlån(LNr)` (1:N relationship)  
- **utlån(UtlånsNr)** → uniquely identifies each loan, references both borrower and copy

---

## How to Run
1. Pull Docker MySQL image  
2. Run the container  
3. Execute SQL scripts to create tables and sample data  

---

## Optional: ER Diagram
Include an ER diagram to visualize relationships (e.g., using draw.io)  
- `bok` (1) — (N) `eksemplar`  
- `eksemplar` (1) — (N) `utlån`  
- `låner` (1) — (N) `utlån`

