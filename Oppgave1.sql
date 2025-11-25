-- oppgave1.sql
-- SQL script to create the ga_bibliotek database, tables, constraints, and example data.
-- All comments and identifiers are in English. Date format: 'YYYY-MM-DD'.

-- 1) Drop database if it already exists (safe for repeated runs)
DROP DATABASE IF EXISTS ga_bibliotek;

-- 2) Create the database and set character set/collation to support international characters
CREATE DATABASE IF NOT EXISTS ga_bibliotek;
ALTER DATABASE ga_bibliotek CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 3) Use the new database for all following statements
USE ga_bibliotek;

-- 4) Create table 'bok' (books)
--    Stores general book information. ISBN is the primary key.
CREATE TABLE IF NOT EXISTS `bok` (
    `ISBN` VARCHAR(20) NOT NULL PRIMARY KEY,
    `Tittel` VARCHAR(200) NOT NULL,
    `Forfatter` VARCHAR(150) NOT NULL,
    `Forlag` VARCHAR(150),
    `UtgittAar` INT,
    `AntallSider` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5) Create table 'eksemplar' (copies)
--    Each physical copy of a book is identified by (ISBN, EksNr).
CREATE TABLE IF NOT EXISTS `eksemplar` (
    `ISBN` VARCHAR(20) NOT NULL,
    `EksNr` INT NOT NULL,
    PRIMARY KEY (`ISBN`, `EksNr`),
    CONSTRAINT fk_eksemplar_bok
      FOREIGN KEY (`ISBN`) REFERENCES `bok`(`ISBN`)
      ON DELETE CASCADE
      ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6) Create table 'laaner' (borrowers)
--    LNr is an auto-increment primary key for borrowers.
--    Note: using ASCII-only name 'laaner' here avoids problems in some SQL clients;
--    if your environment supports UTF-8 identifiers, you can rename to `låner`.
CREATE TABLE IF NOT EXISTS `laaner` (
    `LNr` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Fornavn` VARCHAR(80) NOT NULL,
    `Etternavn` VARCHAR(80) NOT NULL,
    `Adresse` VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7) Create table 'utlaan' (loans)
--    UtlansNr is auto-increment. Levert is 0 or 1 (not returned / returned).
--    We reference borrower (LNr) and copy (ISBN, EksNr).
--    Note: using ASCII-only name 'utlaan' to avoid identifier encoding issues.
CREATE TABLE IF NOT EXISTS `utlaan` (
    `UtlansNr` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `LNr` INT NOT NULL,
    `ISBN` VARCHAR(20) NOT NULL,
    `EksNr` INT NOT NULL,
    `Utlansdato` DATE,
    `Levert` TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT chk_levert_values CHECK (`Levert` IN (0,1)),
    CONSTRAINT fk_utlaan_laaner FOREIGN KEY (`LNr`) REFERENCES `laaner`(`LNr`)
      ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_utlaan_eksemplar FOREIGN KEY (`ISBN`, `EksNr`) REFERENCES `eksemplar`(`ISBN`, `EksNr`)
      ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8) Insert example data into 'bok' (books)
INSERT INTO `bok` (`ISBN`, `Tittel`, `Forfatter`, `Forlag`, `UtgittAar`, `AntallSider`) VALUES
('9781234567890', 'Python Basics',     'John Smith',     'TechPress', 2020, 350),
('9780987654321', 'Learn SQL',         'Maria Hansen',   'CodeBooks', 2018, 280),
('9781112223334', 'Data Science 101',  'Ali Khan',       'SmartPub',  2022, 420),
('9785554443332', 'Web Development',   'Emma Johnson',   'WebWorks',  2015, 320),
('9789998887776', 'Intro to Testing',  'Rita Brown',     'TestHouse', 2010, 200);

-- 9) Insert example data into 'eksemplar' (copies)
--    Two copies for the first book, one for others.
INSERT INTO `eksemplar` (`ISBN`, `EksNr`) VALUES
('9781234567890', 1),
('9781234567890', 2),
('9780987654321', 1),
('9781112223334', 1),
('9785554443332', 1),
('9789998887776', 1);

-- 10) Insert example borrowers into 'laaner'
INSERT INTO `laaner` (`Fornavn`, `Etternavn`, `Adresse`) VALUES
('Anna',  'Olsen',       'Bergen, Norway'),
('Peter', 'Johansen',    'Oslo, Norway'),
('Sara',  'Nilsen',      'Trondheim, Norway');

-- 11) Insert example loans into 'utlaan'
--    Use format YYYY-MM-DD for dates. Levert = 0 (not returned) or 1 (returned).
INSERT INTO `utlaan` (`LNr`, `ISBN`, `EksNr`, `Utlansdato`, `Levert`) VALUES
(1, '9781234567890', 1, '2025-10-20', 0),  -- Anna borrowed copy 1 of Python Basics and not returned
(2, '9780987654321', 1, '2025-10-22', 1),  -- Peter borrowed Learn SQL and returned
(3, '9781112223334', 1, '2025-10-21', 0);  -- Sara borrowed Data Science 101 and not returned

-- 12) Quick selects for verification (optional)
-- Uncomment and run if you want to check inserted data immediately
-- SELECT * FROM `bok`;
-- SELECT * FROM `eksemplar`;
-- SELECT * FROM `laaner`;
-- SELECT * FROM `utlaan`;
