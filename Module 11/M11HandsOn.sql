/* Assignment 5-10
Create a procedure named DDPROJ_SP that retrieves project information for a specific project
based on a project ID. The procedure should have two parameters: one to accept a project ID
value and another to return all data for the specified project. Use a record variable to have the
procedure return all database column values for the selected project. Test the procedure with an
anonymous block.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE
PROCEDURE DDPROJ_SP
(p_id IN dd_project.idproj%TYPE,
 p_data OUT dd_project%ROWTYPE)
 IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('DDPROJ_SP proc called');
    SELECT *
    INTO p_data
    FROM dd_project
    WHERE idproj = p_id;
END;
/
DECLARE
    lv_proj_data dd_project%ROWTYPE;
BEGIN
    DDPROJ_SP(501, lv_proj_data);
    DBMS_OUTPUT.PUT_LINE('Project ID: ' || lv_proj_data.idproj);
    DBMS_OUTPUT.PUT_LINE('Project Name: ' || lv_proj_data.projname);
    DBMS_OUTPUT.PUT_LINE('Start Date: ' || TO_CHAR(lv_proj_data.projstartdate, 'MM/DD/YYYY'));
    DBMS_OUTPUT.PUT_LINE('End Date: ' || TO_CHAR(lv_proj_data.projenddate, 'MM/DD/YYYY'));
    DBMS_OUTPUT.PUT_LINE('Fundraising Goal: ' || lv_proj_data.projfundgoal);
    DBMS_OUTPUT.PUT_LINE('Project Coordinaror: ' || lv_proj_data.projcoord);
END;
/

/* Assignment 5-11
Create a procedure named DDPAY_SP that identifies whether a donor currently has an active pledge
with monthly payments. A donor ID is the input to the procedure. Using the donor ID, the procedure
needs to determine whether the donor has any currently active pledges based on the status field
and is on a monthly payment plan. If so, the procedure is to return the Boolean value TRUE.
Otherwise, the value FALSE should be returned. Test the procedure with an anonymous block.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE
PROCEDURE DDPAY_SP
(p_iddonor IN dd_pledge.iddonor%TYPE,
 p_status OUT BOOLEAN)
 IS
 lv_idstatus dd_pledge.idstatus%TYPE;
 lv_paymonths dd_pledge.paymonths%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('DDPAY_SP proc called');
    SELECT MAX(paymonths) -- highest monthly payment plan
    INTO lv_paymonths
    FROM dd_pledge
    WHERE iddonor = p_iddonor
    AND idstatus = 10;  -- active status
    IF lv_paymonths > 0 THEN
        p_status := TRUE;
    ELSE
        p_status := FALSE;
    END IF;
END;
/
DECLARE
    lv_donor_id dd_pledge.iddonor%TYPE := 304;
    lv_has_monthly_payments BOOLEAN;
BEGIN
    DDPAY_SP(lv_donor_id, lv_has_monthly_payments);
    DBMS_OUTPUT.PUT_LINE('Donor ID: ' || lv_donor_id );
    DBMS_OUTPUT.PUT_LINE('Has Monthly Payments: ');
    CASE lv_has_monthly_payments 
    WHEN TRUE THEN 
        DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('FALSE');
    END CASE;
END;
/

/* Assignment 5-12
Create a procedure named DDCKPAY_SP that confirms whether a monthly pledge payment is the
correct amount. The procedure needs to accept two values as input: a payment amount and a
pledge ID. Based on these inputs, the procedure should confirm that the payment is the correct
monthly increment amount, based on pledge data in the database. If it isn’t, a custom Oracle error
using error number -20050 and the message “Incorrect payment amount - planned payment = ??”
should be raised. The ?? should be replaced by the correct payment amount. The database
query in the procedure should be formulated so that no rows are returned if the pledge isn’t on
a monthly payment plan or the pledge isn’t found. If the query returns no rows, the procedure should
display the message “No payment information.” Test the procedure with the pledge ID 104 and the
payment amount $25. Then test with the same pledge ID but the payment amount $20. Finally, test
the procedure with a pledge ID for a pledge that doesn’t have monthly payments associated with it.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE
PROCEDURE DDCKPAY_SP
(p_payamt IN dd_pledge.pledgeamt%TYPE,
 p_pledgeid IN dd_pledge.idpledge%TYPE)
 IS
    lv_monthly_amt dd_pledge.pledgeamt%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('DDCKPAY_SP proc called');
    SELECT (pledgeamt / paymonths)
    INTO lv_monthly_amt
    FROM dd_pledge
    WHERE idpledge = p_pledgeid
    AND paymonths > 0;

    IF p_payamt > lv_monthly_amt THEN
        RAISE_APPLICATION_ERROR(-20050, 'Incorrect payment amount - planned payment = ' || lv_monthly_amt);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Payment amount ' || p_payamt || ' is correct for pledge ID ' || p_pledgeid);
    END IF;
    

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No payment information.');
END;
/
DECLARE
    lv_payment_amt dd_pledge.pledgeamt%TYPE := 25;
    lv_pledge_id dd_pledge.idpledge%TYPE := 104;
BEGIN
    DDCKPAY_SP(lv_payment_amt, lv_pledge_id);
END;
/