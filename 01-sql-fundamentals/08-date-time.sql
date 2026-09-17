/* =========================================================
   SQL DATE & TIME PRACTICE
   Database: SalesDB
   ========================================================= */


/* ---------------------------------------------------------
   1. Display creation time in a custom format

   Required format:
   Day Wed Jan Q1 2025 12:34:56 PM

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


/* ---------------------------------------------------------
   2. Extract the date portion from CreationTime
   CAST()
   --------------------------------------------------------- */

SELECT
    OrderID,
    CreationTime,
    CAST(CreationTime AS DATE) AS CreationDate
FROM Orders;


/* ---------------------------------------------------------
   3. Extract the time portion from CreationTime
   CAST()
   --------------------------------------------------------- */

SELECT
    OrderID,
    CreationTime,
    CAST(CreationTime AS TIME) AS CreationTimeOnly
FROM Orders;


/* ---------------------------------------------------------
   4. Extract year, month, day and time components
   YEAR() + MONTH() + DAY()
   --------------------------------------------------------- */

SELECT
    OrderID,
    CreationTime,
    YEAR(CreationTime) AS CreationYear,
    MONTH(CreationTime) AS CreationMonth,
    DAY(CreationTime) AS CreationDay
FROM Orders;


/* ---------------------------------------------------------
   5. Extract hour, minute and second
   DATEPART()
   --------------------------------------------------------- */

SELECT
    OrderID,
    CreationTime,
    DATEPART(HOUR, CreationTime) AS CreationHour,
    DATEPART(MINUTE, CreationTime) AS CreationMinute,
    DATEPART(SECOND, CreationTime) AS CreationSecond
FROM Orders;
