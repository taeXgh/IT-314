/* Assignment 7-9
Create a package named PLEDGE_PKG that includes two functions for determining dates of
pledge payments. Use or create the functions described in Chapter 6 for Assignments 6-12 and
6-13, using the names DD_PAYDATE1_PF and DD_PAYEND_PF for these packaged functions.
Test both functions with a specific pledge ID, using an anonymous block. Then test both
functions in a single query showing all pledges and associated payment dates.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE PACKAGE PLEDGE_PKG IS
    FUNCTION DD_PAYDATE1_PF 
    (p_pledge_id IN NUMBER) 
    RETURN DATE;
    FUNCTION DD_PAYEND_PF 
    (p_pledge_id IN NUMBER) 
    RETURN DATE;
END PLEDGE_PKG;
/
CREATE OR REPLACE PACKAGE BODY PLEDGE_PKG IS
    FUNCTION DD_PAYDATE1_PF 
    (p_pledge_id IN NUMBER) 
    RETURN DATE IS
        lv_pl_dat DATE;
        lv_mth_txt VARCHAR2(2);
        lv_yr_txt VARCHAR2(4);
    BEGIN
        SELECT ADD_MONTHS(pledgedate,1)
            INTO lv_pl_dat
            FROM dd_pledge
            WHERE idpledge = p_pledge_id;
        lv_mth_txt := TO_CHAR(lv_pl_dat,'mm');
        lv_yr_txt := TO_CHAR(lv_pl_dat,'yyyy');
        RETURN TO_DATE((lv_mth_txt || '-01-' || lv_yr_txt),'mm-dd-yyyy');
    END DD_PAYDATE1_PF;

    FUNCTION DD_PAYEND_PF 
    (p_pledge_id IN NUMBER) 
    RETURN DATE IS
        lv_pay1_dat DATE;
        lv_mths_num dd_pledge.paymonths%TYPE;
    BEGIN
        SELECT DD_PAYDATE1_PF(p_pledge_id), paymonths - 1
            INTO lv_pay1_dat, lv_mths_num
            FROM dd_pledge
            WHERE idpledge = p_pledge_id;
        IF lv_mths_num = 0 THEN
             RETURN lv_pay1_dat;
        ELSE
             RETURN ADD_MONTHS(lv_pay1_dat, lv_mths_num);
        END IF;
    END DD_PAYEND_PF;
END;
/
--test both functions with a specific pledge ID, using an anonymous block
DECLARE
    lv_pledge_id dd_pledge.idpledge%TYPE := 105;
BEGIN
    DBMS_OUTPUT.PUT_LINE('First Payment Due Date: ' || 
    TO_CHAR(PLEDGE_PKG.DD_PAYDATE1_PF(lv_pledge_id), 'MM-DD-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Final Payment Due Date: ' || 
    TO_CHAR(PLEDGE_PKG.DD_PAYEND_PF(lv_pledge_id), 'MM-DD-YYYY'));
END;
/
--test both functions in a single query showing all pledges and associated payment dates
SELECT idpledge,
       TO_CHAR(PLEDGE_PKG.DD_PAYDATE1_PF(idpledge), 'MON-DD-YYYY') AS first_payment_due_date,
       TO_CHAR(PLEDGE_PKG.DD_PAYEND_PF(idpledge), 'MON-DD-YYYY') AS final_payment_due_date
FROM dd_pledge;

/* Assignment 7-10
Modify the package created in Assignment 7-9 as follows:
• Add a procedure named DD_PLIST_PP that displays the donor name and all
associated pledges (including pledge ID, first payment due date, and last payment
due date). A donor ID is the input value for the procedure.
• Make the procedure public and the two functions private.
Test the procedure with an anonymous block.*/
drop package pledge_pkg;
/

SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE PACKAGE PLEDGE_PKG IS
    PROCEDURE dd_plist_pp
    (p_donor_id IN dd_donor.iddonor%TYPE);
