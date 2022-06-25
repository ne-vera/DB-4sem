USE UNIVER
GO

--1
/*Разработать представление с именем Преподаватель. 
Представление должно быть построено на основе SELECT-запроса к таблице TEACHER и содержать следующие столбцы:
код (TEACHER), 
имя преподавателя (TEACHER_NAME), 
пол (GENDER), 
код кафедры (PULPIT). */

--drop view [Преподаватель]

CREATE VIEW [Преподаватель]
as select TEACHER.TEACHER [Код],
		TEACHER.TEACHER_NAME [Имя преподавателя],
		TEACHER.GENDER [Пол],
		TEACHER.PULPIT [Код кафедры] from TEACHER;
GO
select * from [Преподаватель]

--2
/*Разработать и создать представление с именем Количество кафедр. 
Представление должно быть построено на основе SELECT-запроса к таблицам FACULTY и PULPIT.
Представление должно содержать следующие столбцы: 
факультет (FACULTY.FACULTY_ NAME), 
количество кафедр (вычисляется на основе строк таблицы PULPIT). 
*/
--drop view [Количество кафедр]
go
CREATE VIEW [Количество кафедр]
as SELECT FACULTY.FACULTY_NAME [Факультет],
COUNT(*) [Количество кафдер]
from FACULTY inner join PULPIT
on FACULTY.FACULTY=PULPIT.FACULTY
group by FACULTY_NAME
GO

select * from [Количество кафедр]
--3
/*Разработать и создать представление с именем Аудитории. 
Представление должно быть построено на основе таблицы AUDITORIUM и содержать столбцы: 
код (AUDITORIUM), 
наименование аудитории (AUDITORIUM_NAME). 
Представление должно отображать только лекционные аудитории (в столбце AUDITORIUM_ TYPE строка, начинающаяся с символа ЛК) 
и допускать выполнение оператора INSERT, UPDATE и DELETE.
*/
--drop view  Аудитории
go
CREATE VIEW Аудитории (AUDITORIUM, AUDITORIUM_NAME)
as select AUDITORIUM.AUDITORIUM [код],
AUDITORIUM.AUDITORIUM_NAME [наименование аудитории]
from AUDITORIUM
where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%'
GO

SELECT * FROM Аудитории

INSERT Аудитории values (303-1, 303-1)
UPDATE Аудитории set [AUDITORIUM_NAME]='000-0' where [AUDITORIUM]='236-1'

--4
/*Разработать и создать представление с именем Лекционные_аудитории. 
Представление должно быть построено на основе SELECT-запроса к таблице AUDITORIUM и содержать следующие столбцы:
код (AUDITORIUM), 
наименование аудитории (AUDITORIUM_NAME). 
Представление должно отображать только лекционные аудитории (в столбце AUDITORIUM_TYPE строка, начинающаяся с символов ЛК). 
Выполнение INSERT и UPDATE допускает-ся, но с учетом ограничения, задаваемого оп-цией WITH CHECK OPTION. 
*/
--drop view Лекционные_аудитории
go
CREATE VIEW Лекционные_аудитории (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE)
as select AUDITORIUM [код], 
AUDITORIUM_NAME [наименование аудитории],
AUDITORIUM_TYPE [ТИП]
from AUDITORIUM
where AUDITORIUM_TYPE like 'ЛК%' WITH CHECK OPTION;
GO
select * from Лекционные_аудитории
--INSERT
INSERT Лекционные_аудитории  values ('333-1', '33-1', 'ЛБ-К')
update Лекционные_аудитории set [AUDITORIUM_NAME]=0 where AUDITORIUM='236-1'
update Лекционные_аудитории set [AUDITORIUM_NAME]=0 where AUDITORIUM='301-1'

--5
/*Разработать представление с именем Дисциплины. 
Представление должно быть построено на основе SELECT-запроса к таблице SUBJECT, 
отображать все дисциплины в алфавитном порядке и содержать следующие столбцы: 
код (SUBJECT), 
наименование дисциплины (SUBJECT_NAME),
код кафедры (PULPIT). 
Использовать TOP и ORDER BY.*/
--drop view Дисциплины
go
CREATE VIEW Дисциплины
as select TOP 10 SUBJECT [код], 
SUBJECT_NAME [наименование дисциплины],
PULPIT [код кафедры]
from SUBJECT
ORDER BY SUBJECT
GO
Select * from Дисциплины
--6
/*Изменить представление Количество_кафедр, 
созданное в задании 2 так, чтобы оно было привязано к базовым таблицам. 
Продемонстрировать свойство привязанности представления к базовым таблицам. 
Примечание: использовать опцию SCHEMABINDING.*/
go

alter view [Количество кафедр] with schemabinding
	as select
		f.FACULTY_NAME  [Название факультета],
		count(p.PULPIT) [Кафедры]
	from dbo.FACULTY as f 
		join dbo.PULPIT as p on p.FACULTY = f.FACULTY
	group by f.FACULTY_NAME;
go

select * from [Количество кафедр]
--8
/*Разработать представление для таблицы TIMETABLE (лабораторная работа 6) в виде расписания. 
Изучить оператор PIVOT и использовать его.*/

SELECT AUDITORIUM, [1] as [8.00-9.35], [2] as [9.50-11.25],
[3] as [11.40-13.15], [4] as [13.50-15.25]
from TIMETABLE
pivot (count (SUBJECT) for TIMETABLE.LESSON in ([1], [2], [3], [4])) pvt;