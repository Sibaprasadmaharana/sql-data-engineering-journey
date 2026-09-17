/* =========================================================
   SQL STRING FUNCTIONS PRACTICE
   Database: SalesDB
   ========================================================= */


/* ---------------------------------------------------------
   1. Show customer first name and country together
   CONCAT()
   --------------------------------------------------------- */

SELECT
    FirstName,
    Country,
    CONCAT(FirstName, '-', Country) AS Name_Country
FROM Customers;


/* ---------------------------------------------------------
   2. Retrieve customer first names after removing
      the first character
   SUBSTRING() + LEN()
   --------------------------------------------------------- */

SELECT
    FirstName,
    SUBSTRING(FirstName, 2, LEN(FirstName)) AS Sub_Name
FROM Customers;


/* ---------------------------------------------------------
   3. Find customers whose first name starts with 'M'
   LIKE operator
   --------------------------------------------------------- */

SELECT *
FROM Customers
WHERE FirstName LIKE 'M%';