END;
/
CREATE OR REPLACE PACKAGE BODY PLEDGE_PKG IS
    FUNCTION DD_PAYDATE1_PF 
    (p_pledge_id IN NUMBER) 
    RETURN DATE
    IS
        lv_pl_dat DATE;
        lv_mth_txt VARCHAR2(2);
        lv_yr_txt VARCHAR2(4);
    BEGIN
        SELECT ADD_MONTHS(pledgedate,1)
            INTO lv_pl_dat
            FROM dd_pledge
            WHERE idpledge = p_pledge_id;
        lv_mth_txt := TO_CHAR(lv_pl_dat,'mm');
        lv_yr_txt := TO_CHAR(lv_pl_dat,'yyyy');
        RETURN TO_DATE((lv_mth_txt || '-01-' || lv_yr_txt),'mm-dd-yyyy');
    END DD_PAYDATE1_PF;

    FUNCTION DD_PAYEND_PF 
    (p_pledge_id IN NUMBER) 
    RETURN DATE 
    IS
        lv_pay1_dat DATE;
        lv_mths_num dd_pledge.paymonths%TYPE;
        lv_func_result DATE;
    BEGIN
        lv_func_result := DD_PAYDATE1_PF(p_pledge_id);
        SELECT lv_func_result, paymonths - 1
            INTO lv_pay1_dat, lv_mths_num
            FROM dd_pledge
            WHERE idpledge = p_pledge_id;
        IF lv_mths_num = 0 THEN
             RETURN lv_pay1_dat;
        ELSE
             RETURN ADD_MONTHS(lv_pay1_dat, lv_mths_num);
        END IF;
    END DD_PAYEND_PF;

    PROCEDURE dd_plist_pp
    (p_donor_id IN dd_donor.iddonor%TYPE) 
    IS
        lv_donor_name VARCHAR2(50);
        lv_pledge_count NUMBER;
        CURSOR cur_pledge IS
            SELECT idpledge
            FROM dd_pledge
            WHERE iddonor = p_donor_id;
    BEGIN
        SELECT firstname || ' ' || lastname
        INTO lv_donor_name
        FROM dd_donor
        WHERE iddonor = p_donor_id;
        
        SELECT COUNT(*)
        INTO lv_pledge_count
        FROM dd_pledge
        WHERE iddonor = p_donor_id;

        DBMS_OUTPUT.PUT_LINE('Donor: ' || lv_donor_name);
        IF lv_pledge_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No pledges found for this donor.');
        END IF;

        FOR rec_pledge IN cur_pledge LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Pledge ID: ' || rec_pledge.idpledge || 
                ' | First Payment: ' || TO_CHAR(DD_PAYDATE1_PF(rec_pledge.idpledge), 'MM-DD-YYYY') ||
                ' | Last Payment: ' || TO_CHAR(DD_PAYEND_PF(rec_pledge.idpledge), 'MM-DD-YYYY')
            );
        END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No donor found with that ID.');
    END dd_plist_pp;
END pledge_pkg;
/
--test the procedure with an anonymous block
DECLARE
    lv_donor_id dd_donor.iddonor%TYPE := 305;
BEGIN
    PLEDGE_PKG.dd_plist_pp(lv_donor_id);
END;
/

/* Assignment 7-11
Modify the package created in Assignment 7-10 as follows:
• Add a new procedure named DD_PAYS_PP that retrieves donor pledge payment
information and returns all the required data via a single parameter.
• A donor ID is the input for the procedure.
• The procedure should retrieve the donor’s last name and each pledge payment
made so far (including payment amount and payment date).
• Make the procedure public.
Test the procedure with an anonymous block. The procedure call must handle the data
being returned by means of a single parameter in the procedure. For each pledge payment,
make sure the pledge ID, donor’s last name, pledge payment amount, and pledge payment
date are displayed.
*/
drop package pledge_pkg;
/

/* procedure brainstorming
 SELECT lastname, PAYAMT, PAYDATE
FROM dd_donor INNER JOIN dd_pledge
USING (iddonor)
INNER JOIN dd_payment
USING (idpledge)
WHERE iddonor = 303
ORDER BY idpledge, PAYDATE; */

SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE PACKAGE PLEDGE_PKG IS
    PROCEDURE dd_plist_pp
    (p_donor_id IN dd_donor.iddonor%TYPE);
    PROCEDURE dd_pays_pp
    (p_donor_id IN dd_donor.iddonor%TYPE);
