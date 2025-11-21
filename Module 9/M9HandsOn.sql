/* Assignment 3-9
Create a PL/SQL block that retrieves and displays information for a specific project based on
Project ID. Display the following on a single row of output: project ID, project name, number of
pledges made, total dollars pledged, and the average pledge amount.*/
SELECT sysdate, 'Thalia Edwards' FROM dual;
DECLARE
    
BEGIN

END;
/

/* Assignment 3-10
Create a PL/SQL block to handle adding a new project. Create and use a sequence named
DD_PROJID_SEQ to handle generating and populating the project ID. The first number issued
by this sequence should be 530, and no caching should be used. Use a record variable to
handle the data to be added. Data for the new row should be the following: project name = HK
Animal Shelter Extension, start = 1/1/2013, end = 5/31/2013, and fundraising goal = $65,000.
Any columns not addressed in the data list are currently unknown.*/


/* Assignment 3-11: Retrieving and Displaying Pledge Data
Create a PL/SQL block to retrieve and display data for all pledges made in a specified month.
One row of output should be displayed for each pledge.
*/