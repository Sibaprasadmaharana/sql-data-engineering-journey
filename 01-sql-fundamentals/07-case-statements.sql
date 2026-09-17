/* =========================================================
   SQL CASE STATEMENTS PRACTICE
   Database: SalesDB
   ========================================================= */


/* ---------------------------------------------------------
   1. Categorize each order based on sales amount

   High   = Sales > 50
   Medium = Sales 21 - 50
   Low    = Sales <= 20
   --------------------------------------------------------- */

SELECT
    OrderID,
    Sales,
    CASE
        WHEN Sales > 50 THEN 'High'
        WHEN Sales > 20 THEN 'Medium'
        ELSE 'Low'
    END AS SalesCategory
FROM Orders;


/* ---------------------------------------------------------
   2. Show total sales for each sales category

   CASE + SUM() + GROUP BY
   --------------------------------------------------------- */

SELECT
    SalesCategory,
    SUM(Sales) AS TotalSales
FROM
(
    SELECT
        OrderID,
        Sales,
        CASE
            WHEN Sales > 50 THEN 'High'
            WHEN Sales > 20 THEN 'Medium'
            ELSE 'Low'
        END AS SalesCategory
    FROM Orders
) AS A
GROUP BY SalesCategory
ORDER BY TotalSales DESC;


/* ---------------------------------------------------------
   3. Categorize employees based on salary

   High     = Salary >= 80000
   Medium   = Salary >= 60000
   Low      = Salary < 60000
   --------------------------------------------------------- */

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    CASE
        WHEN Salary >= 80000 THEN 'High'
        WHEN Salary >= 60000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory
FROM Employees;


/* ---------------------------------------------------------
   4. Identify customers based on their score

   High   = Score >= 80
   Medium = Score >= 50
   Low    = Score < 50
   Unknown = NULL
   --------------------------------------------------------- */

SELECT
    CustomerID,
    FirstName,
    LastName,
    Score,
    CASE
        WHEN Score IS NULL THEN 'Unknown'
        WHEN Score >= 80 THEN 'High'
        WHEN Score >= 50 THEN 'Medium'
        ELSE 'Low'
    END AS ScoreCategory
FROM Customers;
