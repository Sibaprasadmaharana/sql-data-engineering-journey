/* =========================================================
   SQL DATE FUNCTIONS PRACTICE
   Database: SalesDB
   ========================================================= */


/* ---------------------------------------------------------
   1. Show orders placed during February
   MONTH()
   --------------------------------------------------------- */

SELECT *
FROM Orders
WHERE MONTH(OrderDate) = 2;


/* ---------------------------------------------------------
   2. Show order month and total sales
   DATENAME() + SUM() + GROUP BY
   --------------------------------------------------------- */

SELECT
    DATENAME(MONTH, OrderDate) AS OrderMonth,
    SUM(Sales) AS TotalSales
FROM Orders
GROUP BY DATENAME(MONTH, OrderDate);


/* ---------------------------------------------------------
   3. Show order month and year
   FORMAT()
   --------------------------------------------------------- */

SELECT
    FORMAT(OrderDate, 'MMM yy') AS OrderMonth,
    COUNT(*) AS TotalOrders
FROM Orders
GROUP BY FORMAT(OrderDate, 'MMM yy')
ORDER BY MIN(OrderDate);


/* ---------------------------------------------------------
   4. Calculate employee age
   DATEDIFF() + GETDATE()
   --------------------------------------------------------- */

SELECT
    FirstName,
    BirthDate,
    DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age
FROM Employees;


/* ---------------------------------------------------------
   5. Calculate average shipping duration in days
      for each month
   DATEDIFF() + AVG() + GROUP BY
   --------------------------------------------------------- */

SELECT
    DATENAME(MONTH, OrderDate) AS OrderMonth,
    AVG(DATEDIFF(DAY, OrderDate, ShipDate)) AS AvgShippingDays
FROM Orders
GROUP BY DATENAME(MONTH, OrderDate);


/* ---------------------------------------------------------
   6. Find the number of days between each order
      and the previous order
   LAG() + DATEDIFF()
   --------------------------------------------------------- */

WITH OrderDates AS
(
    SELECT
        OrderID,
        OrderDate,
        LAG(OrderDate) OVER (ORDER BY OrderDate) AS PreviousOrderDate
    FROM Orders
)
SELECT
    OrderID,
    OrderDate AS CurrentOrderDate,
    PreviousOrderDate,
    DATEDIFF(DAY, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder
FROM OrderDates;


/* ---------------------------------------------------------
   7. Display creation time in a custom format
   FORMAT() + DATENAME()
   --------------------------------------------------------- */

SELECT
    OrderID,
    CreationTime,
    'Day ' +
    FORMAT(CreationTime, 'ddd MMM') +
    ' Q' +
    DATENAME(QUARTER, CreationTime) +
    ' ' +
    FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS CustomFormat
FROM Orders;
