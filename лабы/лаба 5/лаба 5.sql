use UNIVER

--1
/*1. На основе таблиц FACULTY, PULPIT и PROFESSION сформировать список наименований кафедр (столбец PULPIT_NAME), 
которые находятся на факультете (таблица FACULTY), обеспечивающем подготовку по специальности, 
в наименовании (столбец PROFESSION_NAME) которого содержится слово технология или технологии. 
Примечание: использовать в секции WHERE предикат IN c некоррелированным подзапросом к таблице PROFESSION. */
SELECT PULPIT.PULPIT_NAME
FROM PULPIT, FACULTY
WHERE PULPIT.FACULTY=FACULTY.FACULTY
and
FACULTY.FACULTY in (Select PROFESSION.FACULTY FROM PROFESSION 
						Where (PROFESSION_NAME Like '%технология%' 
								OR PROFESSION_NAME Like '%технологии%'))

--2
/*
2. Переписать запрос пункта 1 таким образом, 
чтобы тот же подзапрос был записан в конструкции INNER JOIN секции FROM внешнего запроса. 
При этом результат выполнения запроса должен быть аналогичным результату исходного запроса. 
*/
SELECT PULPIT.PULPIT_NAME
FROM PULPIT INNER JOIN FACULTY
ON PULPIT.FACULTY=FACULTY.FACULTY
WHERE
FACULTY.FACULTY in (Select PROFESSION.FACULTY FROM PROFESSION 
						Where (PROFESSION_NAME Like '%технология%' 
								OR PROFESSION_NAME Like '%технологии%'))

--3
/*3. Переписать запрос, реализующий 1 пункт без использования подзапроса. 
Примечание: использовать соединение INNER JOIN трех таблиц. */
SELECT Distinct PULPIT.PULPIT_NAME
FROM PULPIT 
INNER JOIN FACULTY ON PULPIT.FACULTY=FACULTY.FACULTY
INNER JOIN PROFESSION ON PULPIT.FACULTY=PROFESSION.FACULTY 
Where (PROFESSION_NAME Like '%технология%' OR PROFESSION_NAME Like '%технологии%')

--4
/*4. На основе таблицы AUDITORIUM сформировать список аудиторий самых больших вместимостей 
(столбец AUDITORIUM_CAPACITY) для каждого типа аудитории (AUDITORIUM_TYPE). 
При этом результат следует отсортировать в порядке убывания вместимости. 
Примечание: использовать коррелируемый подзапрос c секциями TOP и ORDER BY*/
SELECT AUDITORIUM_TYPE, AUDITORIUM_CAPACITY
FROM AUDITORIUM a
Where AUDITORIUM_CAPACITY = (select top(1) AUDITORIUM_CAPACITY from AUDITORIUM aa
Where a.AUDITORIUM_TYPE=aa.AUDITORIUM_TYPE
order by AUDITORIUM_CAPACITY desc)
order by AUDITORIUM_CAPACITY desc

--5
/*5. На основе таблиц FACULTY и PULPIT сформировать список наименований факультетов (столбец FACULTY_NAME), на котором нет ни одной кафедры (таблица PULPIT). 
Примечание: использовать предикат EXISTS и коррелированный подзапрос. */
SELECT FACULTY.FACULTY_NAME
FROM FACULTY 
Where not exists (Select PULPIT.PULPIT from PULPIT
		Where FACULTY.FACULTY=PULPIT.FACULTY)

--6
/*6. На основе таблицы PROGRESS сформировать строку, содержащую средние значения оценок (столбец NOTE) по дисциплинам, имеющим следующие коды: ОАиП, БД и СУБД. 
Примечание: использовать три некоррелированных подзапроса в списке SELECT; 
в подзапросах применить агрегатные функции AVG. */
SELECT top 1
	(select avg (NOTE) from PROGRESS
				where PROGRESS.SUBJECT like 'ОАиП') [ОАиП],
	(select avg (NOTE) from PROGRESS
				where PROGRESS.SUBJECT like 'БД') [БД],
	(select avg (NOTE) from PROGRESS
				where PROGRESS.SUBJECT like 'СУБД') [СУБД]

--7
/* Разработать SELECT-запрос, демонстрирующий принцип применения ALL совместно с подзапросом.*/
SELECT SUBJECT, NOTE from PROGRESS
Where NOTE >=all
(select NOTE from PROGRESS
where SUBJECT like 'О%')

--8
/*8. Разработать SELECT-запрос, демонстрирующий принцип применения ANY совместно с подзапросом.*/
SELECT SUBJECT, NOTE from PROGRESS
Where NOTE >any
(select NOTE from PROGRESS
where SUBJECT like 'О%')

--10
/*Найти в таблице STUDENT студентов, у которых день рождения в один день. 
Объяснить решение.*/
SELECT distinct a.NAME, a.BDAY
	FROM STUDENT a inner join STUDENT b
	on a.BDAY=b.BDAY and a.IDSTUDENT!=b.IDSTUDENT
	order by BDAY
