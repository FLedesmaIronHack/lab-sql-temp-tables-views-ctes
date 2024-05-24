--  Use sakila;
-- Select * from film_category; -- --> Film_ID and Category_ID
-- Select * from category; -- --> Category_ID
-- Select * from film; -- --> Film_ID,language_ID
-- Select * from country; -- --> Country_ID
-- Select * from City; -- --> City_ID, Country_ID
-- Select * from address; -- --> Addres_ID,City_ID 
-- Select * from payment; -- --> Paymnet_ID,Customer_ID,Staff_ID,Rental_ID
-- Select * from rental; -- -- Rental_ID,Inventory_ID,Customer_ID,Staff_ID
-- Select * from store; -- --> Store_ID, Manager_Staff_ID,addres_ID
-- Select * from customer; -- --> Customer_ID,Store_ID, Address_ID
-- Select * from staff; -- --> Staff_ID, Address_ID, Store_ID
-- Select * from inventory; -- --> inventory_id, Film_ID, Store_ID

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW vw_Customer_Rental_Summary AS
Select 
c.Customer_ID
, Concat(First_Name,' ',Last_Name) as Name
,email as Email_address
, Count(r.rental_ID) as Rental_Count
From rental r
inner join Customer c
	on r.customer_ID= c.Customer_ID
Group by Customer_ID,email;

Select * from vw_Customer_Rental_Summary;


-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE temp_Customer_Total_Pay_Summary AS
Select 
p.Customer_ID
,Sum(Amount) as Total_Paid
From vw_Customer_Rental_Summary crs
inner join payment p
on p.Customer_ID= crs.Customer_ID
Group by p.Customer_ID;

Select * from temp_Customer_Total_Pay_Summary;


-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH cte_Customer_Summary_Data (Name,Email_Address,Rental_Count,Total_paid_Amount) AS 
(
Select
 crs.name
,crs.Email_Address
,crs.rental_Count
,p.Total_Paid
from vw_Customer_Rental_Summary crs
inner Join temp_Customer_Total_Pay_Summary p
on crs.Customer_ID=p.Customer_ID
)
-- Select * from cte_Customer_Summary_Data

-- Next, using the CTE, create the query to generate the final customer summary report, which should include: 
-- customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
Select 
Name as Customer_Name
,email_address as Email
,Rental_Count
,Total_Paid_Amount
,Round(total_Paid_Amount/Rental_Count,2) as average_payment_per_rental
from cte_Customer_Summary_Data;