/* =========================================================
   SQL AGGREGATION PRACTICE
   Database: SalesDB
   ========================================================= */


/* ---------------------------------------------------------
   1. Total sales by customer
   SUM() + GROUP BY + ORDER BY
   --------------------------------------------------------- */

SELECT
    c.FirstName AS CustomerName,
    SUM(o.Sales) AS TotalSales
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName
ORDER BY TotalSales DESC;


/* ---------------------------------------------------------
   2. Customers with more than one order
   COUNT() + GROUP BY + HAVING
   --------------------------------------------------------- */

SELECT
    c.FirstName AS CustomerName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName
HAVING COUNT(o.OrderID) > 1;


/* ---------------------------------------------------------
   3. Average score of all customers
   AVG() as a window function
   --------------------------------------------------------- */

SELECT
    CustomerID,
    Score,
    AVG(Score) OVER () AS AvgScore
FROM Customers;


/* ---------------------------------------------------------
   4. Average customer score after replacing NULL with 0
   COALESCE() + AVG()
   --------------------------------------------------------- */

SELECT
    CustomerID,
    Score,
    AVG(COALESCE(Score, 0)) OVER () AS AvgScore
FROM Customers;


/* ---------------------------------------------------------
   5. Total sales by year
   YEAR() + COUNT()
   --------------------------------------------------------- */

SELECT
    YEAR(OrderDate) AS OrderYear,
    COUNT(*) AS TotalOrders
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;


/* ---------------------------------------------------------
   6. Total sales by month
   MONTH + SUM()
   --------------------------------------------------------- */

SELECT
    DATENAME(MONTH, OrderDate) AS OrderMonth,
    SUM(Sales) AS TotalSales
FROM Orders
GROUP BY DATENAME(MONTH, OrderDate);


/* ---------------------------------------------------------
   7. Average shipping duration by month
   AVG() + DATEDIFF() + GROUP BY
   --------------------------------------------------------- */

SELECT
    DATENAME(MONTH, OrderDate) AS OrderMonth,
    AVG(DATEDIFF(DAY, OrderDate, ShipDate)) AS AvgShippingDays
FROM Orders
GROUP BY DATENAME(MONTH, OrderDate);


/* ---------------------------------------------------------
   8. Total sales by sales category
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
