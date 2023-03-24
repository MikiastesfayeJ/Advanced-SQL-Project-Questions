--6) Write a query that returns the company's month-over-month sales and percentage change in sales. 
-----You result should show the following fields/columns: Month, SalesVolume, PercentageChange

-- month => OrderDate
-- sales => TotdalDue 
-- percentage change => (current sale - previous sale) / previous sale
WITH CTE AS (
SELECT	DATEPART(MONTH, OrderDate) AS Month
		,FORMAT(SUM(TotalDue), 'N') AS [Sales Volume]
		,LAG(SUM(TotalDue), 1) OVER 
		(
			ORDER BY DATEPART(MONTH, OrderDate)
		) AS [Previous Month]

FROM [Sales].[SalesOrderHeader]
GROUP BY DATEPART(MONTH, OrderDate)
)
SELECT	Month, [Sales Volume]
		,FORMAT(CAST(ISNULL(([Sales Volume] - [Previous Month]) / [Previous Month], 0) as float), 'P') AS [% Change]
FROM CTE