--4) How many products and how much sales under each ProductCategory have been sold in each city?. 
-----You result should show the following fields/columns: City, ProductCategory, TotalSales, CountofSales

-- City				=>	[Person].[Address]				=> City
-- ProductCategory	=>	[Production].[ProductCategory]	=> Name
-- TotalSales		=>	[Sales].[SalesOrderHeader]		=> SUM(TotalDue)
-- CountofSales		=>  [Sales].[SalesOrderHeader]		=> COUNT(SalesOrderID)

SELECT * FROM [Person].[Address]				-- AddressID
SELECT * FROM [Sales].[SalesOrderHeader]		-- ShipToAddressID, SalesOrderID
SELECT * FROM [Sales].[SalesOrderDetail]		-- SalesOrderID, ProductID
SELECT * FROM [Production].[Product]			-- ProductID, ProductSubcategoryID
SELECT * FROM [Production].[ProductSubcategory] -- ProductSubcategoryID, ProductCategoryID
SELECT * FROM [Production].[ProductCategory]	-- ProductCategoryID
;
WITH CTE AS (
SELECT per.City, pc.Name AS [Product Category], 
	   SUM(soh.TotalDue) AS [Total Sales], 
	   COUNT(soh.SalesOrderID) AS [Count of Sales]
FROM 
	[Person].[Address] per
	LEFT JOIN [Sales].[SalesOrderHeader] soh
		ON per.AddressID = soh.ShipToAddressID
	LEFT JOIN [Sales].[SalesOrderDetail] sod
		ON soh.SalesOrderID = sod.SalesOrderDetailID
	LEFT JOIN [Production].[Product] pro
		ON sod.ProductID = pro.ProductID
	LEFT JOIN [Production].[ProductSubcategory] psc
		ON pro.ProductSubcategoryID = psc.ProductSubcategoryID
	JOIN [Production].[ProductCategory] pc
		ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY per.City, pc.Name
)
SELECT City, [Product Category], [Total Sales], [Count of Sales], 
	   SUM([Count of Sales]) OVER (PARTITION BY City) AS [Count of Sales per City]
FROM CTE