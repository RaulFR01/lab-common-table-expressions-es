use northwind;
-- Consulta 1
WITH cte_product
AS
(SELECT ProductName, Unit
FROM products 
WHERE Price > 50
)

SELECT ProductName, Unit
FROM cte_product;


-- Consulta 2

WITH cte_sales
AS
(
SELECT p.ProductName AS producto, o.ProductID AS idProducto, SUM(o.Quantity*p.Price) over (partition by o.ProductID) AS total_revenue
FROM orderdetails o
JOIN products p
ON o.ProductID = p.ProductID
)

SELECT distinct producto, idProducto, total_revenue
FROM cte_sales
ORDER BY total_revenue DESC
LIMIT 5;

-- Consulta 3

WITH
cte_categories
AS
(
SELECT c.CategoryName AS CategoryName, COUNT(*) AS ProductCount
FROM categories c
JOIN products p
ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID
)

SELECT CategoryName, ProductCount
FROM cte_categories 
ORDER BY ProductCount DESC;

-- Consulta 4

WITH 
cte_avgQuantity
AS
(
SELECT c.CategoryName AS CategoryName , AVG(o.Quantity) over (partition by c.CategoryID) AS AvgOrderQuantity
FROM orderdetails o
JOIN products p
ON o.ProductID = p.ProductID 
JOIN categories c
ON p.CategoryID = c.CategoryID
)

SELECT distinct CategoryName, AvgOrderQuantity
FROM cte_avgQuantity;

-- Consulta 5

WITH cte_avgVeneu
AS
(
SELECT ord.CustomerID as CustomerID,c.CustomerName as CustomerName, AVG(o.Quantity*p.Price) over (partition by ord.CustomerID) AS AvgOrderAmount
FROM orderdetails o
JOIN orders ord
ON o.OrderID = ord.OrderID
JOIN customers c
ON ord.CustomerID = c.CustomerID
JOIN products p
ON o.ProductID = p.ProductID
)

SELECT distinct CustomerID, CustomerName, AvgOrderAmount
FROM cte_avgVeneu
ORDER BY AvgOrderAmount DESC;

-- Consulta 6
WITH cte_TotalSales
AS
(
SELECT p.ProductName as ProductName ,sum(o.Quantity) over (partition by p.ProductID) AS TotalSales
FROM orderdetails o
JOIN orders ord
ON o.OrderID = ord.OrderID
JOIN products p
ON o.ProductID = p.ProductID
WHERE ord.OrderDate BETWEEN "1997-01-01 00:00:00" AND "1997-12-31 00:00:00"
)

SELECT distinct ProductName, TotalSales
FROM cte_TotalSales
ORDER BY TotalSales DESC;
