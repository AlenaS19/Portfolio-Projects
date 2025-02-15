

-- ИЗМЕНЕНИЕ ТИПОВ СТОЛБЦОВ
-----------------------------
SELECT [Region]
      ,[Country]
      ,[Item Type]
      ,[Sales Channel]
      ,[Order Priority]
      ,[Order Date]
      ,[Order ID]
      ,[Ship Date]
      ,[Units Sold]
      ,[Unit Price]
      ,[Unit Cost]
      ,[Total Revenue]
      ,[Total Cost]
      ,[Total Profit]
  FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]

------------------------------------------------------------------------


-- Столбец [Order Date]
ALTER TABLE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
ALTER COLUMN [Order Date] DATE

UPDATE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
SET [Order Date] = CONVERT(date, [Order Date], 101)

-- Столбец [Ship Date]
ALTER TABLE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
ALTER COLUMN [Ship Date] DATE

UPDATE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
SET [Ship Date] = CONVERT(date, [Ship Date], 101)


-- Столбец [Order ID]
ALTER TABLE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
ALTER COLUMN [Order ID] int

UPDATE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
SET [Order ID] = CONVERT(int, [Order ID])


-- Столбец [Units Sold]
ALTER TABLE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
ALTER COLUMN [Units Sold] int

UPDATE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
SET [Units Sold] = CONVERT(int, [Units Sold])


-- Столбец [Unit Price]
ALTER TABLE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
ALTER COLUMN [Unit Price] float

UPDATE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
SET [Unit Price] = CONVERT(float, [Unit Price])


-- Столбец [Unit Cost]
ALTER TABLE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
ALTER COLUMN [Unit Cost] float

UPDATE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
SET [Unit Cost] = CONVERT(float, [Unit Cost])


-- Столбец [Total Revenue]
ALTER TABLE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
ALTER COLUMN [Total Revenue] float

UPDATE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
SET [Total Revenue] = CONVERT(float, [Total Revenue])


-- Столбец [Total Cost]
ALTER TABLE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
ALTER COLUMN [Total Cost] float

UPDATE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
SET [Total Cost] = CONVERT(float, [Total Cost])


-- Столбец [Total Profit]
ALTER TABLE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
ALTER COLUMN [Total Profit] float

UPDATE [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
SET [Total Profit] = CONVERT(float, [Total Profit])

------------------------------------------------------------------------------------------------

-- EDA
-----------------

SELECT *
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]


SELECT DISTINCT Country
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]


SELECT DISTINCT [Item Type]
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]


SELECT MIN([Order Date]), max([Order Date])
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]

-----------------------------------------------------------------------------------------------

-- Продажы по странам

SELECT Country, SUM([Units Sold]) AS [quantity]
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
GROUP BY Country
ORDER BY 2 desc

SELECT Country, SUM([Total Profit]) AS profit
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
GROUP BY Country
ORDER BY 2 desc

---------------------------------------------------------------

-- Продажы по типу товара

SELECT [Item Type], SUM([Units Sold]) AS [quantity]
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
GROUP BY [Item Type]
ORDER BY 2 desc

SELECT [Item Type], SUM([Total Profit]) AS profit
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
GROUP BY [Item Type]
ORDER BY 2 desc

---------------------------------------------------------------

-- Продажы по типу канала продаж

SELECT [Sales Channel], SUM([Units Sold]) AS [quantity]
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
GROUP BY [Sales Channel]
ORDER BY 2 desc

SELECT [Sales Channel], SUM([Total Profit]) AS profit
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
GROUP BY [Sales Channel]
ORDER BY 2 desc

---------------------------------------------------------------

-- Продажы по типу приоритета

SELECT [Order Priority], SUM([Units Sold]) AS [quantity]
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
GROUP BY [Order Priority]
ORDER BY 2 desc

SELECT [Order Priority], SUM([Total Profit]) AS profit
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
GROUP BY [Order Priority]
ORDER BY 2 desc

---------------------------------------------------------------

-- Анализ продаж (количество) по товарам и каналам продажи


SELECT a.[Item Type],
	   sum(CASE WHEN b.[Sales Channel] = 'Offline' THEN b.[Units Sold] ELSE 0 END) AS 'Offline',
	   sum(CASE WHEN b.[Sales Channel] = 'Online' THEN b.[Units Sold] ELSE 0 END) AS 'Online',
	   sum(CASE WHEN b.[Sales Channel] in ('Offline', 'Online') THEN b.[Units Sold] ELSE 0 END) AS 'Total'
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records] a
INNER JOIN [Project 11 - Europe Sales].[dbo].[Europe Sales Records] b
	ON a.[Order ID] = b.[Order ID]