END;
/
CREATE OR REPLACE PACKAGE BODY PLEDGE_PKG IS
    FUNCTION DD_PAYDATE1_PF 
    (p_pledge_id IN NUMBER) 
    RETURN DATE
    IS
        lv_pl_dat DATE;
        lv_mth_txt VARCHAR2(2);
        lv_yr_txt VARCHAR2(4);
    BEGIN
        SELECT ADD_MONTHS(pledgedate,1)
            INTO lv_pl_dat
            FROM dd_pledge
            WHERE idpledge = p_pledge_id;
        lv_mth_txt := TO_CHAR(lv_pl_dat,'mm');
        lv_yr_txt := TO_CHAR(lv_pl_dat,'yyyy');
        RETURN TO_DATE((lv_mth_txt || '-01-' || lv_yr_txt),'mm-dd-yyyy');
    END DD_PAYDATE1_PF;

    FUNCTION DD_PAYEND_PF 
    (p_pledge_id IN NUMBER) 
    RETURN DATE 
    IS
        lv_pay1_dat DATE;
        lv_mths_num dd_pledge.paymonths%TYPE;
        lv_func_result DATE;
    BEGIN
        lv_func_result := DD_PAYDATE1_PF(p_pledge_id);
        SELECT lv_func_result, paymonths - 1
            INTO lv_pay1_dat, lv_mths_num
            FROM dd_pledge
            WHERE idpledge = p_pledge_id;
        IF lv_mths_num = 0 THEN
             RETURN lv_pay1_dat;
        ELSE
             RETURN ADD_MONTHS(lv_pay1_dat, lv_mths_num);
        END IF;
    END DD_PAYEND_PF;

    PROCEDURE dd_plist_pp
    (p_donor_id IN dd_donor.iddonor%TYPE) 
    IS
        lv_donor_name VARCHAR2(50);
        lv_pledge_count NUMBER;
        CURSOR cur_pledge IS
            SELECT idpledge
            FROM dd_pledge
            WHERE iddonor = p_donor_id;
    BEGIN
        SELECT firstname || ' ' || lastname
        INTO lv_donor_name
        FROM dd_donor
        WHERE iddonor = p_donor_id;
        
        SELECT COUNT(*)
        INTO lv_pledge_count
        FROM dd_pledge
        WHERE iddonor = p_donor_id;

        DBMS_OUTPUT.PUT_LINE('Donor: ' || lv_donor_name);
        IF lv_pledge_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No pledges found for this donor.');
        END IF;

        FOR rec_pledge IN cur_pledge LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Pledge ID: ' || rec_pledge.idpledge || 
                ' | First Payment: ' || TO_CHAR(DD_PAYDATE1_PF(rec_pledge.idpledge), 'MM-DD-YYYY') ||
                ' | Last Payment: ' || TO_CHAR(DD_PAYEND_PF(rec_pledge.idpledge), 'MM-DD-YYYY')
            );
        END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No donor found with that ID.');
    END dd_plist_pp;
    PROCEDURE dd_pays_pp
    (p_donor_id IN dd_donor.iddonor%TYPE)
    IS
        lv_pledge_count NUMBER;
        CURSOR cur_payment IS
            SELECT lastname, PAYAMT, PAYDATE
            FROM dd_donor INNER JOIN dd_pledge
            USING (iddonor)
            INNER JOIN dd_payment
            USING (idpledge)
            WHERE iddonor = p_donor_id
            ORDER BY idpledge, PAYDATE;
    BEGIN
        SELECT COUNT(*)
        INTO lv_pledge_count
        FROM dd_pledge
        WHERE iddonor = p_donor_id;

        IF lv_pledge_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No payments found for this donor.');
        END IF;

        FOR rec_payment IN cur_payment LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Last Name: ' || rec_payment.lastname ||
                ' | Payment Amount: ' || rec_payment.PAYAMT ||
                ' | Payment Date: ' || TO_CHAR(rec_payment.PAYDATE, 'MON-DD-YYYY')
            );
        END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No payments found for this donor.');
    END dd_pays_pp;
END pledge_pkg;
/
--test the procedure with an anonymous block
DECLARE
    lv_donor_id dd_donor.iddonor%TYPE := 301;
BEGIN
    PLEDGE_PKG.dd_pays_pp(lv_donor_id);
END;
/

/* Assignment 9-9
The DoGood Donor organization wants to track all pledge payment activity. Each time a pledge
payment is added, changed, or removed, the following information should be captured in a
separate table: username (logon), current date, action taken (INSERT, UPDATE, or DELETE),
and the idpay value for the payment record. Create a table named DD_PAYTRACK to hold
this information. Include a primary key column to be populated by a sequence, and create a
new sequence named DD_PTRACK_SEQ for the primary key column. Create a single trigger for
recording the requested information to track pledge payment activity, and test the trigger.*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

