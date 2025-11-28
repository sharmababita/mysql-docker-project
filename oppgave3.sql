-- =====================================================
-- OPPGAVE 3 — SQL QUERIES FOR ga_bibliotek
-- =====================================================
-- Author: Babita Sharma
-- Date: 2025-11-10
-- Database: ga_bibliotek
-- =====================================================

USE ga_bibliotek;

-- -----------------------------------------------------
-- 1. Get all books published after year 2000
-- -----------------------------------------------------
SELECT * 
FROM bok
WHERE UtgittAar > 2000;

-- -----------------------------------------------------
-- 2. Get author name and title of all books, sorted by author
-- -----------------------------------------------------
SELECT Forfatter, Tittel
FROM bok
ORDER BY Forfatter ASC;

-- -----------------------------------------------------
-- 3. Get all books with more than 300 pages
-- -----------------------------------------------------
SELECT *
FROM bok
WHERE AntallSider > 300;

-- -----------------------------------------------------
-- 4. Add a new book
-- -----------------------------------------------------
INSERT INTO bok (ISBN, Tittel, Forfatter, Forlag, UtgittAar, AntallSider)
VALUES ('999-1234567890', 'The Silent Library', 'John Writer', 'OpenAI Press', 2024, 250);

-- -----------------------------------------------------
-- 5. Add a new borrower (laaner)
-- -----------------------------------------------------
INSERT INTO laaner (Fornavn, Etternavn, Adresse)
VALUES ('Ankit', 'Sharma', 'Bergen, Norway');

-- -----------------------------------------------------
-- 6. Update address for a specific borrower (example LNr = 1)
-- -----------------------------------------------------
UPDATE laaner
SET Adresse = 'Oslo, Norway'
WHERE LNr = 1;

-- -----------------------------------------------------
-- 7. Get all loans with borrower name and book title
-- -----------------------------------------------------
SELECT 
    utlaan.UtlansNr, 
    laaner.Fornavn, 
    laaner.Etternavn, 
    bok.Tittel, 
    utlaan.Utlansdato, 
    utlaan.Levert
FROM utlaan
JOIN laaner ON utlaan.LNr = laaner.LNr
JOIN bok ON utlaan.ISBN = bok.ISBN;

-- -----------------------------------------------------
-- 8. Get all books and number of copies (eksemplarer)
-- -----------------------------------------------------
SELECT 
    bok.Tittel, 
    COUNT(eksemplar.EksNr) AS AntallEksemplarer
FROM bok
LEFT JOIN eksemplar ON bok.ISBN = eksemplar.ISBN
GROUP BY bok.Tittel;

-- -----------------------------------------------------
-- 9. Get number of loans per borrower
-- -----------------------------------------------------
SELECT 
    laaner.Fornavn, 
    laaner.Etternavn, 
    COUNT(utlaan.UtlansNr) AS AntallUtlån
FROM laaner
LEFT JOIN utlaan ON laaner.LNr = utlaan.LNr
GROUP BY laaner.LNr;

-- -----------------------------------------------------
-- 10. Get number of loans per book
-- -----------------------------------------------------
SELECT 
    bok.Tittel, 
    COUNT(utlaan.UtlansNr) AS AntallUtlån
FROM bok
LEFT JOIN utlaan ON bok.ISBN = utlaan.ISBN
GROUP BY bok.ISBN;

-- -----------------------------------------------------
-- 11. Get all books that have never been loaned
-- -----------------------------------------------------
SELECT 
    bok.Tittel
FROM bok
LEFT JOIN utlaan ON bok.ISBN = utlaan.ISBN
WHERE utlaan.ISBN IS NULL;

-- -----------------------------------------------------
-- 12. Get author and number of loaned books per author
-- -----------------------------------------------------
SELECT 
    bok.Forfatter, 
    COUNT(utlaan.UtlansNr) AS AntallUtlån
FROM bok
LEFT JOIN utlaan ON bok.ISBN = utlaan.ISBN
GROUP BY bok.Forfatter;

-- =====================================================
-- END OF FILE

