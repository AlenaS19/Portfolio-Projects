
SELECT *
FROM [Project6 - ShoppingMallOfIStanbul].[dbo].[customer_shopping_data]

------------------------------------------------------------------------------------------------------------------

-- ПРЕОБРАЗОВАНИЕ ДАННЫХ
---------------------------

-- Тип колонки quantity изменить на INT

ALTER TABLE [customer_shopping_data]
ALTER COLUMN quantity INT

UPDATE [customer_shopping_data]
SET quantity = CONVERT(int, quantity)
--------------------------------------
-- Тип колонки price изменить на FLOAT

ALTER TABLE [customer_shopping_data]
ALTER COLUMN price FLOAT

UPDATE [customer_shopping_data]
SET price = CONVERT(float, price)
----------------------------------
-- Тип колонки invoice_date изменить на DATE

ALTER TABLE [customer_shopping_data]
ALTER COLUMN invoice_date DATE

UPDATE [customer_shopping_data]
SET invoice_date = CONVERT(date, invoice_date)

------------------------------------------------

-- ДОПОЛНИТЕЛЬНЫЕ КОЛОНКИ
--------------------------

-- Добавление столбца Profit - кол-во приобретенных товаров * на цену за ед. товара

ALTER TABLE [customer_shopping_data]
ADD Profit FLOAT

UPDATE [customer_shopping_data]
SET Profit = quantity * price
------------------------------------------------

-- Новый столбец - Разбивка возраста на возрастные группы

ALTER TABLE [customer_shopping_data]
ADD AgeGroup VARCHAR(10)

UPDATE [customer_shopping_data]
SET AgeGroup = CASE WHEN age < 20 THEN '< 20' 
					WHEN age BETWEEN 20 AND 24 THEN '20-24'
					WHEN age BETWEEN 25 AND 29 THEN '25-29'
					WHEN age BETWEEN 30 AND 34 THEN '30-34'
					WHEN age BETWEEN 35 AND 39 THEN '35-39'
					WHEN age BETWEEN 40 AND 44 THEN '40-44'
				        WHEN age BETWEEN 45 AND 49 THEN '45-49'
					WHEN age BETWEEN 50 AND 54 THEN '50-54'
					WHEN age BETWEEN 55 AND 59 THEN '55-59'
					WHEN age BETWEEN 60 AND 64 THEN '60-64'
					WHEN age >= 65 THEN '> 65'
					END
-----------------------------------------------------------

-- Добавление столбца Count для подсчета кол-во покупателей

ALTER TABLE [customer_shopping_data]
ADD count_cust INT

UPDATE [customer_shopping_data]
SET count_cust = 1	-- работает в этом случае, так как все покупатели (ID покупателя) уникальные
-----------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------

-- (EDA) ИССЛЕДОВАТЕЛЬСКИЙ АНАЛИЗ ДАННЫХ 
-----------------------------------------

-- Количество запросов

SELECT count(invoice_no) 
FROM customer_shopping_data



-- Количество уникальных покупателей

SELECT count(DISTINCT customer_id) 
FROM customer_shopping_data



-- Проверка на дубликаты

SELECT invoice_no,
	    count(*)
FROM customer_shopping_data        
GROUP BY invoice_no
HAVING count(*) > 1



-- Период запросов

SELECT min(invoice_date) AS 'Date First', max(invoice_date) AS 'Date Last'
FROM customer_shopping_data



-- Категории товаров

SELECT DISTINCT category 
FROM customer_shopping_data
ORDER BY category



-- Диапазон возраста покупателей

SELECT min(age) 'Min Age', max(age) AS 'Max age'
FROM customer_shopping_data



-- Торговые центры

SELECT DISTINCT shopping_mall
FROM customer_shopping_data
ORDER BY shopping_mall



-- Виды платежей

SELECT DISTINCT payment_method
FROM customer_shopping_data
ORDER BY 1



-- Гендерная группа

SELECT count(gender) AS 'Female', (SELECT count(gender) 
FROM customer_shopping_data
WHERE gender = 'Male') AS 'Male'
FROM customer_shopping_data
WHERE gender = 'Female'


-- Диапазон цен (макс, мин)

SELECT min(price) 'Min Price', max(price) AS 'Max Price'
FROM customer_shopping_data

--------------------------------------------------------------------------------------------------------------

-- АНАЛИЗ
---------------------------------------------------------------------------------------------------------------

-- ОБЩИЙ АНАЛИЗ
-----------------
-- Кол-во проданых товаров и доход за весь период наблюдения

SELECT sum(quantity) AS 'Количество', round(sum(quantity * price), 2) AS 'Доход'
FROM customer_shopping_data


-- Какая цена за еденицу товара встречается чаще всего

SELECT price, count(price) AS 'Count price'
FROM customer_shopping_data
GROUP BY price
ORDER BY 2 DESC


