use UNIVER

 --Задание 6
 --полный перчень кафедр и преподавателей
SELECT PULPIT.PULPIT_NAME, ISNULL (TEACHER.TEACHER_NAME, '***') [Преподаватель]
FROM PULPIT LEFT OUTER JOIN TEACHER
ON PULPIT.PULPIT = TEACHER.PULPIT

--Задание 7
--поменять порядок таблиц в выражении LEFT OUTER JOIN
SELECT PULPIT.PULPIT_NAME, ISNULL (TEACHER.TEACHER_NAME, '***') [Преподаватель]
FROM TEACHER LEFT OUTER JOIN PULPIT
ON PULPIT.PULPIT = TEACHER.PULPIT
--Переписать запрос таким образом, чтобы получился аналогичный результат, но применялось соединение таблиц RIGHT OUTER JOIN
SELECT PULPIT.PULPIT_NAME, ISNULL (TEACHER.TEACHER_NAME, '***') [Преподаватель]
FROM TEACHER RIGHT OUTER JOIN PULPIT
ON PULPIT.PULPIT = TEACHER.PULPIT

