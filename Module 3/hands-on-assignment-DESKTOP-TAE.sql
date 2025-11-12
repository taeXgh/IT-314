--problem 1
SELECT sysdate, 'Thalia Edwards' FROM dual;

INSERT INTO ORDERS VALUES (
 1021, 1009, '20-JUL-2009', NULL, NULL, NULL, NULL, NULL, NULL
);

SELECT * 
    FROM ORDERS
    WHERE ORDER# = 1021;

-- problem 2
SELECT sysdate, 'Thalia Edwards' FROM dual;

UPDATE ORDERS
SET SHIPZIP = 33222
WHERE ORDER# = 1017;

SELECT * FROM ORDERS
WHERE SHIPZIP = 33222;

-- problem 3
SELECT sysdate, 'Thalia Edwards' FROM dual;

COMMIT;

-- problem 4
SELECT sysdate, 'Thalia Edwards' FROM dual;

INSERT INTO ORDERS VALUES (
 1022, 2000, '06-AUG-2009', NULL, NULL, NULL, NULL, NULL, NULL
);

SELECT * 
    FROM ORDERS
    WHERE ORDER# = 1022;
	
-- problem 5
SELECT sysdate, 'Thalia Edwards' FROM dual;

INSERT INTO ORDERS VALUES (
1023, 1009, NULL, NULL, NULL, NULL, NULL, NULL, NULL
);

SELECT * 
    FROM ORDERS
    WHERE ORDER# = 1023;

-- problem 6
SELECT sysdate, 'Thalia Edwards' FROM dual;

UPDATE BOOKS
SET COST = &COST
WHERE ISBN = '&ISBN';

SAVEPOINT ONE;

-- problem 7
SELECT sysdate, 'Thalia Edwards' FROM dual;

ROLLBACK TO ONE;

-- problem 8
SELECT sysdate, 'Thalia Edwards' FROM dual;

-- problem 9
SELECT sysdate, 'Thalia Edwards' FROM dual;

-- problem 10
SELECT sysdate, 'Thalia Edwards' FROM dual;