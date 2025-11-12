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
SELECT DISTINCT idProduct, productname
    FROM bb_product
    ORDER BY idProduct;

/*problem 2
Show the basket ID, product ID, product name, and description for all items ordered. 
(Do it two ways—one with an ANSI join and one with a traditional join.)*/
--ANSI join
SELECT idBasket, idProduct, productname, description
FROM bb_basket INNER JOIN bb_basketitem 
    USING (idBasket)
        INNER JOIN bb_product
            USING (idProduct);
--traditional join
SELECT b.idBasket, bi.idProduct, p.productname, p.description
FROM bb_basket b, bb_basketitem bi, bb_product p
WHERE b.idBasket = bi.idBasket
AND bi.idProduct = p.idProduct;
/*problem 3
Modify the queries in Step 2 to include the customer’s last name.*/
--ANSI join
SELECT lastname, idBasket, idProduct, productname, description
FROM bb_basket INNER JOIN bb_basketitem 
    USING (idBasket)
        INNER JOIN bb_product
            USING (idProduct)
                INNER JOIN bb_shopper
                    USING (idShopper);
--traditional join
SELECT s.lastname, b.idBasket, bi.idProduct, p.productname, p.description
FROM bb_basket b, bb_basketitem bi, bb_product p, bb_shopper s
WHERE b.idBasket = bi.idBasket
AND bi.idProduct = p.idProduct
AND b.idShopper = s.idShopper;
/*problem 4
Display all orders (basket ID, shopper ID, and date ordered) placed in February 2012. The date should be displayed in this format: February 12, 2012. 
*/

/*problem 5
Display the total quantity sold by product ID. */

/*problem 6
Modify the query in Step 5 to show only products that have sold less than a quantity of 3. */

/*problem 7
List all active coffee products (product ID, name, and price) for all coffee items priced above the overall average of coffee items.
*/

/*problem 8 
Create a table named CONTACTS that includes the following columns:8*/

/*problem 9 
Add two rows of data to the table, using data values you create. Make sure the default
option on the LAST_DATE column is used in the second row added. Also, issue a
command to save the data in the table permanently.
*/

/*problem 10 
Issue a command to change the e-mail value for the first row added to the table. Show a
query on the table to confirm that the change was completed. Then issue a command to
undo the change
*/

/*
Hands On Assignment Part 2
Assignment 1-5

*/