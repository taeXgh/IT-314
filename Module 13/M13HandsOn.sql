/* Assignment 3-9
Create a PL/SQL block that retrieves and displays information for a specific project based on
Project ID. Display the following on a single row of output: project ID, project name, number of
pledges made, total dollars pledged, and the average pledge amount.*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
DECLARE
    TYPE type_project IS RECORD(
        project dd_project.idproj%TYPE,
        name dd_project.projname%TYPE,
        num_pledges NUMBER(3),
        total_pledged NUMBER(7,2),
        avg_pledge NUMBER(7,2)
    );
    rec_project type_project;
    lv_proj_num dd_project.idproj%TYPE := 500;

BEGIN
    SELECT idproj, projname, COUNT(idpledge), SUM(pledgeamt), AVG(pledgeamt)
    INTO rec_project
    FROM dd_project
    INNER JOIN dd_pledge
        USING (idproj)
    WHERE idproj = lv_proj_num
    GROUP BY idproj, projname;
    DBMS_OUTPUT.PUT_LINE('ProjectID ProjectName NumPledges TotalPledged AvgPledge');
    DBMS_OUTPUT.PUT_LINE(rec_project.project || ' ' || 
                         rec_project.name || ' ' || 
                         rec_project.num_pledges || ' ' || 
                         rec_project.total_pledged || ' ' || 
                         rec_project.avg_pledge);

END;
/


DROP TABLE dd_project CASCADE CONSTRAINTS;
CREATE TABLE DD_Project (
                   idProj number(6),
                   Projname varchar2(60),
                   Projstartdate DATE,
                   Projenddate DATE,
                   Projfundgoal number(12,2),
                   ProjCoord varchar2(20),
                   CONSTRAINT project_id_pk PRIMARY KEY(idProj),
                   CONSTRAINT project_name_uk  UNIQUE (Projname)  );  
INSERT INTO dd_project
  VALUES (500,'Elders Assistance League', '01-SEP-2012','31-OCT-2012',15000,'Shawn Hasee');
INSERT INTO dd_project
  VALUES (501,'Community food pantry #21 freezer equipment', '01-OCT-2012','31-DEC-2012',65000,'Shawn Hasee');
INSERT INTO dd_project
  VALUES (502,'Lang Scholarship Fund', '01-JAN-2013','01-NOV-2013',100000,'Traci Brown');
INSERT INTO dd_project
  VALUES (503,'Animal shelter Vet Connect Program', '01-DEC-2012','30-MAR-2013',25000,'Traci Brown');
INSERT INTO dd_project
  VALUES (504,'Shelter Share Project 2013', '01-FEB-2013','31-JUL-2013',35000,'Traci Brown');
drop SEQUENCE DD_PROJID_SEQ;
COMMIT;

/* Assignment 3-10
Create a PL/SQL block to handle adding a new project. Create and use a sequence named
DD_PROJID_SEQ to handle generating and populating the project ID. The first number issued
by this sequence should be 530, and no caching should be used. 
Use a record variable to handle the data to be added. 
Data for the new row should be the following: 
project name = HK Animal Shelter Extension, start = 1/1/2013, end = 5/31/2013, and fundraising goal = $65,000.
Any columns not addressed in the data list are currently unknown.*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

CREATE SEQUENCE DD_PROJID_SEQ
        INCREMENT BY 1
        START WITH 530
        NOCACHE;
DECLARE
    TYPE type_project IS RECORD(
        project dd_project.idproj%TYPE,
        name dd_project.projname%TYPE,
        startdt dd_project.projstartdate%TYPE,
        enddt dd_project.projenddate%TYPE,
        fundgoal dd_project.projfundgoal%TYPE
    );
    rec_project type_project;
    
BEGIN
    rec_project.project := DD_PROJID_SEQ.NEXTVAL;
    rec_project.name := 'HK Animal Shelter Extension';
    rec_project.startdt := TO_DATE('01-JAN-2013', 'DD-MON-YYYY');
    rec_project.enddt := TO_DATE('31-MAY-2013', 'DD-MON-YYYY');
    rec_project.fundgoal := 65000;

    INSERT INTO DD_PROJECT (idproj, projname, projstartdate, projenddate, projfundgoal)
    VALUES (rec_project.project, 
    rec_project.name, 
    rec_project.startdt, 
    rec_project.enddt, 
    rec_project.fundgoal);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE(rec_project.project || ' | ' || rec_project.name || ' | ' ||
        TO_CHAR(rec_project.startdt, 'MM/DD/YYYY') || ' | ' || TO_CHAR(rec_project.enddt, 'MM/DD/YYYY') || ' | ' || rec_project.fundgoal);
END;
/

/* Assignment 3-11
Create a PL/SQL block to retrieve and display data for all pledges made in a specified month.
One row of output should be displayed for each pledge.
Include the following in each row of output:
Pledge ID, donor ID, and pledge amount
If the pledge is being paid in a lump sum, display “Lump Sum.”
If the pledge is being paid in monthly payments, display “Monthly - #” (with the #
representing the number of months for payment).
The list should be sorted to display all lump sum pledges first.
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
DECLARE
    TYPE type_pledge IS TABLE OF dd_pledge%ROWTYPE
        INDEX BY PLS_INTEGER;
    tbl_pledge type_pledge;
BEGIN
    SELECT * BULK COLLECT INTO tbl_pledge
    FROM dd_pledge
    WHERE TO_CHAR(pledgedate, 'MM') = '09'
    ORDER BY paymonths;
    FOR i IN 1..tbl_pledge.COUNT LOOP
    CASE
        WHEN tbl_pledge(i).paymonths = 0 THEN
            DBMS_OUTPUT.PUT_LINE('PledgeID: ' || tbl_pledge(i).idpledge || 
            ' | DonorID: ' || tbl_pledge(i).iddonor || 
            ' | PledgeAmount: ' || tbl_pledge(i).pledgeamt || 
            ' | PaymentType: Lump Sum');
        ELSE
            DBMS_OUTPUT.PUT_LINE('PledgeID: ' || tbl_pledge(i).idpledge || 
            ' | DonorID: ' || tbl_pledge(i).iddonor || 
            ' | PledgeAmount: ' || tbl_pledge(i).pledgeamt || 
            ' | PaymentType: Monthly - ' || tbl_pledge(i).paymonths);
    END CASE;
    END LOOP;
END;
/ 