GROUP BY a.[Item Type]
ORDER BY 3 desc

-- Анализ продаж (прибыль) по товарам и каналам продажи


SELECT a.[Item Type],
	   sum(CASE WHEN b.[Sales Channel] = 'Offline' THEN b.[Total Profit] ELSE 0 END) AS 'Offline',
	   sum(CASE WHEN b.[Sales Channel] = 'Online' THEN b.[Total Profit] ELSE 0 END) AS 'Online',
	   sum(CASE WHEN b.[Sales Channel] in ('Offline', 'Online') THEN b.[Total Profit] ELSE 0 END) AS 'Total'
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records] a
INNER JOIN [Project 11 - Europe Sales].[dbo].[Europe Sales Records] b
	ON a.[Order ID] = b.[Order ID]
GROUP BY a.[Item Type]
ORDER BY 3 desc

-- Метод Pivot

SELECT *
FROM ( 
	SELECT [Item Type], [Sales Channel], [Total Profit]
	FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
)[Europe Sales Records]
PIVOT (
	sum([Total Profit])
	FOR [Sales Channel] in ([Offline], [Online])
) AS sales_pivot

------------------------------------------------------------------------------------------------------

-- Переодичность заказов по странам

SELECT *
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
WHERE Country = 'Albania'
ORDER BY [Order Date]


With countOrders ([Country], [Item Type], [Order Date], [Total quantity], [Total Profit], [Group of Profit], [Total Orders], [Previous Date]) 
as
	(
SELECT [Country], [Item Type], [Order Date], 
	   sum([Units Sold]) AS 'Total quantity',
	   sum([Total Profit]) AS 'Total Profit',
	   count([Order Date]) OVER (PARTITION BY Country ORDER BY Country, [Order Date]) AS 'Group of Order',
	   count([Order Date]) OVER (PARTITION BY [Country]) AS 'Total Orders',
	   LAG([Order Date], 1) OVER (PARTITION BY Country ORDER BY Country) AS 'Previous Date'

FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
GROUP BY [Country], [Item Type], [Order Date] 
--ORDER BY 6 desc
)
SELECT *, DATEDIFF(DAY, [Previous Date], [Order Date]) AS 'Count Days'
FROM countOrders
ORDER BY 1


With overall_item as (
SELECT Country, [Item Type], sum([Units Sold]) AS [Total Quantity]
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
GROUP BY Country, [Item Type]
),
fav_item as (
SELECT t.Country, t.[Item Type], max(t.[Total Quantity]) AS [Quantity]
FROM overall_item t
GROUP BY t.Country, t.[Item Type]
)
SELECT t.Country, t.[Item Type], t.Quantity
FROM fav_item t
LEFT JOIN overall_item a
	ON t.Country = a.Country


--FAVOURITE ITEMS
With item_total as (
SELECT Country, [Item Type], sum([Units Sold]) AS [Total Quantity]
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
GROUP BY Country, [Item Type]
),
item_fav as (
SELECT Country, 
	   [Item Type], 
	   [Total Quantity],
	   rank() OVER (PARTITION BY Country ORDER BY [Total Quantity] desc) AS Rating
FROM item_total
)
SELECT Country, [Item Type], [Total Quantity]
FROM item_fav
WHERE Rating = 1
ORDER BY 3 DESC



With item_total as (
SELECT Country, [Order Date], [Item Type]
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
GROUP BY Country, [Item Type]
),
item_fav as (
SELECT Country, 
	   [Item Type], 
	   [Order Date],
	   [Total Quantity],
	   rank() OVER (PARTITION BY Country ORDER BY [Total Quantity] desc) AS Rating
FROM item_total
)
SELECT Country, [Item Type], [Order Date], [Total Quantity]
FROM item_fav
WHERE Rating = 1
ORDER BY 3 DESC




SELECT *
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]


SELECT Country, sum([Units Sold])
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
WHERE [Item Type] = 'Office Supplies'
GROUP BY Country
ORDER BY 2 DESC


With fruits as (
SELECT SUM([Units Sold]) as 'overall'
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records]
WHERE [Item Type] = 'Office Supplies'
)
SELECT Country, sum([Units Sold]) AS 'Total Quantity', Sum([Units Sold]) * 100.0 / (SELECT overall FROM fruits) as 'share'
FROM [Project 11 - Europe Sales].[dbo].[Europe Sales Records] 
WHERE [Item Type] = 'Office Supplies'
GROUP BY Country
ORDER BY 3 desc
