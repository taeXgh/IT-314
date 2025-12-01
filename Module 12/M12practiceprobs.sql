--Hands On Assignment Part 1
/* Assignment 6-4
The day of the week that baskets are created is often analyzed to determine consumer shopping patterns. 
Create a function named DAY_ORD_SF that 
1. accepts an order date
2. returns the weekday. 
--------------------------------------------------------------------------
Use the function in a SELECT statement to display each basket ID and the
weekday the order was created. 
Write a second SELECT statement, using this function to
display the total number of orders for each weekday. (Hint: Call the TO_CHAR function to retrieve the weekday from a date.)
--------------------------------------------------------------------------------------
1. Develop and run a CREATE FUNCTION statement to create the DAY_ORD_SF function. Use
the DTCREATED column of the BB_BASKET table as the date the basket is created. Call
the TO_CHAR function with the DAY option to retrieve the weekday for a date value.
2. Create a SELECT statement that lists the basket ID and weekday for every basket.
3. Create a SELECT statement, using a GROUP BY clause to list the total number of baskets
per weekday. Based on the results, what’s the most popular shopping day? */
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE FUNCTION day_ord_sf
(p_dtcrtd IN bb_basket.dtcreated%TYPE)
RETURN VARCHAR2
IS
BEGIN
  RETURN TO_CHAR(p_dtcrtd, 'DAY');
END;
/
--select statement to list basket ID and weekday for every basket
SELECT idbasket, day_ord_sf(dtcreated) AS weekday
FROM bb_basket;
--select statement to list total number of baskets per weekday
SELECT COUNT(*) AS total_baskets, day_ord_sf(dtcreated) AS weekday
FROM bb_basket
GROUP BY day_ord_sf(dtcreated)
ORDER BY total_baskets DESC;

/*Assignment 6-5 
An analyst in the quality assurance office reviews the time elapsed between receiving an order
and shipping the order. Any orders that haven’t been shipped within a day of the order being
placed are investigated. 
Create a function named ORD_SHIP_SF that 
1. calculates the number of days between the basket’s creation date(dtcreated) and the shipping date (dtstage where idstage = 5). 
2. returns a character string that states OK if the order was shipped within a day or CHECK if it wasn’t. 
3. If the order hasn’t shipped, return the string Not shipped.
------------------------------------------------------------------------------------------
The IDSTAGE column of the BB_BASKETSTATUS table indicates a shipped item with the value 5
the DTSTAGE column is the shipping date. 
The DTORDERED column of the BB_BASKET table is the order date.
------------------------------------------------------------------------------------------------------------------------------ 
Review data in the BB_BASKETSTATUS table, and create an anonymous block to test all three outcomes the function should handle.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE FUNCTION ord_ship_sf
(p_id IN bb_basket.idbasket%TYPE)
RETURN VARCHAR2
IS
  lv_shipdt bb_basketstatus.dtstage%TYPE;
  lv_orderdt bb_basket.dtordered%TYPE;
  lv_difference NUMBER;
BEGIN
  SELECT dtstage 
  INTO lv_shipdt
  FROM bb_basketstatus
  WHERE idbasket = p_id 
  AND idstage = 5;

  SELECT dtordered 
  INTO lv_orderdt
  FROM bb_basket
  WHERE idbasket = p_id;

  lv_difference := lv_shipdt - lv_orderdt;

  IF lv_difference <= 1 THEN
    RETURN 'OK';
  ELSE
    RETURN 'CHECK';
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'Not shipped';
END;
/
--anonymous block to test all three outcomes
DECLARE
  lv_result VARCHAR2(20);
BEGIN
    -- order shipped within a day
    lv_result := ord_ship_sf(4); 
    DBMS_OUTPUT.PUT_LINE('Test Case 1 Result: ' || lv_result);
    -- order shipped after more than a day
    lv_result := ord_ship_sf(3);
    DBMS_OUTPUT.PUT_LINE('Test Case 2 Result: ' || lv_result);
    -- order not shipped
    lv_result := ord_ship_sf(12);
    DBMS_OUTPUT.PUT_LINE('Test Case 3 Result: ' || lv_result);
END;
/
select dtstage, idstage, dtordered, idbasket
from bb_basketstatus INNER JOIN bb_basket
USING (idbasket);

/*Assignment 6-6
 When a shopper returns to the Web site to check an order’s status, information from the
BB_BASKETSTATUS table is displayed. However, only the status code is available in the
BB_BASKETSTATUS table, not the status description. 
Create a function named STATUS_DESC_SF that 
1. accepts a stage ID 
2. returns the status description. 
-----------------------------------------------------------------------
The descriptions for stage IDs are listed in Table 6-3. 
Test the function in a SELECT statement that 
1. retrieves all rows in the BB_BASKETSTATUS table for basket 4 
2. displays the stage ID and its description.
-----------------------------------------------------------------------
table 6-3
Stage ID Description
1 Order submitted
2 Accepted, sent to shipping
3 Back-ordered
4 Cancelled
5 Shipped
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE FUNCTION status_desc_sf
(p_idstage IN bb_basketstatus.idstage%TYPE)
RETURN VARCHAR2
IS
  lv_desc VARCHAR2(50);
BEGIN
  CASE p_idstage
    WHEN 1 THEN
        lv_desc := 'Order submitted';
    WHEN 2 THEN
        lv_desc := 'Accepted, sent to shipping';
    WHEN 3 THEN
        lv_desc := 'Back-ordered';
    WHEN 4 THEN
        lv_desc := 'Cancelled';
    WHEN 5 THEN
        lv_desc := 'Shipped';
    ELSE
        lv_desc := 'Unknown status';
    END CASE;
    RETURN lv_desc;
END;
/
--SELECT statement to retrieve all rows in BB_BASKETSTATUS for basket 4
SELECT idstage, status_desc_sf(idstage) AS description
FROM bb_basketstatus
WHERE idbasket = 4;

/* Assignment 6-7
Create a function named TAX_CALC_SF that 
1. accepts a basket ID --IN
2. calculates the tax amount by using the basket subtotal --body
3. returns the correct tax amount for the order.  -- return
-----------------------------------------------------------------------
The tax is determined by the shipping state, which is stored in the BB_BASKET table. (SHIPSTATE column)
The BB_TAX table contains the tax rate for states that require taxes on Internet purchases. (taxrate column)
If the state isn’t listed in the tax table or no shipping state is assigned to the basket
    a tax amount of zero should be applied to the order. (if not found in tax table, return 0)
Use the function in a SELECT statement that 
1. displays the shipping costs for a basket that has tax applied
2. displays the shipping costs for a basket with no shipping state.
*/
--brainstorming

