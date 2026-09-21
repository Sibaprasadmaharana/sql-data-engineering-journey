/* =========================================================
   SQL WINDOW FUNCTIONS PRACTICE
   Database: SalesDB

   Topics:
   - SUM() OVER()
   - AVG() OVER()
   - RANK()
   - DENSE_RANK()
   - ROW_NUMBER()
   - LAG()
   - LEAD()
   - FIRST_VALUE()
   - LAST_VALUE()
   - NTILE()
   - CUME_DIST()
   - PARTITION BY
   - Window Frames
   ========================================================= */


/* ---------------------------------------------------------
   1. Find the total sales for each product
      while keeping individual order details
   --------------------------------------------------------- */

SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY ProductID
    ) AS TotalSalesByProduct
FROM Orders;


/* ---------------------------------------------------------
   2. Rank each order based on sales
      Highest sales = Rank 1
   --------------------------------------------------------- */

SELECT
    OrderID,
    OrderDate,
    Sales,
    RANK() OVER (
        ORDER BY Sales DESC
    ) AS SalesRank
FROM Orders;


/* ---------------------------------------------------------
   3. Rank customers based on their total sales
   --------------------------------------------------------- */

SELECT
    CustomerID,
    SUM(Sales) AS TotalSales,
    RANK() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS CustomerRank
FROM Orders
GROUP BY CustomerID;


/* ---------------------------------------------------------
   4. Calculate each order's percentage contribution
      to total sales
   --------------------------------------------------------- */

SELECT
    OrderID,
    ProductID,
    Sales,
    SUM(Sales) OVER () AS TotalSales,
    CONCAT(
        ROUND(
            CAST(Sales AS FLOAT)
            / SUM(Sales) OVER () * 100,
            2
        ),
        '%'
    ) AS SalesPercentage
FROM Orders;


/* ---------------------------------------------------------
   5. Find the average customer score
      while keeping customer-level details
   --------------------------------------------------------- */

SELECT
    CustomerID,
    LastName,
    Score,
    AVG(COALESCE(Score, 0)) OVER () AS AverageScore
FROM Customers;


/* ---------------------------------------------------------
   6. Find orders where sales are higher than
      the average sales across all orders
   --------------------------------------------------------- */

SELECT
    OrderID,
    Sales,
    AverageSales
FROM
(
    SELECT
        OrderID,
        Sales,
        AVG(Sales) OVER () AS AverageSales
    FROM Orders
) AS X
WHERE Sales > AverageSales;


/* ---------------------------------------------------------
   7. Find the deviation of each sale from
      the minimum and maximum sales
   --------------------------------------------------------- */

SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    MAX(Sales) OVER () AS HighestSales,
    MIN(Sales) OVER () AS LowestSales,
    Sales - MIN(Sales) OVER () AS DeviationFromMin,
    Sales - MAX(Sales) OVER () AS DeviationFromMax
FROM Orders;


/* ---------------------------------------------------------
   8. Calculate a moving average for each product
      including the current and next order
   --------------------------------------------------------- */

SELECT
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    AVG(Sales) OVER (
        PARTITION BY ProductID
        ORDER BY OrderDate
        ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
    ) AS MovingAverage
FROM Orders;


/* ---------------------------------------------------------
   9. Compare ROW_NUMBER, RANK and DENSE_RANK
   --------------------------------------------------------- */

SELECT
    OrderID,
    ProductID,
    Sales,

    ROW_NUMBER() OVER (
        ORDER BY Sales DESC
    ) AS SalesRank_RowNumber,

    RANK() OVER (
        ORDER BY Sales DESC
    ) AS SalesRank_Rank,

    DENSE_RANK() OVER (
        ORDER BY Sales DESC
    ) AS SalesRank_DenseRank

FROM Orders;


/* ---------------------------------------------------------
   10. Find the highest sale for each product
   --------------------------------------------------------- */

SELECT
    ProductID,
    Sales,
    SalesRank
FROM
(
    SELECT
        ProductID,
        Sales,
        RANK() OVER (
            PARTITION BY ProductID
            ORDER BY Sales DESC
        ) AS SalesRank
    FROM Orders
) AS X
WHERE SalesRank = 1;


/* ---------------------------------------------------------
   11. Find the two customers with the lowest
       total sales
   --------------------------------------------------------- */

SELECT
    CustomerID,
    TotalSales,
    CustomerRank
FROM
(
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales,
        ROW_NUMBER() OVER (
            ORDER BY SUM(Sales)
        ) AS CustomerRank
    FROM Orders
    GROUP BY CustomerID
) AS X
WHERE CustomerRank <= 2;


