/* Assignment 5-5
Create a procedure named STATUS_SHIP_SP that allows an employee in the Shipping
Department to update an order status to add shipping information. The BB_BASKETSTATUS
table lists events for each order so that a shopper can see the current status, date, and
comments as each stage of the order process is finished. The IDSTAGE column of the BB_BASKETSTATUS table identifies each stage; 
the value 3 in this column indicates that an order has been shipped. The procedure should allow adding a row with an IDSTAGE of 3, 
date shipped, tracking number, and shipper. The BB_STATUS_SEQ sequence is used to provide a value for the primary key column. 
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

--procedure to update order status with shipping info
CREATE OR REPLACE PROCEDURE STATUS_SHIP_SP  
    (p_statusid IN bb_basketstatus.idstatus%TYPE,
     p_basketid IN bb_basketstatus.idbasket%TYPE,
     p_stageid IN bb_basketstatus.idstage%TYPE,
     p_datestage IN bb_basketstatus.dtstage%TYPE,
     p_notes IN bb_basketstatus.notes%TYPE,
     p_shipper IN bb_basketstatus.shipper%TYPE,
     p_shipNum IN bb_basketstatus.shippingnum%TYPE
     )
IS
BEGIN
    INSERT INTO bb_basketstatus
    (idstatus, idbasket, idstage, dtstage, notes, shipper, shippingnum)
    VALUES
    (bb_status_seq.NEXTVAL, p_basketid, p_stageid, p_datestage, p_notes, p_shipper, p_shipNum);
END STATUS_SHIP_SP;
/
--test the procedure
DECLARE
    lv_statusid bb_basketstatus.idstatus%TYPE;
    lv_basketid bb_basketstatus.idbasket%TYPE := 3;
    lv_stageid bb_basketstatus.idstage%TYPE := 3;
    lv_datestage bb_basketstatus.dtstage%TYPE := TO_DATE('20-FEB-12', 'DD-MON-YY');
    lv_notes bb_basketstatus.notes%TYPE;
    lv_shipper bb_basketstatus.shipper%TYPE;
    lv_shipNum bb_basketstatus.shippingnum%TYPE := 'ZW2384YXK4957';
BEGIN
    STATUS_SHIP_SP(lv_statusid, lv_basketid, lv_stageid, lv_datestage, lv_notes, lv_shipper, lv_shipNum);  
END;
/
SELECT * FROM bb_basketstatus WHERE idbasket = 3;  --check the inserted data
delete FROM bb_basketstatus WHERE idbasket = 3 AND idstage = 3;  --cleanup test data

/* Assignment 5-6
Create a procedure that returns the most recent order status information for a specified basket.
This procedure should determine the most recent ordering-stage entry in the BB_BASKETSTATUS
table and return the data. Use an IF or CASE clause to return a stage description instead
of an IDSTAGE number, which means little to shoppers. The IDSTAGE column of the
BB_BASKETSTATUS table identifies each stage as follows:
1—Submitted and received
2—Confirmed, processed, sent to shipping
3—Shipped
4—Cancelled
5—Back-ordered
The procedure should accept a basket ID number and return the most recent status
description and date the status was recorded. If no status is available for the specified basket
ID, return a message stating that no status is available. Name the procedure STATUS_SP. Test
the procedure twice with the basket ID 4 and then 6.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE PROCEDURE STATUS_SP
(p_baskketid IN bb_basketstatus.idbasket%TYPE,
 p_status_desc OUT VARCHAR2,
 p_status_date OUT bb_basketstatus.dtstage%TYPE)
 IS
 BEGIN
    DBMS_OUTPUT.PUT_LINE('status proc called');
    DECLARE
        CURSOR cur_status IS
        SELECT IDSTAGE, DTSTAGE
        FROM BB_BASKETSTATUS
        WHERE IDBASKET = p_baskketid
        ORDER BY DTSTAGE DESC;
    BEGIN
        OPEN cur_status;
        LOOP
            FETCH cur_status INTO p_status_desc, p_status_date;
            EXIT WHEN cur_status%NOTFOUND;
            CASE p_status_desc
                WHEN 1 THEN p_status_desc := 'Submitted and received';
                WHEN 2 THEN p_status_desc := 'Confirmed, processed, sent to shipping';
                WHEN 3 THEN p_status_desc := 'Shipped';
                WHEN 4 THEN p_status_desc := 'Cancelled';
                WHEN 5 THEN p_status_desc := 'Back-ordered';
                ELSE p_status_desc := 'Unknown status';
            END CASE;
            EXIT;
        END LOOP;
        CLOSE cur_status;
        END;
END STATUS_SP;
/
--test the procedure
DECLARE
    lv_basketid bb_basketstatus.idbasket%TYPE := 6;
    lv_status_desc VARCHAR2(100);
    lv_status_date bb_basketstatus.dtstage%TYPE;
BEGIN
    STATUS_SP(lv_basketid, lv_status_desc, lv_status_date);
    DBMS_OUTPUT.PUT_LINE(lv_status_date);
    DBMS_OUTPUT.PUT_LINE(lv_status_desc);
END;
/
/* Assignment 5-7
Brewbean’s wants to offer an incentive of free shipping to customers who haven’t returned to
the site since a specified date. Create a procedure named PROMO_SHIP_SP that determines
who these customers are and then updates the BB_PROMOLIST table accordingly. The
procedure uses the following information:
Date cutoff—Any customers who haven’t shopped on the site since this date
should be included as incentive participants. Use the basket creation date to
reflect shopper activity dates.
Month—A three-character month (such as APR) should be added to the promotion
table to indicate which month free shipping is effective.
Year—A four-digit year indicates the year the promotion is effective.
promo_flag—1 represents free shipping.

The BB_PROMOLIST table also has a USED column, which contains the default value N
and is updated to Y when the shopper uses the promotion. 
Test the procedure with the cutoff date 15-FEB-12. Assign free shipping for the month APR and the year 2012.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE
PROCEDURE PROMO_SHIP_SP
(p_cutoffDate IN bb_basket.dtcreated%TYPE,
 p_month IN bb_promolist.month%TYPE,
 p_year IN bb_promolist.year%TYPE,
 p_flag IN bb_promolist.promo_flag%TYPE)
 IS
 BEGIN
    DECLARE
        CURSOR cur_promo IS
            SELECT idshopper
            FROM bb_basket
            GROUP BY idshopper
            HAVING max(dtcreated) < p_cutoffDate;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Promo proc called');
        DBMS_OUTPUT.PUT_LINE('IDSHOPPER MONTH YEAR PROMO_FLAG USED');
        FOR rec_promo IN cur_promo LOOP
            INSERT INTO bb_promolist (idshopper, month, year, promo_flag, used)
                VALUES (rec_promo.idshopper, p_month, p_year, p_flag, 'N');
            DBMS_OUTPUT.PUT_LINE(rec_promo.idshopper || ' ' || p_month || ' ' || p_year || ' ' || p_flag || ' N');
        END LOOP;
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('No new promo entries to add');
    END;
END PROMO_SHIP_SP;
/
--test the procedure
DECLARE
    lv_cutoffDate bb_basket.dtcreated%TYPE := TO_DATE('15-FEB-12', 'DD-MON-YY');
    lv_month bb_promolist.month%TYPE := 'APR';
    lv_year bb_promolist.year%TYPE := '2012';
    lv_flag bb_promolist.promo_flag%TYPE := '1';
BEGIN
    PROMO_SHIP_SP(lv_cutoffDate, lv_month, lv_year, lv_flag);
END;
/

/* Assignment 5-8
As a shopper selects products on the Brewbean’s site, a procedure is needed to add a newly
selected item to the current shopper’s basket. Create a procedure named BASKET_ADD_SP that
accepts a product ID, basket ID, price, quantity, size code option (1 or 2), and form code option
(3 or 4) and uses this information to add a new item to the BB_BASKETITEM table. The table’s
PRIMARY KEY column is generated by BB_IDBASKETITEM_SEQ. Run the procedure with the
following values:

Basket ID—14
Product ID—8
Price—10.80
Quantity—1
Size code—2
Form code—4
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;


/* Assignment 5-9
The home page of the Brewbean’s Web site has an option for members to log on with their IDs
and passwords. Develop a procedure named MEMBER_CK_SP that accepts the ID and password
as inputs, checks whether they make up a valid logon, and returns the member name and cookie
value. The name should be returned as a single text string containing the first and last name.
The head developer wants the number of parameters minimized so that the same
parameter is used to accept the password and return the name value. Also, if the user doesn’t
enter a valid username and password, return the value INVALID in a parameter named
p_check. Test the procedure using a valid logon first, with the username rat55 and password
kile. Then try it with an invalid logon by changing the username to rat.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;