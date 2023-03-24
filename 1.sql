--1) What are the best selling items by value and quantity sold in each city?

--By Value

WITH CitySales (City, ProductName, SalesTotal, Row_Number) AS (			--CTE: total sales for every item 
    SELECT
        a.City,
        p.Name ProductName,
        ROUND(SUM(TotalDue), 2) as SalesTotal,
		ROW_NUMBER() OVER (
					PARTITION BY a.City
					ORDER BY SUM(TotalDue) DESC) AS row_num
    FROM	
			[Person].[Address] a							--to get city column
			JOIN [Sales].[SalesOrderHeader] soh				--to get sales
				on a.AddressID = soh.ShipToAddressID
			JOIN [Sales].[SalesOrderDetail] sod
				on soh.SalesOrderID = sod.SalesOrderID
			JOIN [Production].[Product] p					--to get product name
				on sod.ProductID = p.ProductID
    GROUP BY	
        a.City,
        p.Name
)
SELECT City, ProductName, SalesTotal
FROM CitySales
WHERE Row_Number = 1			--to ONLY get the products with the MOST sales in each City

;

--BY Quantity Sold

WITH CitySales (City, ProductName, QuantitySold, Row_Number) AS (			--CTE: total ordered quantities for every item 
    SELECT
        a.City,
        p.Name ProductName,
        SUM(OrderQty) as QuantitySold,
		ROW_NUMBER() OVER (
					PARTITION BY a.City
					ORDER BY SUM(OrderQty) DESC)
    FROM	
			[Person].[Address] a							--to get city
			JOIN [Sales].[SalesOrderHeader] soh				--to get Quantitiy Sold
				on a.AddressID = soh.ShipToAddressID
			JOIN [Sales].[SalesOrderDetail] sod
				on soh.SalesOrderID = sod.SalesOrderID
			JOIN [Production].[Product] p					--to get product name
				on sod.ProductID = p.ProductID
    GROUP BY	
        a.City,
        p.Name
)
SELECT City, ProductName, QuantitySold
FROM CitySales
WHERE Row_Number = 1		--to ONLY get the products with the MOST sales in each City