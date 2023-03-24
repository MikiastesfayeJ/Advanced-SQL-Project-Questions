--2) Identify the 5 most important countries in terms of their total volume of sales 
-----and show total volume of sales for each country under every product category. 
-----Your result should show the following fields/columns: Country, ProductCategory, TotalSales

WITH Country_Sales AS (
	SELECT
		st.CountryRegionCode AS Country,
		pc.Name as ProductCategory,
		ROUND(SUM(TotalDue), 2) AS TotalSales
	FROM
		[Sales].[SalesOrderHeader] soh
		JOIN [Sales].[SalesTerritory] st
			ON soh.TerritoryID = st.TerritoryID
		JOIN [Sales].[SalesOrderDetail] sod
			ON soh.SalesOrderID = sod.SalesOrderID
		JOIN [Production].[Product] p
			ON sod.ProductID = p.ProductID
		JOIN [Production].[ProductSubcategory]  psc
			ON p.ProductSubcategoryID = psc.ProductSubcategoryID
		JOIN [Production].[ProductCategory]  pc
			ON psc.ProductCategoryID = pc.ProductCategoryID
	GROUP BY
		st.CountryRegionCode,
		pc.Name
)
SELECT *
FROM Country_Sales
WHERE Country IN 
(
	SELECT Country
	FROM 
	(
		--SUBQUERY TO FIND THE TOP 5 COUNTRIES IN TERMS OF SALES VOLUMES
		SELECT TOP 5
		st.CountryRegionCode as Country,
		COUNT(DISTINCT(soh.SalesOrderID)) as Total_Volume_of_Sales
		FROM
		[Sales].[SalesOrderHeader] soh
		JOIN [Sales].[SalesTerritory] st
			ON soh.TerritoryID = st.TerritoryID
		JOIN [Sales].[SalesOrderDetail] sod
			ON soh.SalesOrderID = sod.SalesOrderID
		GROUP BY st.CountryRegionCode
		ORDER BY Total_Volume_of_Sales DESC
	) sub1
)
ORDER BY
	Country,
    TotalSales DESC