/* ---------------------------------------------------------
   12. Remove duplicate rows from Orders_Archive

   Keep the most recent record based on CreationTime
   --------------------------------------------------------- */

SELECT *
FROM
(
    SELECT
        ROW_NUMBER() OVER (
            PARTITION BY OrderID
            ORDER BY CreationTime DESC
        ) AS RowNum,
        *
    FROM Orders_Archive
) AS X
WHERE RowNum = 1;


/* ---------------------------------------------------------
   13. Segment orders into three sales categories
       using NTILE()

   1 = High
   2 = Medium
   3 = Low
   --------------------------------------------------------- */

SELECT
    *,
    CASE
        WHEN SalesBucket = 1 THEN 'High'
        WHEN SalesBucket = 2 THEN 'Medium'
        WHEN SalesBucket = 3 THEN 'Low'
    END AS SalesCategory
FROM
(
    SELECT
        NTILE(3) OVER (
            ORDER BY Sales DESC
        ) AS SalesBucket,
        *
    FROM Orders
) AS X;


/* ---------------------------------------------------------
   14. Find products within the highest 40%
       of prices
   --------------------------------------------------------- */

SELECT
    Product,
    Price,
    PricePercentage
FROM
(
    SELECT
        Product,
        Price,
        CUME_DIST() OVER (
            ORDER BY Price DESC
        ) AS PricePercentage
    FROM Products
) AS X
WHERE PricePercentage <= 0.4;


/* ---------------------------------------------------------
   15. Calculate monthly sales with:
       - Previous month's sales
       - Next month's sales
   --------------------------------------------------------- */

SELECT
    MonthName,
    TotalSales,

    LAG(
        TotalSales,
        1,
        0
    ) OVER (
        ORDER BY MonthNumber
    ) AS PreviousMonthSales,

    LEAD(
        TotalSales
    ) OVER (
        ORDER BY MonthNumber
    ) AS NextMonthSales

FROM
(
    SELECT
        MONTH(OrderDate) AS MonthNumber,
        DATENAME(MONTH, OrderDate) AS MonthName,
        SUM(Sales) AS TotalSales
    FROM Orders
    GROUP BY
        MONTH(OrderDate),
        DATENAME(MONTH, OrderDate)
) AS X

ORDER BY MonthNumber;


/* ---------------------------------------------------------
   16. Calculate month-over-month sales percentage change
   --------------------------------------------------------- */

SELECT
    MonthName,
    TotalSales,
    PreviousMonthSales,

    ROUND(
        CAST(
            TotalSales - PreviousMonthSales
            AS FLOAT
        )
        / NULLIF(PreviousMonthSales, 0) * 100,
        2
    ) AS MoMPercentage

FROM
(
    SELECT
        MONTH(OrderDate) AS MonthNumber,
        DATENAME(MONTH, OrderDate) AS MonthName,
        SUM(Sales) AS TotalSales,

        LAG(
            SUM(Sales)
        ) OVER (
            ORDER BY MONTH(OrderDate)
        ) AS PreviousMonthSales

    FROM Orders

    GROUP BY
        MONTH(OrderDate),
        DATENAME(MONTH, OrderDate)
) AS X

ORDER BY MonthNumber;


/* ---------------------------------------------------------
   17. Analyze customer loyalty by ranking customers
       based on average days between orders
   --------------------------------------------------------- */

SELECT
    CustomerID,
    AVG(DaysUntilNextOrder) AS AvgDaysBetweenOrders,

    RANK() OVER (
        ORDER BY AVG(DaysUntilNextOrder)
    ) AS CustomerRank

FROM
(
    SELECT
        OrderID,
        CustomerID,
        OrderDate AS CurrentOrderDate,

        LEAD(OrderDate) OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate
        ) AS NextOrderDate,

        DATEDIFF(
            DAY,
            OrderDate,
            LEAD(OrderDate) OVER (
                PARTITION BY CustomerID
                ORDER BY OrderDate
            )
        ) AS DaysUntilNextOrder

    FROM Orders
) AS X

GROUP BY CustomerID;


/* ---------------------------------------------------------
   18. Find the lowest and highest sales for each product
   FIRST_VALUE() + LAST_VALUE()
   --------------------------------------------------------- */

SELECT
    OrderID,
    ProductID,
    Sales,

    FIRST_VALUE(Sales) OVER (
        PARTITION BY ProductID
        ORDER BY Sales
    ) AS LowestSales,

    LAST_VALUE(Sales) OVER (
        PARTITION BY ProductID
        ORDER BY Sales
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS HighestSales

FROM Orders;
