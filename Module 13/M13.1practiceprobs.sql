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
  lv_bask_num bb_basket.idbasket%TYPE := 12;
  lv_shop_num bb_basket.idshopper%TYPE;
  lv_date DATE;
  lv_ship_name VARCHAR2(50);
BEGIN
  lv_ship_name := order_info_pkg.ship_name_pf(lv_bask_num);
  order_info_pkg.basket_info_pp(lv_bask_num, lv_shop_num, lv_date);
  DBMS_OUTPUT.PUT_LINE(lv_date);
  DBMS_OUTPUT.PUT_LINE(lv_ship_name);
END;
/

SELECT idbasket, order_info_pkg.ship_name_pf(idbasket) AS ship_name
FROM bb_basket
WHERE idbasket = 12;

/* Assignment 7-3
In this assignment, you modify a package to make program units private. The Brewbean’s
programming group decided that the SHIP_NAME_PF function in the ORDER_INFO_PKG
package should be used only from inside the package. Follow these steps to make this
modification:
2. Modify the package code to add to the BASKET_INFO_PP procedure so that it also returns
the name an order is shipped by using the SHIP_NAME_PF function. Make the necessary
changes to make the SHIP_NAME_PF function private.
3. Create the package by using the modified code.
4. Create and run an anonymous block that calls the BASKET_INFO_PP procedure and
displays the shopper ID, order date, and shipped-to name to check the values returned.
Use DBMS_OUTPUT statements to display the values.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE PACKAGE order_info_pkg IS
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE,
   p_name OUT VARCHAR2);
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
   p_date OUT DATE,
   p_name OUT VARCHAR2)
  IS
  BEGIN
    SELECT idshopper, dtordered
      INTO p_shop, p_date
      FROM bb_basket
      WHERE idbasket = p_basket;
    p_name := ship_name_pf(p_basket);
 EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END basket_info_pp;
END;
/

DECLARE
  lv_bask_num bb_basket.idbasket%TYPE := 12;
  lv_shop_num bb_basket.idshopper%TYPE;
  lv_date DATE;
  lv_ship_name VARCHAR2(50);
BEGIN
  order_info_pkg.basket_info_pp(lv_bask_num, lv_shop_num, lv_date, lv_ship_name);
  DBMS_OUTPUT.PUT_LINE( 'Shopper ID: ' || lv_shop_num || 
                        ' | Order Date: ' || lv_date || 
                        ' | Ship Name: ' || lv_ship_name);
END;
/

/* Assignment 7-4
In this assignment, you create a package that uses packaged variables to assist in the user
logon process. When a returning shopper logs on, 
the username and password entered need to be verified against the database. 
In addition, two values need to be stored in 
packaged variables for reference during the user session: 
1. the shopper ID 
2. the first three digits of the shopper’s zip code 
(used for regional advertisements displayed on the site).

1. Create a function that accepts a username and password as arguments and verifies these
values against the database for a match. If a match is found, return the value Y. Set the
value of the variable holding the return value to N. Include a NO_DATA_FOUND exception
handler to display a message that the logon values are invalid.

2. Use an anonymous block to test the procedure, using the username gma1 and the
password goofy.

3. Now place the function in a package, and add code to create and populate the packaged
variables specified earlier. Name the package LOGIN_PKG.

4. Use an anonymous block to test the packaged procedure, using the username gma1 and
the password goofy to verify that the procedure works correctly.

5. Use DBMS_OUTPUT statements in an anonymous block to display the values stored in the
packaged variables.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE PACKAGE login_pkg IS
pvg_shop_id bb_shopper.idshopper%TYPE;
pvg_zip_prefix bb_shopper.zipcode%TYPE;
FUNCTION verify_login_pf
  (p_user IN VARCHAR2,
   p_pass IN VARCHAR2)
  RETURN CHAR;
END;
/

CREATE OR REPLACE PACKAGE BODY login_pkg IS
FUNCTION verify_login_pf
  (p_user IN VARCHAR2,
   p_pass IN VARCHAR2)
  RETURN CHAR
  IS
    lv_match_found_txt CHAR(1) := 'N';
    lv_password bb_shopper.password%TYPE;
  BEGIN
    SELECT password
    INTO lv_password
    FROM bb_shopper
    WHERE username = p_user;
    IF lv_password = p_pass THEN
      lv_match_found_txt := 'Y';
      SELECT idshopper, SUBSTR(zipcode, 1, 3)
      INTO pvg_shop_id, pvg_zip_prefix
      FROM bb_shopper
      WHERE username = p_user;
      /* DBMS_OUTPUT.PUT_LINE('Shopper ID: ' || pvg_shop_id);
      DBMS_OUTPUT.PUT_LINE('Zip Prefix: ' || pvg_zip_prefix); */
      RETURN lv_match_found_txt;
    ELSE
      lv_match_found_txt := 'N';
      RETURN lv_match_found_txt;
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Invalid login credentials.');
      RETURN lv_match_found_txt;
  END verify_login_pf;
