use UNIVER
go

--1
/*1. На основе таблицы AUDITORIUM разработать SELECT-запрос, 
вычисляющий максимальную, 
минимальную
и среднюю вместимость аудиторий, 
суммарную вместимость всех аудиторий 
и общее количество аудиторий. */

SELECT max(AUDITORIUM.AUDITORIUM_CAPACITY) [Максимальная вместимость],
		min(AUDITORIUM.AUDITORIUM_CAPACITY) [Минимальная вместимость],
		avg(AUDITORIUM.AUDITORIUM_CAPACITY) [Средняя вместимость],
		sum(AUDITORIUM.AUDITORIUM_CAPACITY) [Суммарная вместимость всех],
		COUNT(*) [Общее количество]
FROM AUDITORIUM

--2
/*На основе таблиц AUDITORIUM и AUDI-TORIUM_TYPE разработать запрос, 
вычисляющий для каждого типа аудиторий максимальную, 
минимальную, 
среднюю вместимость аудиторий, 
суммарную вме-стимость всех аудиторий 
и общее количе-ство аудиторий данного типа.

Результирующий набор должен содер-жать столбец с наименованием типа аудиторий (столбец AUDITORIUM_TYPE.AU-DITORIUM_TYPENAME) 
и столбцы с вычисленными величинами. 
Использовать внутреннее соединение таблиц, секцию GROUP BY и агрегатные функции. 
*/
SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,
		max(AUDITORIUM.AUDITORIUM_CAPACITY) [Максимальная вместимость],
		min(AUDITORIUM.AUDITORIUM_CAPACITY) [Минимальная вместимость],
		avg(AUDITORIUM.AUDITORIUM_CAPACITY) [Средняя вместимость],
		sum(AUDITORIUM.AUDITORIUM_CAPACITY) [Суммарная вместимость всех],
		COUNT(*) [Общее количество]
FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE
GROUP BY AUDITORIUM_TYPE.AUDITORIUM_TYPENAME

--3
/*Разработать запрос на основе таблицы PROGRESS, который содержит количество экзаменационных оценок в заданном интервале. 
При этом учесть, что сортировка строк должна осуществляться в порядке, обратном величине оценки; 
сумма значений в столбце количество должна быть равна количеству строк в таблице PROGRESS. 
Использовать подзапрос в секции FROM, в подзапросе применить GROUP BY, сор-тировку осуществить во внешнем запросе. В секции GROUP BY, в SELECT-списке подзапроса и в ORDER BY внешнего запро-са применить CASE. 
*/

SELECT *
FROM (select Case when PROGRESS.NOTE between 4 and 5 then '4-5'
				when PROGRESS.NOTE between 6 and 7 then '6-7'
				when PROGRESS.NOTE between 8 and 9 then '8-9'
				when PROGRESS.NOTE = 10 then '10'
				end [Оценки],
				count(*) [Количество]
FROM PROGRESS
Group by Case
				when PROGRESS.NOTE between 4 and 5 then '4-5'
				when PROGRESS.NOTE between 6 and 7 then '6-7'
				when PROGRESS.NOTE between 8 and 9 then '8-9'
				when PROGRESS.NOTE = 10 then '10'
				end
		) as G
		ORDER BY Case [Оценки]
				when '6-7' then 3
				when '8-9' then 2
				when '4-5' then 4
				when '10' then 1
				end

--4
/*Разработать SELECT-запроса на основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS, 
который содержит среднюю экзаменационную оценку для каждого курса каждой специальности. 
Строки отсортировать в порядке убывания средней оценки.
При этом следует учесть, что средняя оценка должна рассчитываться с точностью до двух знаков после запятой. 
Использовать внутреннее соединение таблиц, агрегатную функцию AVG и встроенные функции CAST и ROUND..
*/

SELECT FACULTY.FACULTY, 
		GROUPS.PROFESSION, 
		(2014 - GROUPS.YEAR_FIRST) [Курс],
		round(avg(cast(PROGRESS.NOTE as float(4))),2) [Средняя оценка]
FROM FACULTY full join GROUPS
	on FACULTY.FACULTY=GROUPS.FACULTY
	full join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	full join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
HAVING (GROUPS.YEAR_FIRST is not null and GROUPS.PROFESSION is not null)
ORDER BY [Средняя оценка] DESC

/*
Переписать SELECT-запрос, разработан-ный в задании 4 так, чтобы в расчете среднего значения оценок использовались оценки только по дисциплинам с кодами БД и ОАиП. 
Использовать WHERE*/
SELECT FACULTY.FACULTY, 
		GROUPS.PROFESSION, 
		(2014 - GROUPS.YEAR_FIRST) [Курс],
round(avg(cast(PROGRESS.NOTE as float(4))),2) [Средняя оценка]
FROM FACULTY full join GROUPS
	on FACULTY.FACULTY=GROUPS.FACULTY
	full join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	full join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE PROGRESS.SUBJECT in ('СУБД','ОАиП')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
