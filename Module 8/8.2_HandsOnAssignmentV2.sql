--product information
SELECT idProduct, productname, price, active, type, idDepartment, stock
    FROM bb_product;

--order information
SELECT idShopper, b.idBasket, b.orderplaced, b.dtordered, b.dtcreated
    FROM bb_shopper s INNER JOIN bb_basket b
        USING (idShopper);

--product option information
SELECT idProduct, p.productname, pc.categoryname, pd.optionname
    FROM bb_product p INNER JOIN bb_productoption
        USING (idProduct)
            INNER JOIN bb_productoptiondetail pd
                USING (idOption)
                    INNER JOIN bb_productoptioncategory pc
                        USING (idOptioncategory);



--Hands On Assignment Part 1
--Assignment 1-1
/*problem 1
Produce an unduplicated list of all product IDs 
for all products that have been sold. Sort the list.*/  
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT DISTINCT idProduct, p.productname
    FROM bb_shopper s 
    INNER JOIN bb_basket b
        USING (idShopper)
    INNER JOIN bb_basketitem bi
        USING (idBasket)
    INNER JOIN bb_product p
        USING (idProduct)
    WHERE orderplaced = 1;

/*problem 2
Show the basket ID, product ID, product name, and description for all items ordered. 
(Do it two ways—one with an ANSI join and one with a traditional join.)*/
--ANSI join
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT idBasket, idProduct, productname, description
    FROM bb_basket INNER JOIN bb_basketitem 
        USING (idBasket)
            INNER JOIN bb_product
                USING (idProduct)
    WHERE orderplaced = 1;
--traditional join
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT b.idBasket, bi.idProduct, p.productname, p.description
FROM bb_basket b, bb_basketitem bi, bb_product p
WHERE b.idBasket = bi.idBasket
AND bi.idProduct = p.idProduct
AND orderplaced = 1;
/*problem 3
Modify the queries in Step 2 to include the customer’s last name.*/
--ANSI join
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT lastname, idBasket, idProduct, productname, description
    FROM bb_basket INNER JOIN bb_basketitem 
        USING (idBasket)
            INNER JOIN bb_product
                USING (idProduct)
                    INNER JOIN bb_shopper
                        USING (idShopper)
    WHERE orderplaced = 1;
--traditional join
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT s.lastname, b.idBasket, bi.idProduct, p.productname, p.description
FROM bb_basket b, bb_basketitem bi, bb_product p, bb_shopper s
WHERE b.idBasket = bi.idBasket
AND bi.idProduct = p.idProduct
AND b.idShopper = s.idShopper
AND orderplaced = 1;
/*problem 4
Display all orders (basket ID, shopper ID, and date ordered) placed in February 2012. 
The date should be displayed in this format: February 12, 2012. 
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT idBasket, idShopper,TO_CHAR(dtordered, 'Month DD, YYYY') AS dateordered
   FROM bb_shopper
        INNER JOIN bb_basket
            USING (idShopper)
   WHERE dtordered BETWEEN TO_DATE('February 1, 2012', 'Month DD, YYYY') AND TO_DATE('February 29, 2012', 'Month DD, YYYY');

/*problem 5
Display the total quantity sold by product ID. */
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT bi.idProduct, b.quantity AS quantity_sold
FROM bb_basket b, bb_basketitem bi, bb_product p, bb_shopper s
WHERE b.idBasket = bi.idBasket
AND bi.idProduct = p.idProduct
AND b.idShopper = s.idShopper
AND orderplaced = 1; 

/*problem 6
Modify the query in Step 5 to show only products that have sold less than a quantity of 3. */
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT bi.idProduct, b.quantity AS quantity_sold
FROM bb_basket b, bb_basketitem bi, bb_product p, bb_shopper s
WHERE b.idBasket = bi.idBasket
AND bi.idProduct = p.idProduct
AND b.idShopper = s.idShopper
AND orderplaced = 1
AND b.quantity < 3;

/*problem 7
List all active coffee products (product ID, name, and price) for all coffee items priced above the overall average of coffee items.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT idProduct, productname, price, active, type, idDepartment, stock
    FROM bb_product
    WHERE type = 'C'
    AND active = 1
    AND price > (SELECT AVG(price)
                    FROM bb_product
                    WHERE type = 'C');

/*problem 8 
Create a table named CONTACTS that includes the following columns*/
CREATE TABLE CONTACTS (
    Con_id NUMBER(4) PRIMARY KEY,
    Company_name VARCHAR2(30) NOT NULL,
    Email VARCHAR2(30),
    Last_date DATE DEFAULT SYSDATE,
    Con_cnt NUMBER(3) CHECK(Con_cnt > 0)
);

/*problem 9 
Add two rows of data to the table, using data values you create. Make sure the default
option on the LAST_DATE column is used in the second row added. Also, issue a
command to save the data in the table permanently.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
SAVEPOINT preInsertContacts;
INSERT INTO CONTACTS (Con_id, Company_name, Email, Last_date, Con_cnt) VALUES (
    1234, 'Google', 'employeename@gmail.com', '30-DEC-03', 1
);
INSERT INTO CONTACTS (Con_id, Company_name, Email, Con_cnt) VALUES (
    5678, 'Microsoft', 'employeename@outlook.com', 2
);
COMMIT;
select * from CONTACTS;
/*problem 10 
Issue a command to change the e-mail value for the first row added to the table. Show a
query on the table to confirm that the change was completed. Then issue a command to
undo the change
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
SAVEPOINT preUpdateEmail;
UPDATE CONTACTS
    SET Email = 'newemail@gmail.com'
    WHERE Con_id = 1234;
SELECT * FROM CONTACTS;
ROLLBACK TO preUpdateEmail;

/*
Hands On Assignment Part 2
Assignment 1-5
*/
SELECT * FROM dd_donor;
SELECT * FROM dd_pledge;
SELECT * FROM dd_payment;
SELECT * FROM dd_project;
SELECT * FROM dd_status;
/*problem 1 
List each donor who has made a pledge and indicated a single lump sum payment. Include
first name, last name, pledge date, and pledge amount.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT firstname, lastname, pledgedate, pledgeamt
FROM dd_donor INNER JOIN dd_pledge
USING (iddonor)
WHERE paymonths = 0;
/*problem 2
List each donor who has made a pledge and indicated monthly payments over one year.
Include first name, last name, pledge date, and pledge amount. Also, display the monthly
payment amount. (Equal monthly payments are made for all pledges paid in monthly
payments.)
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT firstname ||' '|| lastname AS full_name, pledgedate, pledgeamt
FROM dd_donor 
    INNER JOIN dd_pledge
        USING (iddonor)
            INNER JOIN dd_payment
                USING (idpledge)
WHERE paymonths = 12
ORDER BY lastname, firstname, pledgedate;

/*problem 3
Display an unduplicated list of projects (ID and name) that have pledges committed. Don’t
display all projects defined; list only those that have pledges assigned.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT DISTINCT idproj, projname
FROM dd_project
    INNER JOIN dd_pledge
        USING (idproj);

/*problem 4
Display the number of pledges made by each donor. Include the donor ID, first name, last
name, and number of pledges.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

SELECT iddonor, firstname, lastname, COUNT(idpledge) AS number_of_pledges
FROM dd_donor
    INNER JOIN dd_pledge
        USING (iddonor)
GROUP BY iddonor, firstname, lastname
ORDER BY number_of_pledges DESC;

/*problem 5
Display all pledges made before March 8, 2012. Include all column data from the
DD_PLEDGE table.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT *
FROM dd_pledge
WHERE pledgedate < ;