END;
/
DECLARE
  lv_user_txt bb_shopper.username%TYPE := 'gma1';
  lv_pass_txt bb_shopper.password%TYPE := 'goofy';
  lv_return_char CHAR(1);
BEGIN
  lv_return_char := login_pkg.verify_login_pf(lv_user_txt, lv_pass_txt);
  IF lv_return_char = 'Y' THEN
    DBMS_OUTPUT.PUT_LINE('Login successful.');
    DBMS_OUTPUT.PUT_LINE(lv_return_char);
    DBMS_OUTPUT.PUT_LINE('Shopper ID: ' || login_pkg.pvg_shop_id);
    DBMS_OUTPUT.PUT_LINE('Zip Prefix: ' || login_pkg.pvg_zip_prefix);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Login failed.');
  END IF;
END;
/

/* Assignment 7-5
In this assignment, you create packaged procedures to retrieve shopper information.
Brewbean’s is adding an application page where customer service agents can retrieve shopper
information by using shopper ID or last name. Create a package named SHOP_QUERY_PKG
containing overloaded procedures to perform these lookups. They should return the shopper’s
name, city, state, phone number, and e-mail address. Test the package twice. First, call the
procedure with shopper ID 23, and then call it with the last name Ratman. Both test values refer
to the same shopper, so they should return the same shopper information.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE PACKAGE shop_query_pkg IS
  PROCEDURE retrieve_shopper_info_pp
  (p_id IN bb_shopper.idshopper%TYPE,
   p_name OUT VARCHAR2,
   p_city OUT VARCHAR2,
   p_state OUT VARCHAR2,
   p_phone OUT VARCHAR2,
   p_email OUT VARCHAR2);

   PROCEDURE retrieve_shopper_info_pp
  (p_last IN bb_shopper.lastname%TYPE,
   p_name OUT VARCHAR2,
   p_city OUT VARCHAR2,
   p_state OUT VARCHAR2,
   p_phone OUT VARCHAR2,
   p_email OUT VARCHAR2);
END;
/
CREATE OR REPLACE PACKAGE BODY shop_query_pkg IS
  PROCEDURE retrieve_shopper_info_pp
  (p_id IN bb_shopper.idshopper%TYPE,
   p_name OUT VARCHAR2,
   p_city OUT VARCHAR2,
   p_state OUT VARCHAR2,
   p_phone OUT VARCHAR2,
   p_email OUT VARCHAR2)
  IS
  BEGIN
    SELECT firstname||' '||lastname, city, state, phone, email
    INTO p_name, p_city, p_state, p_phone, p_email
    FROM bb_shopper
    WHERE idshopper = p_id;
  END retrieve_shopper_info_pp;

  PROCEDURE retrieve_shopper_info_pp
  (p_last IN bb_shopper.lastname%TYPE,
   p_name OUT VARCHAR2,
   p_city OUT VARCHAR2,
   p_state OUT VARCHAR2,
   p_phone OUT VARCHAR2,
   p_email OUT VARCHAR2)
  IS
  BEGIN
    SELECT firstname||' '||lastname, city, state, phone, email
    INTO p_name, p_city, p_state, p_phone, p_email
    FROM bb_shopper
    WHERE lastname = p_last;
  END retrieve_shopper_info_pp;
END;
/
DECLARE
  lv_name VARCHAR2(50);
  lv_city VARCHAR2(30);
  lv_state VARCHAR2(3);
  lv_phone VARCHAR2(15);
  lv_email VARCHAR2(50);
BEGIN
  shop_query_pkg.retrieve_shopper_info_pp(23, lv_name, lv_city, lv_state, lv_phone, lv_email);
  DBMS_OUTPUT.PUT_LINE('Shopper Info by ID: ');
  DBMS_OUTPUT.PUT_LINE('Name: ' || lv_name);
  DBMS_OUTPUT.PUT_LINE('City: ' || lv_city);
  DBMS_OUTPUT.PUT_LINE('State: ' || lv_state);
  DBMS_OUTPUT.PUT_LINE('Phone: ' || lv_phone);
  DBMS_OUTPUT.PUT_LINE('Email: ' || lv_email);

  shop_query_pkg.retrieve_shopper_info_pp('Ratman', lv_name, lv_city, lv_state, lv_phone, lv_email);
  DBMS_OUTPUT.PUT_LINE('Shopper Info by Last Name: ');
  DBMS_OUTPUT.PUT_LINE('Name: ' || lv_name);
  DBMS_OUTPUT.PUT_LINE('City: ' || lv_city);
  DBMS_OUTPUT.PUT_LINE('State: ' || lv_state);
  DBMS_OUTPUT.PUT_LINE('Phone: ' || lv_phone);
  DBMS_OUTPUT.PUT_LINE('Email: ' || lv_email);
END;
/