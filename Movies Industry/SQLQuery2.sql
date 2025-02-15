SELECT *
FROM [Project7 - Movies].[dbo].[movies]


---------------------------------------------------------

ALTER TABLE [Project7 - Movies].[dbo].[movies]
ALTER COLUMN score FLOAT

UPDATE [Project7 - Movies].[dbo].[movies]
SET score = CONVERT(FLOAT, score)


ALTER TABLE [Project7 - Movies].[dbo].[movies]
ALTER COLUMN year INT

UPDATE [Project7 - Movies].[dbo].[movies]
SET year = CONVERT(INT, year)
---------------------------------------------------------

-- ��������� ����������� 

SELECT distinct rating
FROM [Project7 - Movies].[dbo].[movies]


-- ������ ������� �� ���������� ������������

SELECT rating, COUNT(rating) AS '# of movies',
	   round(AVG(score),1) AS 'avg score', 
	   round(avg(votes),2) AS 'avg votes', 
	   round(avg(budget),2) AS 'avg budget', 
	   round(avg(gross),2) AS 'avg gross', 
	   round(AVG(runtime),2) AS 'avg runtime'
FROM [Project7 - Movies].[dbo].[movies]
GROUP BY rating
ORDER BY 2 desc

---------------------------------------------------------

-- �����

SELECT distinct genre
FROM [Project7 - Movies].[dbo].[movies]


-- ������ ������� �� ������

SELECT genre, COUNT(genre) AS '# of movies', 
	   round(AVG(score),1) AS 'avg score', 
	   round(avg(votes),2) AS 'avg votes', 
	   round(avg(budget),2) AS 'avg budget', 
	   round(avg(gross),2) AS 'avg gross', 
	   round(AVG(runtime),2) AS 'avg runtime'
FROM [Project7 - Movies].[dbo].[movies]
GROUP BY genre
ORDER BY 2 desc

-------------------------------------------------------------

-- ���� ������

SELECT distinct year
FROM [Project7 - Movies].[dbo].[movies]
ORDER BY year


-- ������ ������� �� ���� ������

SELECT year, COUNT(year) AS '# of movies',
	   round(AVG(score),1) AS 'avg score', 
	   round(avg(votes),2) AS 'avg votes', 
	   round(avg(budget),2) AS 'avg budget', 
	   round(avg(gross),2) AS 'avg gross', 
	   round(AVG(runtime),2) AS 'avg runtime'
FROM [Project7 - Movies].[dbo].[movies]
GROUP BY year
ORDER BY 6 desc, 1 asc

-------------------------------------------------------------

-- ���������

SELECT distinct director
FROM [Project7 - Movies].[dbo].[movies]
ORDER BY director


-- ������ ������� �� ���������

SELECT director, COUNT(director) AS '# of movies',
	   round(AVG(score),1) AS 'avg score', 
	   round(avg(votes),2) AS 'avg votes', 
	   round(avg(budget),2) AS 'avg budget', 
	   round(avg(gross),2) AS 'avg gross', 
	   round(AVG(runtime),2) AS 'avg runtime'
FROM [Project7 - Movies].[dbo].[movies]
GROUP BY director
ORDER BY 6 desc

-------------------------------------------------------------

-- ����������

SELECT distinct writer
FROM [Project7 - Movies].[dbo].[movies]
ORDER BY writer


-- ������ ������� �� ����������

SELECT writer, COUNT(writer) AS '# of movies',
	   round(AVG(score),1) AS 'avg score', 
	   round(avg(votes),2) AS 'avg votes', 
	   round(avg(budget),2) AS 'avg budget', 
	   round(avg(gross),2) AS 'avg gross', 
	   round(AVG(runtime),2) AS 'avg runtime'
FROM [Project7 - Movies].[dbo].[movies]
GROUP BY writer
ORDER BY 2 desc, 1 asc

--------------------------------------------------------------

-- ������� ����

SELECT distinct star
FROM [Project7 - Movies].[dbo].[movies]
ORDER BY star


-- ������ ������� �� ������� �����

SELECT star, COUNT(star) AS '# of movies',
	   round(AVG(score),1) AS 'avg score', 
	   round(avg(votes),2) AS 'avg votes', 
	   round(avg(budget),2) AS 'avg budget', 
	   round(avg(gross),2) AS 'avg gross', 
	   round(AVG(runtime),2) AS 'avg runtime'
FROM [Project7 - Movies].[dbo].[movies]
GROUP BY star
ORDER BY 2 desc, 1 asc

------------------------------------------------------------

-- ������

SELECT distinct country
FROM [Project7 - Movies].[dbo].[movies]
ORDER BY country


-- ������ ������� �� ������

SELECT country, COUNT(country) AS '# of movies',
	   round(AVG(score),1) AS 'avg score', 
	   round(avg(votes),2) AS 'avg votes', 
	   round(avg(budget),2) AS 'avg budget', 
	   round(avg(gross),2) AS 'avg gross', 
	   round(AVG(runtime),2) AS 'avg runtime'
FROM [Project7 - Movies].[dbo].[movies]
GROUP BY country
ORDER BY 2 desc, 1 asc

------------------------------------------------------------


-- ��������

SELECT distinct company
FROM [Project7 - Movies].[dbo].[movies]
ORDER BY company


-- ������ ������� �� ������������

SELECT company, COUNT(company) AS '# of movies',
	   round(AVG(score),1) AS 'avg score', 
	   round(avg(votes),2) AS 'avg votes', 
	   round(avg(budget),2) AS 'avg budget', 
	   round(avg(gross),2) AS 'avg gross', 
	   round(AVG(runtime),2) AS 'avg runtime'
FROM [Project7 - Movies].[dbo].[movies]
GROUP BY company
ORDER BY 2 desc, 1 asc



SELECT star, year,
	   avg(score) AS 'AVG Score',
	   avg(votes) AS 'AVG Votes',
	   count([year]) over (partition by star order by star, [year]) AS 'Group',
	   count([year]) AS 'Count Films',
	   count(year) over (partition by  star) AS 'Total films'
FROM [Project7 - Movies].[dbo].[movies]
GROUP BY star, year
ORDER BY 1 asc, 2 asc, 5 asc