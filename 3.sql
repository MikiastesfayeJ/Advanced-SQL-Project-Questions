--3) Who are the best customers across all product lines?

-- [Person].[Person]			=> First Name & Last Name
-- [Sales].[SalesOrderDetail]	=> TotalDue
-- [Production].[Product]		=> ProductLine
select *
from [Person].[CountryRegion]
select *
from [Person].[Person]					-- BusinessEntityID
select *
from [Sales].[Customer] 				-- PersonID, CustomerID 
select *
from [Sales].[SalesOrderHeader]			-- CustomerID, SalesOrderID
select *
from [Sales].[SalesOrderDetail]			-- SalesOrderID, ProductID
select *
from [Production].[Product]				-- ProductID
;
WITH CustomerSales AS (
SELECT pro.ProductLine, per.FirstName, per.LastName, FORMAT(SUM(soh.TotalDue), 'N') AS [Total Sales],
		RANK() OVER (
						PARTITION BY pro.ProductLine
						ORDER BY SUM(soh.TotalDue) DESC
					) AS r
FROM 
	[Person].[Person] per
	JOIN [Sales].[Customer] c					-- JOIN choosen
		ON per.BusinessEntityID = c.PersonID
	JOIN [Sales].[SalesOrderHeader] soh			-- no difference between LEFT JOIN & JOIN
		ON c.CustomerID = soh.CustomerID
	JOIN [Sales].[SalesOrderDetail] sod			-- no difference between LEFT JOIN & JOIN
		ON soh.SalesOrderID = sod.SalesOrderID
	JOIN [Production].[Product] pro				-- no difference between LEFT JOIN & JOIN
		ON sod.ProductID = pro.ProductID
GROUP BY per.FirstName, per.LastName, pro.ProductLine
)
SELECT ProductLine, FirstName, LastName, [Total Sales]
FROM CustomerSales
WHERE r = 1