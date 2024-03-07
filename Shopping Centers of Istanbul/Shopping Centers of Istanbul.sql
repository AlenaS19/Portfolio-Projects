
SELECT *
FROM [Project6 - ShoppingMallOfIStanbul].[dbo].[customer_shopping_data]

------------------------------------------------------------------------------------------------------------------

-- �������������� ������
---------------------------

-- ��� ������� quantity �������� �� INT

ALTER TABLE [customer_shopping_data]
ALTER COLUMN quantity INT

UPDATE [customer_shopping_data]
SET quantity = CONVERT(int, quantity)
--------------------------------------
-- ��� ������� price �������� �� FLOAT

ALTER TABLE [customer_shopping_data]
ALTER COLUMN price FLOAT

UPDATE [customer_shopping_data]
SET price = CONVERT(float, price)
----------------------------------
-- ��� ������� invoice_date �������� �� DATE

ALTER TABLE [customer_shopping_data]
ALTER COLUMN invoice_date DATE

UPDATE [customer_shopping_data]
SET invoice_date = CONVERT(date, invoice_date)

------------------------------------------------

-- �������������� �������
--------------------------

-- ���������� ������� Profit - ���-�� ������������� ������� * �� ���� �� ��. ������

ALTER TABLE [customer_shopping_data]
ADD Profit FLOAT

UPDATE [customer_shopping_data]
SET Profit = quantity * price
------------------------------------------------

-- ����� ������� - �������� �������� �� ���������� ������

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

-- ���������� ������� Count ��� �������� ���-�� �����������

ALTER TABLE [customer_shopping_data]
ADD count_cust INT

UPDATE [customer_shopping_data]
SET count_cust = 1			-- �������� � ���� ������, ��� ��� ��� ���������� (ID ����������) ����������
-----------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------

-- (EDA) ����������������� ������ ������ 
-----------------------------------------

-- ���������� ��������

SELECT count(invoice_no) 
FROM customer_shopping_data



-- ���������� ���������� �����������

SELECT count(DISTINCT customer_id) 
FROM customer_shopping_data



-- �������� �� ���������

SELECT invoice_no,
	    count(*)
FROM customer_shopping_data        
GROUP BY invoice_no
HAVING count(*) > 1



-- ������ ��������

SELECT min(invoice_date) AS 'Date First', max(invoice_date) AS 'Date Last'
FROM customer_shopping_data



-- ��������� �������

SELECT DISTINCT category 
FROM customer_shopping_data
ORDER BY category



-- �������� �������� �����������

SELECT min(age) 'Min Age', max(age) AS 'Max age'
FROM customer_shopping_data



-- �������� ������

SELECT DISTINCT shopping_mall
FROM customer_shopping_data
ORDER BY shopping_mall



-- ���� ��������

SELECT DISTINCT payment_method
FROM customer_shopping_data
ORDER BY 1



-- ��������� ������

SELECT count(gender) AS 'Female', (SELECT count(gender) 
									FROM customer_shopping_data
                                    WHERE gender = 'Male') AS 'Male'
FROM customer_shopping_data
WHERE gender = 'Female'


-- �������� ��� (����, ���)

SELECT min(price) 'Min Price', max(price) AS 'Max Price'
FROM customer_shopping_data

--------------------------------------------------------------------------------------------------------------

-- ������
---------------------------------------------------------------------------------------------------------------

-- ����� ������
-----------------
-- ���-�� �������� ������� � ����� �� ���� ������ ����������

SELECT sum(quantity) AS '����������', round(sum(quantity * price), 2) AS '�����'
FROM customer_shopping_data


-- ����� ���� �� ������� ������ ����������� ���� �����

SELECT price, count(price) AS 'Count price'
FROM customer_shopping_data
GROUP BY price
ORDER BY 2 DESC


-- ����� ���-�� ������� �������� ���� ����� 

SELECT quantity, count(quantity) AS 'Count quantity'
FROM customer_shopping_data
GROUP BY quantity
ORDER BY 2 DESC

-------------------------------------------------------------

-- ������ �� �������� �������
------------------------------

-- ����� �������� ����� �������� ���� �����

SELECT shopping_mall, count(shopping_mall) AS 'Count shopping mall'
FROM customer_shopping_data
GROUP BY shopping_mall
ORDER BY 2 DESC


-- ������ ������ �� �������� �������

SELECT shopping_mall AS '����� ������', 
		sum(quantity) AS '���������� �������',
		round(sum(Profit), 2) AS '�����', 
		sum(Profit) / (SELECT sum(Profit) FROM customer_shopping_data) * 100 AS '������ ������'
FROM customer_shopping_data
GROUP BY shopping_mall
ORDER BY 4 DESC


-- ���-�� ����������� � ����������� �� ��������� ������ � ���������� ������

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