HAVING (GROUPS.YEAR_FIRST is not null and GROUPS.PROFESSION is not null)
ORDER BY [Средняя оценка] DESC

--5
/*На основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS разработать SELECT-запрос,
в котором выводятся специальность, 
дисциплины и средние оценки при сдаче экзаменов на факультете ТОВ. 
Использовать группировку по полям FACULTY, PROFESSION, SUBJECT.
*/
SELECT GROUPS.PROFESSION,
		PROGRESS.SUBJECT,
		avg(PROGRESS.NOTE) [Средняя оценка]
FROM FACULTY inner join GROUPS
	on FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT 
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE FACULTY.FACULTY='ИДиП'
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT

/*Добавить в запрос конструкцию ROLLUP и проанализировать результат. 
*/
SELECT GROUPS.PROFESSION,
	PROGRESS.SUBJECT,
	avg(PROGRESS.NOTE) [Средняя оценка]
FROM FACULTY inner join GROUPS
	on FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT 
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE FACULTY.FACULTY LIKE'ИДиП'
GROUP BY ROLLUP (FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT)

--6
/*Выполнить исходный SELECT-запрос п.5 с использованием CUBE-группировки*/
SELECT GROUPS.PROFESSION,
		PROGRESS.SUBJECT,
		avg(PROGRESS.NOTE) [Средняя оценка]
FROM FACULTY inner join GROUPS
	on FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT 
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE FACULTY.FACULTY LIKE 'ИДиП'
GROUP BY CUBE (FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT)

--7
/*На основе таблиц GROUPS, STUDENT и PROGRESS разработать SELECT-запрос, в котором определяются результаты сдачи экзаменов.
В запросе должны отражаться специальности, дисциплины, средние оценки студентов на факультете ТОВ.*/
/*Отдельно разработать запрос, в котором определяются результаты сдачи экзаменов на факультете ХТиТ.*/
/*Объединить результаты двух запросов с использованием операторов UNION и UNION ALL. Объяснить результаты. */
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [Средняя оценка]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE 'ИДиП'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
UNION
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [Средняя оценка]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE 'ИДиП'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT


SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [Средняя оценка]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
	WHERE GROUPS.FACULTY LIKE 'ИДиП'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
UNION ALL
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [Средняя оценка]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE 'ИДиП'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

--8
/*Получить пересечение двух множеств строк, созданных в результате выполнения запросов пункта 8. Объяснить результат.
Использовать оператор INTERSECT.*/

SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [Средняя оценка]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE 'ТОВ'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
UNION
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [Средняя оценка]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE 'ХТиТ'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
INTERSECT
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [Средняя оценка]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
	WHERE GROUPS.FACULTY LIKE 'ТОВ'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
UNION ALL
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [Средняя оценка]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE 'ХТиТ'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

--9
/*Получить разницу между множеством строк, созданных в результате запросов пункта 8.
 Объяснить результат. 
Использовать оператор EXCEPT.*/

SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [Средняя оценка]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE 'ТОВ'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
UNION
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [Средняя оценка]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE 'ХТиТ'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
EXCEPT
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [Средняя оценка]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
	WHERE GROUPS.FACULTY LIKE 'ТОВ'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
UNION ALL
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [Средняя оценка]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE 'ХТиТ'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

--10
/*На основе таблицы PROGRESS определить для каждой дисциплины количество студентов, получивших оценки 8 и 9. 
Использовать группировку, секцию HAVING, сортировку. 
*/
SELECT PROGRESS.SUBJECT, count(*)
FROM PROGRESS
GROUP BY PROGRESS.SUBJECT, PROGRESS.NOTE
HAVING PROGRESS.NOTE IN (8,9)
ORDER BY PROGRESS.SUBJECT DESC


--12
/*Подсчитать количество студентов в каждой группе, на каждом факультете и всего в университете одним запросом.*/
SELECT DISTINCT FACULTY.FACULTY, GROUPS.IDGROUP, count(STUDENT.IDSTUDENT) as [Количество студентов]
FROM FACULTY full join GROUPS on GROUPS.FACULTY=FACULTY.FACULTY
full join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
GROUP BY ROLLUP (FACULTY.FACULTY, GROUPS.IDGROUP)

/*Подсчитать количество аудиторий по типам и суммарной вместимости в корпусах и всего одним запросом*/
SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPE, COUNT(AUDITORIUM.AUDITORIUM) as [Количетсво аудиторий], SUM(AUDITORIUM.AUDITORIUM_CAPACITY) as [Суммарная вместимость]
FROM AUDITORIUM_TYPE inner join AUDITORIUM on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE
GROUP BY ROLLUP (AUDITORIUM_TYPE.AUDITORIUM_TYPE)