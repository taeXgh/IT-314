--Hands On Assignment Part 1
/* Assignment 7-1
Follow the steps to create a package containing a procedure and a function pertaining to basket
information. (Note: The first time you compile the package body doesn’t give you practice with
compilation error messages.)
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE PACKAGE order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2;
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE);
END;
/

CREATE OR REPLACE PACKAGE BODY order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2
  IS
   lv_name_txt VARCHAR2(25);
 BEGIN
  SELECT shipfirstname||' '||shiplastname
   INTO lv_name_txt
   FROM bb_basket
   WHERE idBasket = p_basket;
  RETURN lv_name_txt;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END ship_name_pf;
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE)
  IS
 BEGIN
   SELECT idshopper, dtordered
    INTO p_shop, p_date
    FROM bb_basket
    WHERE idbasket = p_basket;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END basket_info_pp;
END;
/

/* Assignment 7-2
In this assignment, you use program units in a package created to store basket information. The
package contains a function that returns the recipient’s name and a procedure that retrieves the
shopper ID and order date for a basket.
Create an anonymous block that calls both the packaged procedure and function with
basket ID 12 to test these program units. Use DBMS_OUTPUT statements to display values
returned from the program units to verify the data.
3. Also, test the packaged function by using it in a SELECT clause on the BB_BASKET table.
Use a WHERE clause to select only the basket 12 row.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE PACKAGE order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2;

 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE);

END;
/

CREATE OR REPLACE PACKAGE BODY order_info_pkg 
IS
  FUNCTION ship_name_pf  
  (p_basket IN NUMBER)
  RETURN VARCHAR2
  IS
    lv_name_txt VARCHAR2(25);
  BEGIN
    SELECT shipfirstname||' '||shiplastname
      INTO lv_name_txt
      FROM bb_basket
      WHERE idBasket = p_basket;
      RETURN lv_name_txt;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invalid basket id');
  END ship_name_pf;

  PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE)
  IS
    BEGIN
      SELECT idshopper, dtordered
      INTO p_shop, p_date
      FROM bb_basket
      WHERE idbasket = p_basket;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invalid basket id');
  END basket_info_pp;

END;
/

DECLARE
    lv_shop_num NUMBER;
    lv_order_date DATE;
    lv_ship_name VARCHAR2(25);
    lv_basket_id NUMBER := 12;
BEGIN
    order_info_pkg.basket_info_pp(lv_basket_id, lv_shop_num, lv_order_date);
    DBMS_OUTPUT.PUT_LINE('Order Date: ' || lv_order_date);
END;
/

/* Assignment 7-3
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE PACKAGE order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2;
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE);
END;

CREATE OR REPLACE PACKAGE BODY order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2
  IS
   lv_name_txt VARCHAR2(25);
 BEGIN
  SELECT shipfirstname||' '||shiplastname
   INTO lv_name_txt
   FROM bb_basket
   WHERE idBasket = p_basket;
  RETURN lv_name_txt;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END ship_name_pf;
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE)
  IS
 BEGIN
   SELECT idshopper, dtordered
    INTO p_shop, p_date
    FROM bb_basket
    WHERE idbasket = p_basket;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END basket_info_pp;
END;

/* Assignment 7-4
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;



/* Assignment 7-5
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