-- ������ �� �����������
-------------------------

-- ������ ������ �� ����������� (���-��, �����, ������)

SELECT category AS '���������', 
		sum(quantity) AS '���������� �������',
		round(sum(Profit), 2) AS '�����', 
		sum(Profit) / (SELECT sum(Profit) FROM customer_shopping_data) * 100 AS '������ ������'
FROM customer_shopping_data
GROUP BY category
ORDER BY 4 DESC

----------------------------------------------------------------------------------------

-- ������ �� �������� (+ �������� �� ���������)
-----------------------------------------------

-- ������ ������ �� ��������

SELECT gender AS '������', 
		sum(quantity) AS '���������� �������',
		round(sum(Profit), 2) AS '�����', 
		sum(Profit) / (SELECT sum(Profit) FROM customer_shopping_data) * 100 AS '������ ������'
FROM customer_shopping_data
GROUP BY gender
ORDER BY 4 DESC


-- ���-�� �������� ������� � ����������� �� ��������� � �������

SELECT a.category,
	   sum(CASE WHEN b.gender = 'Female' THEN b.quantity ELSE 0 end) AS 'Female',
       sum(CASE WHEN b.gender = 'Male' THEN b.quantity ELSE 0 end) AS 'Male',
       sum(CASE WHEN b.gender IN ('Female', 'Male') THEN b.quantity ELSE 0 end) AS 'Total'
FROM customer_shopping_data a
INNER JOIN customer_shopping_data b
	ON 	a.invoice_no = b.invoice_no
GROUP BY a.category


-- ������� � ����������� �� ��������� � �������

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

-- ������ �� ���������� ������� (+ �������� �� ������)
------------------------------------------------------

-- ����� ���������� ������ �������� ���� ����� 

SELECT AgeGroup, count(AgeGroup) AS 'Count Age Group'
FROM customer_shopping_data
GROUP BY AgeGroup
ORDER BY 2 DESC


-- ������ ������ �� ���������� ������� (���-��, �����, ������)

SELECT AgeGroup AS '���������� ������', 
		sum(quantity) AS '���������� �������',
		round(sum(Profit), 2) AS '�����', 
		sum(Profit) / (SELECT sum(Profit) FROM customer_shopping_data) * 100 AS '������ ������'
FROM customer_shopping_data
GROUP BY AgeGroup
ORDER BY 4 DESC


-- ���������� ����������� �� ���������� ������� � �������

SELECT a.AgeGroup,
	   sum(CASE WHEN b.gender = 'Male' THEN b.count_cust ELSE 0 end) AS 'Male',
       sum(CASE WHEN b.gender = 'Female' THEN b.count_cust ELSE 0 end) AS 'Female',
	   sum(CASE WHEN b.gender IN ('Male', 'Female') THEN b.count_cust ELSE 0 end) AS 'Total'
FROM customer_shopping_data a
INNER JOIN customer_shopping_data b
	ON 	a.invoice_no = b.invoice_no
GROUP BY a.AgeGroup


-- ������� � ����������� �� ���������� ������ � ������� 

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

-- ������ �� ������� ������
----------------------------

-- ����� ��������� ����� ���������� ���� �����

SELECT payment_method, count(payment_method) AS 'Count payment method'
FROM customer_shopping_data
GROUP BY payment_method
ORDER BY 2 DESC


-- ������ ������ �� ������� ������

SELECT payment_method AS '����� ������', 
		sum(quantity) AS '���������� �������',
		round(sum(Profit), 2) AS '�����', 
		sum(Profit) / (SELECT sum(Profit) FROM customer_shopping_data) * 100 AS '������ ������'
FROM customer_shopping_data
GROUP BY payment_method
ORDER BY 4 DESC

-----------------------------------------------------------------------

-- ������ �� ��������
----------------------

-- ������ ������ �� �������

SELECT 
	   year(invoice_date) AS '���', month(invoice_date) AS '�����', 
	   sum(quantity) AS '���������� �������',
	   round(sum(quantity * price), 2) AS '�����'
FROM customer_shopping_data
GROUP BY year(invoice_date), month(invoice_date)
ORDER BY 1, 2


-- 10 ���� � ����������� ���������

SELECT TOP 10
		invoice_date AS '����', 
		sum(quantity) AS '����������',
		round(sum(quantity * price), 2) AS '�����'
FROM customer_shopping_data
GROUP BY invoice_date
ORDER BY 3 DESC


-- 10 ���� � ����������� ���������

SELECT TOP 10
		invoice_date AS '����', 
		sum(quantity) AS '����������',
		round(sum(quantity * price), 2) AS '�����'
FROM customer_shopping_data
GROUP BY invoice_date
ORDER BY 3 ASC


