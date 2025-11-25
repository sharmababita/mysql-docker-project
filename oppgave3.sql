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
WHERE UtgittÅr > 2000;

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
INSERT INTO bok (ISBN, Tittel, Forfatter, Forlag, UtgittÅr, AntallSider)
VALUES ('999-1234567890', 'The Silent Library', 'John Writer', 'OpenAI Press', 2024, 250);

-- -----------------------------------------------------
-- 5. Add a new borrower (låner)
-- -----------------------------------------------------
INSERT INTO låner (Fornavn, Etternavn, Adresse)
VALUES ('Ankit', 'Sharma', 'Bergen, Norway');

-- -----------------------------------------------------
-- 6. Update address for a specific borrower (example LNr = 1)
-- -----------------------------------------------------
UPDATE låner
SET Adresse = 'Oslo, Norway'
WHERE LNr = 1;

-- -----------------------------------------------------
-- 7. Get all loans with borrower name and book title
-- -----------------------------------------------------
SELECT 
    utlån.UtlånsNr, 
    låner.Fornavn, 
    låner.Etternavn, 
    bok.Tittel, 
    utlån.Utlånsdato, 
    utlån.Levert
FROM utlån
JOIN låner ON utlån.LNr = låner.LNr
JOIN bok ON utlån.ISBN = bok.ISBN;

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
    låner.Fornavn, 
    låner.Etternavn, 
    COUNT(utlån.UtlånsNr) AS AntallUtlån
FROM låner
LEFT JOIN utlån ON låner.LNr = utlån.LNr
GROUP BY låner.LNr;

-- -----------------------------------------------------
-- 10. Get number of loans per book
-- -----------------------------------------------------
SELECT 
    bok.Tittel, 
    COUNT(utlån.UtlånsNr) AS AntallUtlån
FROM bok
LEFT JOIN utlån ON bok.ISBN = utlån.ISBN
GROUP BY bok.ISBN;

-- -----------------------------------------------------
-- 11. Get all books that have never been loaned
-- -----------------------------------------------------
SELECT 
    bok.Tittel
FROM bok
LEFT JOIN utlån ON bok.ISBN = utlån.ISBN
WHERE utlån.ISBN IS NULL;

-- -----------------------------------------------------
-- 12. Get author and number of loaned books per author
-- -----------------------------------------------------
SELECT 
    bok.Forfatter, 
    COUNT(utlån.UtlånsNr) AS AntallUtlån
FROM bok
LEFT JOIN utlån ON bok.ISBN = utlån.ISBN
GROUP BY bok.Forfatter;

-- =====================================================
-- END OF FILE
-- =====================================================
