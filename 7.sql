--7) How many orders in each region have sales amount in the ranges $0-$999, $1,000-$9,999 and above $10,000? 
-----Your result should look like this:

--Region	Range			Total Sales Value	Number of Orders
--r1	    $0-$1,000			$xxx				xxxx
--r1	    $1,000-$10,000		$xxxx				xx
--r1	    >$10,000			$xxx	            xx
--r2	    $0-$1,000		    $yyy	            y
--r2	    $1,000-$10,000		$yyyy	            yy
--r2	    >$10,000  			$yy	                yyy
--etc..........

-- region => Name from SalesTerritory
-- SUM(TotalDue) = from SalesOrderHeader
-- COUNT(SalesOrderID) = from SalesOrderHeader

--SELECT * FROM [Sales].[SalesOrderHeader]
--SELECT * FROM [Sales].[SalesTerritory]

WITH CTE AS (
SELECT	st.Name AS Region,
		CASE 
			WHEN TotalDue BETWEEN 0 AND 999 THEN '$0-$999'
			WHEN TotalDue BETWEEN 1000 AND 9999 THEN '$1000-$9999'
			ELSE '>$10,000 ' END
		 AS Range,
		TotalDue,
		SalesOrderID
FROM 
	[Sales].[SalesOrderHeader] soh
	JOIN [Sales].[SalesTerritory] st
		ON soh.TerritoryID = st.TerritoryID
)
SELECT	Region, Range, 
		FORMAT(SUM(TotalDue), 'N') AS [Total Sales Value], 
		COUNT(SalesOrderID) AS [Number of Orders]
FROM CTE
GROUP BY Region, Range
ORDER BY Region, Range