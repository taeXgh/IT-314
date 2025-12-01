/* Assignment 6-9
Create a function named DD_MTHPAY_SF that 
1. calculates the monthly payment amount for donor pledges paid on a monthly basis -- body
2. returns the monthly payment amount for donor pledges paid on a monthly basis. -- return
Input values should be 
1. the number of monthly payments -- IN
2. the pledge amount. -- IN
------------------------------------testing----------------------------------------------------------
1. Use the function in an anonymous PL/SQL block to show its use with the following pledge information: 
pledge amount = $240
monthly payments = 12. 
2. Use the function in an SQL statement that displays information for all donor pledges in the database on a monthly payment plan.
*/
/* --brainstorming
select idpledge, paymonths, pledgeamt, pledgeamt / paymonths as monthlypayment
from dd_pledge
where paymonths = 12
and pledgeamt = 240; */
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE FUNCTION dd_mthpay_sf
(p_paymths IN dd_pledge.paymonths%TYPE,
 p_pledgeamt IN dd_pledge.pledgeamt%TYPE)
RETURN NUMBER
IS
    lv_paymonths dd_pledge.paymonths%TYPE;
    lv_pledgeamt dd_pledge.pledgeamt%TYPE;
    lv_mthpayamt NUMBER(10,2);
    CURSOR cur_pledge IS
        SELECT p_paymths, p_pledgeamt
        FROM dd_pledge
        WHERE p_paymths = paymonths
        AND p_pledgeamt = pledgeamt
        AND paymonths > 0;
BEGIN
    FOR rec_pledge IN cur_pledge LOOP
        lv_paymonths := rec_pledge.p_paymths;
        lv_pledgeamt := rec_pledge.p_pledgeamt;
    END LOOP;
    lv_mthpayamt := lv_pledgeamt / lv_paymonths;
    RETURN lv_mthpayamt;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No monthly payment plan found.');
        RETURN 0;
END;
/
--test the function
--test 1: anonymous block
DECLARE
    lv_monthlyPayment NUMBER(10,2);
BEGIN
    lv_monthlyPayment := dd_mthpay_sf(12, 240);
    DBMS_OUTPUT.PUT_LINE('Monthly Payment: '||lv_monthlyPayment || '/month');
END;
/
--test 2: sql statement
SELECT idpledge, paymonths, pledgeamt,
       dd_mthpay_sf(paymonths, pledgeamt) AS monthly_payment
FROM dd_pledge
WHERE paymonths > 0;

/* Assignment 6-10
Create a function named DD_PROJTOT_SF that 
1. determines the total pledge amount for a project. --body
-------------------------------------testing--------------------------------------------------------
Use the function in an SQL statement that lists all projects, displaying project ID, project name,
and project pledge total amount. 
----------------------------------------------------------------------------------------------------
1. Format the pledge total to display zero if no pledges have been made so far, -- return
2. Show a dollar sign, comma, and two decimal places for dollar values. -- return
*/
--brainstorming
--to_char(n, '$9999.99')
select p.idproj, projname, nvl(sum(pledgeamt), 0) AS total_pledge
        from dd_pledge p, dd_project pr
        where p.idproj(+) = pr.idproj
        group by p.idproj, projname
        order by p.idproj;

SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE FUNCTION dd_projtot_sf
(p_id IN dd_pledge.idproj%TYPE)
RETURN VARCHAR2
IS
    lv_totalpledge NUMBER(10,2);
BEGIN
    SELECT NVL(SUM(pledgeamt), 0)
    INTO lv_totalpledge
    FROM dd_pledge
    WHERE idproj = p_id;
    IF lv_totalpledge < 1 THEN
        RETURN '$' || TO_CHAR(lv_totalpledge, '0.00');
    ELSE
        RETURN TO_CHAR(lv_totalpledge, '$999,999.99');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '$'||'0.00';
END dd_projtot_sf;
/
--test the function
SELECT idproj, projname, dd_projtot_sf(idproj) AS project_pledge_total
FROM dd_project 
ORDER BY idproj;

/* Assignment 6-11
The DoGood Donor organization decided to reduce SQL join activity in its application by
eliminating the DD_STATUS table and replacing it with a function that 
returns a status description --return
based on the status ID value. --IN
Create this function and name it DD_PLSTAT_SF. 
-------------------------------------testing--------------------------------------------------------
1. Use the function in an SQL statement that displays the pledge ID, pledge date, and pledge status for all pledges.
2. Also, use it in an SQL statement that displays the same values but for only a specified pledge.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE OR REPLACE FUNCTION dd_plstat_sf
(p_idstatus IN dd_pledge.idstatus%TYPE)
RETURN VARCHAR2
IS
BEGIN
    CASE
        WHEN p_idstatus = 10 THEN
            RETURN 'Open';
        WHEN p_idstatus = 20 THEN
            RETURN 'Complete';
        WHEN p_idstatus = 30 THEN
            RETURN 'Overdue';
        WHEN p_idstatus = 40 THEN
            RETURN 'Closed';
        WHEN p_idstatus = 50 THEN
            RETURN 'Hold';
        ELSE
            RETURN 'Unknown Status';
    END CASE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Unknown Status';
END dd_plstat_sf;
/
--test the function
--test 1: all pledges
SELECT IDPLEDGE, PLEDGEDATE, dd_plstat_sf(IDSTATUS) AS pledge_status
FROM dd_pledge;
--test 2: specified pledge
SELECT IDPLEDGE, PLEDGEDATE, dd_plstat_sf(IDSTATUS) AS pledge_status
FROM dd_pledge
WHERE IDPLEDGE = 108;