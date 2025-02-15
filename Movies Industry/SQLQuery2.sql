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

-- Возратные ограничения 

SELECT distinct rating
FROM [Project7 - Movies].[dbo].[movies]


-- анализ фильмов по возрастным ограничениям

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

-- Жанры

SELECT distinct genre
FROM [Project7 - Movies].[dbo].[movies]


-- анализ фильмов по жанрам

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

-- года релиза

SELECT distinct year
FROM [Project7 - Movies].[dbo].[movies]
ORDER BY year


-- Анализ фильмов по году релиза

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

-- Режиссеры

SELECT distinct director
FROM [Project7 - Movies].[dbo].[movies]
ORDER BY director


-- Анализ фильмов по Режиссеру

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

-- сценаристы

SELECT distinct writer
FROM [Project7 - Movies].[dbo].[movies]
ORDER BY writer


-- Анализ фильмов по сценаристу

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

-- главная роль

SELECT distinct star
FROM [Project7 - Movies].[dbo].[movies]
ORDER BY star


-- Анализ фильмов по главной ролью

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

-- страна

SELECT distinct country
FROM [Project7 - Movies].[dbo].[movies]
ORDER BY country


-- Анализ фильмов по стране

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


-- компания

SELECT distinct company
FROM [Project7 - Movies].[dbo].[movies]
ORDER BY company


-- Анализ фильмов по кинокомпании

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