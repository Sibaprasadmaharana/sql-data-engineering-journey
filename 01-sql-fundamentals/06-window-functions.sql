/* =========================================================
   SQL WINDOW FUNCTIONS PRACTICE
   Database: SalesDB
   ========================================================= */


/* ---------------------------------------------------------
   1. Find the previous order date for each order
   LAG()
   --------------------------------------------------------- */

SELECT
    OrderID,
    OrderDate AS CurrentOrderDate,
    LAG(OrderDate) OVER (
        ORDER BY OrderDate
    ) AS PreviousOrderDate
FROM Orders;


/* ---------------------------------------------------------
   2. Find the number of days between each order
      and the previous order
   LAG() + DATEDIFF()
   --------------------------------------------------------- */

WITH OrderDates AS
(
    SELECT
        OrderID,
        OrderDate,
        LAG(OrderDate) OVER (
            ORDER BY OrderDate
        ) AS PreviousOrderDate
    FROM Orders
)
SELECT
    OrderID,
    OrderDate AS CurrentOrderDate,
    PreviousOrderDate,
    DATEDIFF(
        DAY,
        PreviousOrderDate,
        OrderDate
    ) AS DaysSincePreviousOrder
FROM OrderDates;


/* ---------------------------------------------------------
   3. Calculate the average score of all customers
   AVG() OVER()
   --------------------------------------------------------- */

SELECT
    CustomerID,
    Score,
    AVG(Score) OVER () AS AverageScore
FROM Customers;


/* ---------------------------------------------------------
   4. Calculate the average score after replacing
      NULL scores with 0
   AVG() OVER() + COALESCE()
   --------------------------------------------------------- */

SELECT
    CustomerID,
    Score,
    AVG(COALESCE(Score, 0)) OVER () AS AverageScore
FROM Customers;
