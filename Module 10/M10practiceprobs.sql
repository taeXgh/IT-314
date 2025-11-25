--Hands On Assignment Part 1
--Assignment 3-1

SELECT sysdate, 'Thalia Edwards' FROM dual;
DECLARE
  lv_ship_date bb_basketstatus.dtstage%TYPE;
  lv_shipper_txt bb_basketstatus.shipper%TYPE;
  lv_ship_num bb_basketstatus.shippingnum%TYPE;
  lv_bask_num bb_basketstatus.idbasket%TYPE := 3;
BEGIN
  SELECT dtstage, shipper, shippingnum
   INTO lv_ship_date, lv_shipper_txt, lv_ship_num
   FROM bb_basketstatus
   WHERE idbasket = lv_bask_num
    AND idstage = 5;
  DBMS_OUTPUT.PUT_LINE('Date Shipped: '||lv_ship_date);
  DBMS_OUTPUT.PUT_LINE('Shipper: '||lv_shipper_txt);
  DBMS_OUTPUT.PUT_LINE('Shipping #: '||lv_ship_num);
END;
/
--Assignment 3-2
SELECT sysdate, 'Thalia Edwards' FROM dual;
DECLARE
  rec_ship bb_basketstatus%ROWTYPE;
  lv_bask_num bb_basketstatus.idbasket%TYPE := 3;
BEGIN
  SELECT *
   INTO rec_ship
   FROM bb_basketstatus
   WHERE idbasket =  lv_bask_num
    AND idstage = 5;
  DBMS_OUTPUT.PUT_LINE('Date Shipped: '||rec_ship.dtstage);
  DBMS_OUTPUT.PUT_LINE('Shipper: '||rec_ship.shipper);
  DBMS_OUTPUT.PUT_LINE('Shipping #: '||rec_ship.shippingnum);
  DBMS_OUTPUT.PUT_LINE('Notes: '||rec_ship.notes);
END;
/
--Assignment 3-3
SELECT sysdate, 'Thalia Edwards' FROM dual;
DECLARE
    lv_total_num NUMBER(6,2);
    lv_rating_txt VARCHAR2(4);
    lv_shop_num bb_basket.idshopper%TYPE := 22;
BEGIN
    SELECT SUM(total)
    INTO lv_total_num

    FROM bb_basket
    WHERE idShopper = 22
    AND orderplaced = 1
    GROUP BY idshopper;
    IF lv_total_num > 200 THEN
        lv_rating_txt := 'High';
    ELSIF lv_total_num <200 AND lv_total_num >=100 THEN
        lv_rating_txt :='Mid';
    ELSE
        lv_rating_txt := 'Low';

  END IF; 
   DBMS_OUTPUT.PUT_LINE('Shopper '||lv_shop_num||' is rated '||lv_rating_txt);
END;
/
/* Assignment 3-4
The Brewbean’s application needs a block to determine whether a customer is rated HIGH,
MID, or LOW based on his or her total purchases. The block needs to select the total amount of
orders for a specified customer, determine the rating, and then display the results onscreen.
The code rates the customer HIGH if total purchases are greater than $200, MID if greater than
$100, and LOW if $100 or lower. Use an initialized variable to provide the shopper ID.*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
DECLARE
    lv_total_num NUMBER(6,2);
    lv_rating_txt VARCHAR2(4);
    lv_shop_num bb_basket.idshopper%TYPE := 24;
BEGIN
    SELECT SUM(total)
    INTO lv_total_num

    FROM bb_basket
    WHERE idShopper = 24
    AND orderplaced = 1
    GROUP BY idshopper;
    CASE
        WHEN lv_total_num >= 200 THEN
            lv_rating_txt := 'High';
        WHEN lv_total_num <200 AND lv_total_num >=100 THEN
            lv_rating_txt :='Mid';
        ELSE
            lv_rating_txt := 'Low';
    END CASE;
    DBMS_OUTPUT.PUT_LINE('Shopper '||lv_shop_num||' is rated '||lv_rating_txt);
END;
/
/* Assignment 3-5
Brewbean’s wants to include a feature in its application that calculates the total amount (quantity)
of a specified item that can be purchased with a given amount of money. Create a block with a
WHILE loop to increment the item’s cost until the dollar value is met. Test first with a total spending
amount of $100 and product ID 4. Then test with an amount and a product of your choice. Use
initialized variables to provide the total spending amount and product ID.*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
DECLARE
    lv_purchaseable_qty NUMBER := 0;
    lv_amount NUMBER;
    lv_total_spending_amount NUMBER := 100;
    lv_product_id bb_product.idproduct%TYPE := 4;
    lv_product_price bb_product.price%TYPE;

BEGIN
    SELECT price
    INTO lv_product_price
    FROM bb_product
    WHERE idproduct = 4;

    WHILE lv_total_spending_amount >= lv_product_price LOOP
        lv_purchaseable_qty := lv_purchaseable_qty + 1;
        lv_total_spending_amount := lv_total_spending_amount - lv_product_price;
        lv_amount := lv_purchaseable_qty * lv_product_price;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('qty: ' || lv_purchaseable_qty);
    DBMS_OUTPUT.PUT_LINE('amt: ' || lv_amount);
END;
/
/* Assignment 3-8
The Brewbean’s application contains a page displaying order summary information, including
IDBASKET, SUBTOTAL, SHIPPING, TAX, and TOTAL columns from the BB_BASKET
table. Create a PL/SQL block with a record variable to retrieve this data and display it
onscreen. An initialized variable should provide the IDBASKET value. Test the block using
the basket ID 12.*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
DECLARE
    TYPE type_basket IS RECORD(
        basket bb_basket.idBasket%TYPE,
        sub bb_basket.subtotal%TYPE,
        shipping bb_basket.shipping%TYPE,
        tax bb_basket.tax%TYPE,
        total bb_basket.total%TYPE
    );
    rec_basket type_basket;
    lv_basket_num NUMBER(3) := 12;
BEGIN
    SELECT idBasket, subtotal, shipping, tax, total
    INTO rec_basket
    FROM bb_basket
    WHERE idBasket = lv_basket_num;
    DBMS_OUTPUT.PUT_LINE(rec_basket.basket);
    DBMS_OUTPUT.PUT_LINE(rec_basket.sub);
    DBMS_OUTPUT.PUT_LINE(rec_basket.shipping);
    DBMS_OUTPUT.PUT_LINE(rec_basket.tax);
    DBMS_OUTPUT.PUT_LINE(rec_basket.total);
END;
/

/* long version
    TYPE type_basket IS TABLE OF bb_basket%ROWTYPE
    INDEX BY BINARY_INTEGER;
    tbl_items type_basket;
    lv_ind_num NUMBER(3) := 1;
    lv_id_num bb_basket.idbasket%TYPE := 12;
    lv_subtotal_num bb_basket.subtotal%TYPE;
    lv_shipping_num bb_basket.shipping%TYPE;
    lv_tax_num bb_basket.tax%TYPE;
    lv_total_num bb_basket.total%TYPE;

BEGIN
    tbl_items(lv_ind_num).idbasket := lv_id_num;
    tbl_items(lv_ind_num).subtotal := lv_subtotal_num;
    tbl_items(lv_ind_num).shipping := lv_shipping_num;
    tbl_items(lv_ind_num).tax := lv_tax_num;
    tbl_items(lv_ind_num).total := lv_total_num;
    DBMS_OUTPUT.PUT_LINE(lv_ind_num);
    DBMS_OUTPUT.PUT_LINE(tbl_items(lv_ind_num).idbasket);
END;
/
*/