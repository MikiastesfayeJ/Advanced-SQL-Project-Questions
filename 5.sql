--5) What's the yearly average number of sales orders and sales volume of each sales representative? 

-- number of sales orders = COUNT(SalesOrderID)
-- sales volume = SUM(TotalDue)
-- order year = OrderDate

--SELECT * FROM [Sales].[SalesOrderHeader]			-- SalesPersonID
--SELECT * FROM [Sales].[SalesPerson]				-- BusinessEntityID
--SELECT * FROM [Person].[Person]					-- BusinessEntityID 
--;
WITH CTE AS (
SELECT	p.FirstName AS [First Name]
		,p.LastName AS [Last Name] 
		,DATEPART(YEAR, soh.OrderDate) AS [Order Year]
		,COUNT(SalesOrderID) AS [Number of Orders]
		,SUM(TotalDue) AS [Sales Volume]

FROM 
	[Sales].[SalesOrderHeader] soh
	JOIN [Sales].[SalesPerson] sp
		ON soh.SalesPersonID = sp.BusinessEntityID
	JOIN [Person].[Person] p
		ON sp.BusinessEntityID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName, DATEPART(YEAR, soh.OrderDate)
)
SELECT [First Name], [Last Name],
		ROUND(AVG(CAST([Number of Orders] AS float)), 2) AS [Yearly Average No. of Orders], 
	    FORMAT(AVG([Sales Volume]), 'N') AS [Yearly Average Sales Volume]	
FROM CTE
GROUP BY [First Name], [Last Name]
ORDER BY [First Name], [Last Name]