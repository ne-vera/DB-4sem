USE UNIVER
GO

--1
/*Разработать представление с именем Преподаватель. 
Представление должно быть построено на основе SELECT-запроса к таблице TEACHER и содержать следующие столбцы:
код (TEACHER), 
имя преподавателя (TEACHER_NAME), 
пол (GENDER), 
код кафедры (PULPIT). */
CREATE VIEW [Преподаватель]
as select TEACHER.TEACHER [Код],
		TEACHER.TEACHER_NAME [Имя преподавателя],
		TEACHER.GENDER [Пол],
		TEACHER.PULPIT [Код кафедры] from TEACHER;
GO
--2
/*Разработать и создать представление с именем Количество кафедр. 
Представление должно быть построено на основе SELECT-запроса к таблицам FACULTY и PULPIT.
Представление должно содержать следующие столбцы: 
факультет (FACULTY.FACULTY_ NAME), 
количество кафедр (вычисляется на основе строк таблицы PULPIT). 
*/

CREATE VIEW [Количество кафедр]
as SELECT FACULTY.FACULTY_NAME [Факультет],
COUNT(*) [Количество кафдер]
from FACULTY inner join PULPIT
on FACULTY.FACULTY=PULPIT.FACULTY
group by FACULTY_NAME
GO
--3
/*Разработать и создать представление с именем Аудитории. 
Представление должно быть построено на основе таблицы AUDITORIUM и содержать столбцы: 
код (AUDITORIUM), 
наименование аудитории (AUDITORIUM_NAME). 
Представление должно отображать только лекционные аудитории (в столбце AUDITORIUM_ TYPE строка, начинающаяся с символа ЛК) 
и допускать выполнение оператора INSERT, UPDATE и DELETE.
*/

CREATE VIEW Аудитории (AUDITORIUM, AUDITORIUM_NAME)
as select AUDITORIUM.AUDITORIUM,
AUDITORIUM.AUDITORIUM_NAME
from AUDITORIUM
where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%'
GO

SELECT * FROM Аудитории

INSERT Аудитории values('200-3а', '200-3а')
INSERT Аудитории values('303-1', '303-1')