/* SELECT IDBASKET, SHIPSTATE, SUBTOTAL, TOTAL, TAX
FROM BB_BASKET;

DESC BB_BASKET;
DESC BB_TAX;
--join the two using state
select b.idbasket, b.shipstate, b.subtotal, b.tax, t.taxrate, (ROUND(b.subtotal * t.taxrate, 2)) AS tax_amt
from bb_basket b, bb_tax t
where b.shipstate = t.state
and b.idbasket = 4; */
SELECT IDBASKET, SHIPSTATE, SUBTOTAL, TOTAL, TAX
FROM BB_BASKET;

---------------------
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE FUNCTION tax_calc_sf
(p_id IN bb_basket.idbasket%TYPE)
RETURN NUMBER
IS
  lv_tax_rt NUMBER(3,2);
  lv_sub NUMBER(10,2);
  lv_tax_amt NUMBER(10,2);
BEGIN
  SELECT subtotal 
  INTO lv_sub
  FROM bb_basket
  WHERE idbasket = p_id;

  SELECT taxrate
  INTO lv_tax_rt
  FROM bb_tax t, bb_basket b
  WHERE b.shipstate = t.state
  AND b.idbasket = p_id;
  lv_tax_amt := lv_sub * lv_tax_rt;
  RETURN lv_tax_amt;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END;
/
--SELECT statement to display shipping costs for a basket that has tax applied
SELECT idbasket, tax_calc_sf(idbasket) AS tax_amount
FROM bb_basket
WHERE idbasket = 4;
--SELECT statement to display shipping costs for a basket with no shipping state
SELECT idbasket, tax_calc_sf(idbasket) AS tax_amount
FROM bb_basket
WHERE idbasket = 12;

/* Assignment 6-8
When a product is placed on sale, Brewbean’s records the sale’s start and end dates in
columns of the BB_PRODUCT table. A function is needed to provide sales information when a
shopper selects an item. 
-------------------------body------------------------------------------
If a product is on sale
     return the value ON SALE!.
However, if it isn’t on sale
    return the value Great Deal!. 
These values are used on the product display page.
-------------------------specification---------------------------------
Create a function named CK_SALE_SF that 
1. accepts a date and product ID as arguments -- IN
2. checks whether the date falls within the product’s sale period -- body
3. returns the corresponding string value. -- return
-------------------------testing---------------------------------------
Test the function with the product ID 6 and two dates: 10-JUN-12 and 19-JUN-12. 
Verify your results by reviewing the product sales information.
*/

/* brainstorming
 desc bb_product;
select idproduct, salestart, saleend
from bb_product;

select salestart, saleend
from bb_product
where idproduct = 6; */

SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE FUNCTION CK_SALE_sf
(p_date in bb_product.salestart%TYPE,
 p_id IN bb_product.idproduct%TYPE)
RETURN VARCHAR2
IS
  lv_start bb_product.salestart%TYPE;
  lv_end bb_product.saleend%TYPE;
BEGIN
  SELECT salestart, saleend
  INTO lv_start, lv_end
  FROM bb_product
  WHERE idproduct = p_id;

  IF p_date BETWEEN lv_start AND lv_end THEN
    RETURN 'ON SALE!';
  ELSE
    RETURN 'Great Deal!';
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'Great Deal!';
END;
/
--test the function
DECLARE
  lv_result VARCHAR2(20);
BEGIN
    --test the function with product ID 6 and date 10-JUN-12
    lv_result := CK_SALE_SF(TO_DATE('10-JUN-12', 'DD-MON-YY'), 6);
    DBMS_OUTPUT.PUT_LINE('Test Case 1 Result: ' || lv_result);
    --test the function with product ID 6 and date 19-JUN-12
    lv_result := CK_SALE_SF(TO_DATE('19-JUN-12', 'DD-MON-YY'), 6);
    DBMS_OUTPUT.PUT_LINE('Test Case 2 Result: ' || lv_result);
END;
/