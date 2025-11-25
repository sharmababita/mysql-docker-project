# ga_bibliotek — Database Design Explanation

## Purpose
The `ga_bibliotek` database is designed for a small library system to manage books, physical copies (exemplars), borrowers, and loan transactions.

---

## Tables overview
The database contains four tables:
- `bok` — stores book metadata.
- `eksemplar` — stores individual physical copies of books.
- `låner` — stores library borrowers.
- `utlån` — stores loan transactions (which borrower borrowed which copy and when).

---

## Table: bok
- **Description:** Stores information about each book title.
- **Columns:**
  - `ISBN` — `VARCHAR(20)` — **PRIMARY KEY**. Unique identifier for each book.
  - `Tittel` — `VARCHAR(255)` — title of the book. `NOT NULL`.
  - `Forfatter` — `VARCHAR(255)` — author name. `NOT NULL`.
  - `Forlag` — `VARCHAR(255)` — publisher. (Nullable or `NOT NULL` depending on design.)
  - `UtgittÅr` — `YEAR` or `INT` — publication year.
  - `AntallSider` — `INT` — number of pages.

---

## Table: eksemplar
- **Description:** Stores the individual copies of a book (several copies can exist for the same ISBN).
- **Columns:**
  - `ISBN` — `VARCHAR(20)` — **FOREIGN KEY** referencing `bok(ISBN)`.
  - `EksNr` — `INT` — copy number for the given ISBN.
- **Primary Key:** Composite key (`ISBN`, `EksNr`) — together they uniquely identify one physical copy.
- **Foreign Key:** `ISBN` → `bok(ISBN)` ensures a copy can only exist if the book record exists.

---

## Table: låner
- **Description:** Stores information about borrowers.
- **Columns:**
  - `LNr` — `INT` — **PRIMARY KEY**, `AUTO_INCREMENT`. Unique borrower ID.
  - `Fornavn` — `VARCHAR(100)` — first name. `NOT NULL`.
  - `Etternavn` — `VARCHAR(100)` — last name. `NOT NULL`.
  - `Adresse` — `VARCHAR(255)` — address.
- **Notes:** `AUTO_INCREMENT` simplifies creating new borrower records.

---

## Table: utlån
- **Description:** Records when a borrower checks out a specific copy of a book.
- **Columns:**
  - `UtlånsNr` — `INT` — **PRIMARY KEY**, `AUTO_INCREMENT`.
  - `LNr` — `INT` — **FOREIGN KEY** referencing `låner(LNr)`.
  - `ISBN` — `VARCHAR(20)` — **FOREIGN KEY** referencing `eksemplar(ISBN)` / `bok(ISBN)`.
  - `EksNr` — `INT` — used together with `ISBN` to reference a specific `eksemplar`.
  - `Utlånsdato` — `DATE` — loan date (format `YYYY-MM-DD`).
  - `Levert` — `TINYINT` or `BOOLEAN` — 0 or 1; indicates whether the copy has been returned.
- **Constraints & Notes:**
  - `Levert` should only allow values `0` (not returned) or `1` (returned). This can be enforced with a `CHECK` constraint: `CHECK (Levert IN (0,1))`.
  - The combination `ISBN` + `EksNr` in `utlån` references the composite primary key in `eksemplar`. This models which exact copy was loaned.
  - `LNr` references `låner(LNr)` to link the loan to a borrower.

---

## Keys and relationships (summary)
- **bok(ISBN)** is the parent table for book information.
- **eksemplar(ISBN, EksNr)** references `bok(ISBN)`. This is a one-to-many relationship: one book can have many exemplars.
- **låner(LNr)** is referenced by `utlån(LNr)`; one borrower can have many loans.
- **utlån(UtlånsNr)** identifies each loan transaction uniquely; it references both the borrower and the specific copy loaned.

---

## Constraints and data integrity
- **Primary Keys** ensure uniqueness of rows (e.g., `ISBN`, `LNr`, `UtlånsNr`).
- **Foreign Keys** enforce referential integrity (prevent creating loans for non-existing borrowers or copies).
- **NOT NULL** should be applied to essential columns (e.g., `Tittel`, `Forfatter`, `LNr`, `Utlånsdato`).
- **AUTO_INCREMENT** on `LNr` and `UtlånsNr` to auto-generate IDs.
- **CHECK (Levert IN (0,1))** ensures loan return status is valid.
- Using appropriate data types (`DATE` for dates, `INT` for numbers, `VARCHAR` for text) improves storage and query correctness.

---

## Example relationships described in words
- When a new book is added, a row is inserted in `bok`.
- When the library buys a physical copy of a book, a row is inserted in `eksemplar` with that book's `ISBN` and a new `EksNr`.
- When a user borrows a book copy, a new row is inserted in `utlån` linking `LNr` (the borrower) to the exact `ISBN` and `EksNr` and setting `Levert = 0`.
- When the book is returned, the `Levert` column for that loan is updated to `1`.

---

## Optional: ER Diagram
A simple ER diagram would show:
- `bok` (1) — (N) `eksemplar`
- `eksemplar` (1) — (N) `utlån`
- `låner` (1) — (N) `utlån`

(You can create this quickly with draw.io and include the image in your submission.)

---

## Final notes
- Keep the README concise — 1–2 pages is fine.
- Use bullet points and headings (as shown) for clarity.
- If you want, I can tailor this README to use the exact column names and datatypes from your Task 1 SQL script — paste your `CREATE TABLE` statements and I will adapt the README precisely.
