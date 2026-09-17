/* =========================================================
   SQL FILTERING PRACTICE
   Database: SalesDB
   ========================================================= */


/* ---------------------------------------------------------
   1. Display employees with salary greater than 60000
   --------------------------------------------------------- */

SELECT *
FROM Employees
WHERE Salary > 60000;


/* ---------------------------------------------------------
   2. Find customers whose last name is NULL
   --------------------------------------------------------- */

SELECT *
FROM Customers
WHERE LastName IS NULL;


/* ---------------------------------------------------------
   3. Display the top 5 highest-paid employees
   TOP + ORDER BY
   --------------------------------------------------------- */

SELECT TOP 5 *
FROM Employees
ORDER BY Salary DESC;


/* ---------------------------------------------------------
   4. Find customers whose first name starts with 'M'
   LIKE operator
   --------------------------------------------------------- */

SELECT *
FROM Customers
WHERE FirstName LIKE 'M%';


/* ---------------------------------------------------------
   5. Show sales/orders placed during February
   MONTH() function + WHERE
   --------------------------------------------------------- */

SELECT *
FROM Orders
WHERE MONTH(OrderDate) = 2;
