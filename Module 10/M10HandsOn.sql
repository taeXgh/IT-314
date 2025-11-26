/* Assignment 4-9
Create a block to retrieve and display pledge and payment information for a specific donor. For
each pledge payment from the donor, display the pledge ID, pledge amount, number of monthly
payments, payment date, and payment amount. The list should be sorted by pledge ID and then
by payment date. For the first payment made for each pledge, display “first payment” on that
output row.*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

DECLARE
    CURSOR cur_pledge IS
        SELECT IDPLEDGE, PLEDGEAMT, PAYMONTHS, PAYAMT, PAYDATE
        FROM dd_pledge INNER JOIN dd_payment
            USING (IDPLEDGE)
        WHERE IDDONOR = 308
        ORDER BY IDPLEDGE, PAYDATE;
   TYPE type_pledge IS RECORD (
     pledge dd_pledge.IDPLEDGE%TYPE,
     amt dd_pledge.PLEDGEAMT%TYPE,
     monthly dd_pledge.PAYMONTHS%TYPE,
     amount dd_payment.PAYAMT%TYPE,
     dtpaid dd_payment.PAYDATE%TYPE);
   rec_pledge type_pledge;
   lv_first_flag dd_pledge.IDPLEDGE%TYPE := -1; 
BEGIN
    DBMS_OUTPUT.PUT_LINE('PledgeID Amt Months PayDate PayAmt');
    OPEN cur_pledge;
    LOOP 
        FETCH cur_pledge INTO rec_pledge;
        EXIT WHEN cur_pledge%NOTFOUND;
        IF rec_pledge.pledge != lv_first_flag THEN
            DBMS_OUTPUT.PUT_LINE(rec_pledge.pledge || ' ' || rec_pledge.amt || ' ' ||
                rec_pledge.monthly || ' ' || TO_CHAR(rec_pledge.dtpaid, 'MON-DD-YYYY') || ' ' ||
                rec_pledge.amount || ' First payment');
            lv_first_flag := rec_pledge.pledge;
        ELSE
            DBMS_OUTPUT.PUT_LINE(rec_pledge.pledge || ' ' || rec_pledge.amt || ' ' ||
                rec_pledge.monthly || ' ' || TO_CHAR(rec_pledge.dtpaid, 'MON-DD-YYYY') || ' ' ||
                rec_pledge.amount);
        END IF;
   END LOOP;
   CLOSE cur_pledge;
END;
/

/* Assignment 3-10
Redo Assignment 4-9, but use a different cursor form to perform the same task*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

