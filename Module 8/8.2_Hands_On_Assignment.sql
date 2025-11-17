/*Hands-On Assignments Part I

Assignment 2-1: Using Scalar Variables
Create a PL/SQL block containing the following variables:
Name Data Type Option Initial Value
lv_test_date DATE December 10, 2012
lv_test_num NUMBER(3) CONSTANT 10
lv_test_txt VARCHAR2(10)
Assign your last name as the value of the text variable in the executable section of the
block. Include statements in the block to display each variable’s value onscreen.*/
/*Assignment 2-2: Creating a Flowchart
The Brewbean’s application needs a block that determines whether a customer is rated high,
mid, or low based on his or her total purchases. The block needs to determine the rating and
then display the results onscreen. The code rates the customer high if total purchases are
greater than $200, mid if greater than $100, and low if $100 or lower. Develop a flowchart to
outline the conditional processing steps needed for this block.*/
/*Assignment 2-3: Using IF Statements
Create a block using an IF statement to perform the actions described in Assignment 2-2. Use
a scalar variable for the total purchase amount, and initialize this variable to different values to
test your block.*/
/*Assignment 2-4: Using CASE Statements
Create a block using a CASE statement to perform the actions described in Assignment 2-2. Use
a scalar variable for the total purchase amount, and initialize this variable to different values to
test your block.*/
/*Assignment 2-5: Using a Boolean Variable
Brewbean’s needs program code to indicate whether an amount is still due on an account when
a payment is received. Create a PL/SQL block using a Boolean variable to indicate whether an
amount is still due. Declare and initialize two variables to provide input for the account balance
and the payment amount received. A TRUE Boolean value should indicate an amount is still
owed, and a FALSE value should indicate the account is paid in full. Use output statements to
confirm that the Boolean variable is working correctly.*/
Assignment 2-6: Using Looping Statements
Create a block using a loop that determines the number of items that can be purchased based
on the item prices and the total available to spend. Include one initialized variable to represent
the price and another to represent the total available to spend. (You could solve it with division,
but you need to practice using loop structures.) The block should include statements to display
the total number of items that can be purchased and the total amount spent.
Assignment 2-7: Creating a Flowchart
Brewbean’s determines shipping costs based on the number of items ordered and club
membership status. The applicable rates are shown in the following chart. Develop a flowchart
to outline the condition-processing steps needed to handle this calculation.
Quantity of Items Nonmember Shipping Cost Member Shipping Cost
Up to 3 $5.00 $3.00
4–6 $7.50 $5.00
7–10 $10.00 $7.00
More than 10 $12.00 $9.00
Assignment 2-8: Using IF Statements
Create a block to accomplish the task outlined in Assignment 2-7. Include a variable containing
a Y or N to indicate membership status and a variable to represent the number of items
purchased. Test with a variety of values.
Hands-On Assignments Part II
Assignment 2-9: Using a FOR Loop
Create a PL/SQL block using a FOR loop to generate a payment schedule for a donor’s pledge,
which is to be paid monthly in equal increments. Values available for the block are starting
payment due date, monthly payment amount, and number of total monthly payments for the
pledge. The list that’s generated should display a line for each monthly payment showing
payment number, date due, payment amount, and donation balance (remaining amount of
pledge owed).
Assignment 2-10: Using a Basic Loop
Accomplish the task in Assignment 2-9 by using a basic loop structure.
Assignment 2-11: Using a WHILE Loop
Accomplish the task in Assignment 2-9 by using a WHILE loop structure. Instead of displaying
the donation balance (remaining amount of pledge owed) on each line of output, display the
total paid to date.
Assignment 2-12: Using a CASE Expression
Donors can select one of three payment plans for a pledge indicated by the following codes:
0 = one-time (lump sum) payment, 1 = monthly payments over one year, and 2 = monthly
payments over two years. A local business has agreed to pay matching amounts on pledge
83
Basic PL/SQL Block Structures
Copyright 2013 Cengage Learning. All Rights Reserved. May not be copied, scanned, or duplicated, in whole or in part. Due to electronic rights, some third party content may be suppressed from the eBook and/or eChapter(s).
Editorial review has deemed that any suppressed content does not materially affect the overall learning experience. Cengage Learning reserves the right to remove additional content at any time if subsequent rights restrictions require it.
payments during the current month. A PL/SQL block is needed to identify the matching
amount for a pledge payment. Create a block using input values of a payment plan code
and a payment amount. Use a CASE expression to calculate the matching amount, based on
the payment plan codes 0 = 25%, 1 = 50%, 2 = 100%, and other = 0. Display the
calculated amount.
Assignment 2-13: Using Nested IF Statements
An organization has committed to matching pledge amounts based on the donor type and
pledge amount. Donor types include I = Individual, B = Business organization, and G = Grant
funds. The matching percents are to be applied as follows:
Donor Type Pledge Amount Matching %
I $100–$249 50%
I $250–$499 30%
I $500 or more 20%
B $100–$499 20%
B $500–$999 10%
B $1,000 or more 5%
G $100 or more 5%
Create a PL/SQL block using nested IF statements to accomplish the task. Input values for
the block are the donor type code and the pledge amount