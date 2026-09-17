/* =========================================================
   SQL JOINS PRACTICE
   Database: SalesDB
   ========================================================= */


/* ---------------------------------------------------------
   1. Get all customers who haven't placed any order
   LEFT ANTI JOIN
   --------------------------------------------------------- */

SELECT *
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;


/* ---------------------------------------------------------
   2. Get all orders without matching customers
   RIGHT ANTI JOIN
   --------------------------------------------------------- */

SELECT *
FROM Customers AS c
RIGHT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL;


/* ---------------------------------------------------------
   3. Find customers without orders
      and orders without customers
   FULL ANTI JOIN
   --------------------------------------------------------- */

SELECT *
FROM Customers AS c
FULL JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL
   OR o.CustomerID IS NULL;


/* ---------------------------------------------------------
   4. Get all customers along with their orders,
      but only customers who have placed an order
   LEFT JOIN + NULL filtering
   --------------------------------------------------------- */

SELECT *
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NOT NULL;


/* ---------------------------------------------------------
   5. Generate all possible combinations
      of customers and orders
   CROSS JOIN
   --------------------------------------------------------- */

SELECT *
FROM Customers
CROSS JOIN Orders;


/* ---------------------------------------------------------
   6. Get all orders along with related:
      - Customer
      - Product
      - Employee/Salesperson details
   Multiple LEFT JOINs
   --------------------------------------------------------- */

SELECT
    o.OrderID AS OrderID,
    c.FirstName AS CustomerName,
    p.Product AS Product,
    o.Sales AS Sales,
    p.Price AS Price,
    e.FirstName AS SalespersonName
FROM Orders AS o
LEFT JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
LEFT JOIN Products AS p
    ON o.ProductID = p.ProductID
LEFT JOIN Employees AS e
    ON o.SalesPersonID = e.EmployeeID;


/* ---------------------------------------------------------
   7. Total sales by customer
   LEFT JOIN + GROUP BY
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
   8. Customers with more than one order
   LEFT JOIN + GROUP BY + HAVING
   --------------------------------------------------------- */

SELECT
    c.FirstName AS CustomerName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName
HAVING COUNT(o.OrderID) > 1;