-- Какое кол-во товаров покупают чаще всего 

SELECT quantity, count(quantity) AS 'Count quantity'
FROM customer_shopping_data
GROUP BY quantity
ORDER BY 2 DESC

-------------------------------------------------------------

-- АНАЛИЗ ЗА ТОРГОВЫМ ЦЕНТРОМ
------------------------------

-- Какой торговый центр посещают чаще всего

SELECT shopping_mall, count(shopping_mall) AS 'Count shopping mall'
FROM customer_shopping_data
GROUP BY shopping_mall
ORDER BY 2 DESC


-- Анализ продаж за торговым центром

SELECT shopping_mall AS 'Место продаж', 
		sum(quantity) AS 'Количество товаров',
		round(sum(Profit), 2) AS 'Доход', 
		sum(Profit) / (SELECT sum(Profit) FROM customer_shopping_data) * 100 AS 'Частка дохода'
FROM customer_shopping_data
GROUP BY shopping_mall
ORDER BY 4 DESC


-- Кол-во покупателей в зависимости от торгового центра и возрастной группы

SELECT a.shopping_mall,
	   sum(CASE WHEN b.AgeGroup = '< 20' THEN b.count_cust ELSE 0 end) AS '< 20',
	   sum(CASE WHEN b.AgeGroup = '20-24' THEN b.count_cust ELSE 0 end) AS '20-24',
	   sum(CASE WHEN b.AgeGroup = '25-29' THEN b.count_cust ELSE 0 end) AS '25-29',
	   sum(CASE WHEN b.AgeGroup = '30-34' THEN b.count_cust ELSE 0 end) AS '30-34',
	   sum(CASE WHEN b.AgeGroup = '35-39' THEN b.count_cust ELSE 0 end) AS '35-39',
	   sum(CASE WHEN b.AgeGroup = '40-44' THEN b.count_cust ELSE 0 end) AS '40-44',
	   sum(CASE WHEN b.AgeGroup = '45-49' THEN b.count_cust ELSE 0 end) AS '45-49',
	   sum(CASE WHEN b.AgeGroup = '50-54' THEN b.count_cust ELSE 0 end) AS '50-54',
	   sum(CASE WHEN b.AgeGroup = '55-59' THEN b.count_cust ELSE 0 end) AS '55-59',
	   sum(CASE WHEN b.AgeGroup = '60-64' THEN b.count_cust ELSE 0 end) AS '60-64',
	   sum(CASE WHEN b.AgeGroup = '> 65' THEN b.count_cust ELSE 0 end) AS '> 65'
FROM customer_shopping_data a
INNER JOIN customer_shopping_data b
	ON 	a.invoice_no = b.invoice_no
GROUP BY a.shopping_mall
ORDER BY 2 DESC

------------------------------------------------------------------

-- АНАЛИЗ ЗА КАТЕГОРИЯМИ
-------------------------

-- Какой торговый центр посещают чаще всего

SELECT category, count(category) AS 'Count category'
FROM customer_shopping_data
GROUP BY category
ORDER BY 2 DESC



-- Анализ продаж за категориями (Кол-во, доход, частка)

SELECT category AS 'Категории', 
		sum(quantity) AS 'Количество товаров',
		round(sum(Profit), 2) AS 'Доход', 
		sum(Profit) / (SELECT sum(Profit) FROM customer_shopping_data) * 100 AS 'Частка дохода'
FROM customer_shopping_data
GROUP BY category
ORDER BY 2 DESC

----------------------------------------------------------------------------------------

-- АНАЛИЗ ЗА ГЕНДЕРОМ (+ разбивка на категории)
-----------------------------------------------

-- Анализ продаж за гендером

SELECT gender AS 'Гендер', 
		sum(quantity) AS 'Количество товаров',
		round(sum(Profit), 2) AS 'Доход', 
		sum(Profit) / (SELECT sum(Profit) FROM customer_shopping_data) * 100 AS 'Частка дохода'
FROM customer_shopping_data
GROUP BY gender
ORDER BY 4 DESC


-- Кол-во проданых товаров в зависимости от категории и гендера

SELECT a.category,
	   sum(CASE WHEN b.gender = 'Female' THEN b.quantity ELSE 0 end) AS 'Female',
       sum(CASE WHEN b.gender = 'Male' THEN b.quantity ELSE 0 end) AS 'Male',
       sum(CASE WHEN b.gender IN ('Female', 'Male') THEN b.quantity ELSE 0 end) AS 'Total'
FROM customer_shopping_data a
INNER JOIN customer_shopping_data b
	ON 	a.invoice_no = b.invoice_no
GROUP BY a.category


-- Прибыль в зависимости от категории и гендера

SELECT a.category,
	   sum(CASE WHEN b.gender = 'Female' THEN b.Profit ELSE 0 end) AS 'Female',
	   sum(CASE WHEN b.gender = 'Male' THEN b.Profit ELSE 0 end) AS 'Male',
	   sum(CASE WHEN b.gender IN ('Male', 'Female') THEN b.Profit ELSE 0 end) AS 'Total'
