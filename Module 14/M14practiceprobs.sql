-- Ch 13 Hands On Assignment
-- Assignment 13-1 
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE VIEW CONTACT AS
SELECT contact, phone
FROM publisher2;

SELECT *
FROM CONTACT;

-- Assignment 13-2
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE VIEW CONTACT AS
SELECT contact, phone
FROM publisher2
WITH READ ONLY;

SELECT *
FROM CONTACT;

-- Assignment 13-3
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE FORCE VIEW HOMEWORK13 AS
SELECT Col1, COl2 
FROM FIRSTATTEMPT;

--Assignment 13-4
SELECT sysdate, 'Thalia Edwards' FROM dual;

SELECT * 
FROM HOMEWORK13;

--Assignment 13-5
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE VIEW REORDERINFO AS
SELECT b.isbn, b.title, p.contact, p.phone
FROM books b, publisher2 p
WHERE b.pubid = p.id;

SELECT *
FROM REORDERINFO;

-- Assignment 13-6
SELECT sysdate, 'Thalia Edwards' FROM dual;

SAVEPOINT before_dml;

UPDATE REORDERINFO
SET contact = 'Thalia Edwards'
WHERE isbn LIKE '%0733';

SELECT *
FROM REORDERINFO;

-- Assignment 13-7
SELECT sysdate, 'Thalia Edwards' FROM dual;

UPDATE REORDERINFO
SET isbn = '22'
WHERE isbn LIKE '%0733';

SELECT *
FROM REORDERINFO;

-- Assignment 13-8
SELECT sysdate, 'Thalia Edwards' FROM dual;

DELETE FROM REORDERINFO
WHERE isbn = '0401140733';

SELECT *
FROM REORDERINFO;


-- Assignment 13-9
SELECT sysdate, 'Thalia Edwards' FROM dual;

ROLLBACK TO before_dml;

-- Assignment 13-10
SELECT sysdate, 'Thalia Edwards' FROM dual;

DROP VIEW REORDERINFO;

SELECT *
FROM REORDERINFO;