FROM customer_shopping_data a
INNER JOIN customer_shopping_data b
	ON 	a.invoice_no = b.invoice_no
GROUP BY a.category
ORDER BY 2 DESC

-----------------------------------------------------------------------------------

-- АНАЛИЗ ЗА ВОЗРАСТНОЙ ГРУППОЙ (+ разбивка на гендер)
------------------------------------------------------

-- Какая возрастная группа покупает чаще всего 

SELECT AgeGroup, count(AgeGroup) AS 'Count Age Group'
FROM customer_shopping_data
GROUP BY AgeGroup
ORDER BY 2 DESC


-- Анализ продаж за возрастной группой (Кол-во, доход, частка)

SELECT AgeGroup AS 'Возрастная группа', 
		sum(quantity) AS 'Количество товаров',
		round(sum(Profit), 2) AS 'Доход', 
		sum(Profit) / (SELECT sum(Profit) FROM customer_shopping_data) * 100 AS 'Частка дохода'
FROM customer_shopping_data
GROUP BY AgeGroup
ORDER BY 4 DESC


-- Количество покупателей по возрастным группам и гендеру

SELECT a.AgeGroup,
	   sum(CASE WHEN b.gender = 'Male' THEN b.count_cust ELSE 0 end) AS 'Male',
       sum(CASE WHEN b.gender = 'Female' THEN b.count_cust ELSE 0 end) AS 'Female',
	   sum(CASE WHEN b.gender IN ('Male', 'Female') THEN b.count_cust ELSE 0 end) AS 'Total'
FROM customer_shopping_data a
INNER JOIN customer_shopping_data b
	ON 	a.invoice_no = b.invoice_no
GROUP BY a.AgeGroup


-- Прибыль в зависимости от возрастной группы и гендера 

SELECT a.AgeGroup,
	   sum(CASE WHEN b.gender = 'Female' THEN b.Profit ELSE 0 end) AS 'Female',
	   sum(CASE WHEN b.gender = 'Male' THEN b.Profit ELSE 0 end) AS 'Male',
	   sum(CASE WHEN b.gender IN ('Male', 'Female') THEN b.Profit ELSE 0 end) AS 'Total'
FROM customer_shopping_data a
INNER JOIN customer_shopping_data b
	ON 	a.invoice_no = b.invoice_no
GROUP BY a.AgeGroup
ORDER BY 2 DESC


-------------------------------------------------------------------------------

-- АНАЛИЗ ЗА МЕТОДОМ ОПЛАТЫ
----------------------------

-- Каким платежным метод пользуются чаще всего

SELECT payment_method, count(payment_method) AS 'Count payment method'
FROM customer_shopping_data
GROUP BY payment_method
ORDER BY 2 DESC


-- Анализ продаж за методом оплаты

SELECT payment_method AS 'Метод оплаты', 
		sum(quantity) AS 'Количество товаров',
		round(sum(Profit), 2) AS 'Доход', 
		sum(Profit) / (SELECT sum(Profit) FROM customer_shopping_data) * 100 AS 'Частка дохода'
FROM customer_shopping_data
GROUP BY payment_method
ORDER BY 4 DESC

-----------------------------------------------------------------------

-- АНАЛИЗ ЗА ПЕРИОДОМ
----------------------

-- Анализ продаж по месяцам

SELECT 
	   year(invoice_date) AS 'Год', month(invoice_date) AS 'Месяц', 
	   sum(quantity) AS 'Количество товаров',
	   round(sum(quantity * price), 2) AS 'Доход'
FROM customer_shopping_data
GROUP BY year(invoice_date), month(invoice_date)
ORDER BY 1, 2 

SELECT top 12
	   month(invoice_date) AS 'Месяц', 
	   sum(quantity) AS 'Количество товаров',
	   round(sum(quantity * price), 2) AS 'Доход'
FROM customer_shopping_data
WHERE invoice_date BETWEEN '2021-01-01' AND '2022-12-31' -- Сокращено, поскольку данные 2023 года только за январь-март
GROUP BY month(invoice_date)
ORDER BY 3 desc

-- 10 дней с наибольшими продажами

SELECT TOP 10
		invoice_date AS 'Дата', 
		sum(quantity) AS 'Количество',
		round(sum(quantity * price), 2) AS 'Доход'
FROM customer_shopping_data
GROUP BY invoice_date
ORDER BY 3 DESC


-- 10 дней с наименьшими продажами

SELECT TOP 10
		invoice_date AS 'Дата', 
		sum(quantity) AS 'Количество',
		round(sum(quantity * price), 2) AS 'Доход'
FROM customer_shopping_data
GROUP BY invoice_date
ORDER BY 3 ASC
