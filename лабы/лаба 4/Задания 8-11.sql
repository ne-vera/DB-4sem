use UNIVER	

---Задание 8
CREATE table reader
(ID int primary key, NAME   nvarchar(20))
INSERT into reader 
values (1, 'kgfakgjfk'),
(2, 'asgxgy'),
(3, 'vrshd'),
(4, 'ahthgfaw'),
(5, 'pokjhf')

CREATE table books
(idbook int primary key, reader_id int  foreign key  references reader(id), 
titel nvarchar(20),
author nvarchar(20))
INSERT into books 
values (17657, 1,'War and peace','Tolstoi'),
(98565, 2,'Mumu','Turgenev'),
(88595, 5,'Player','Dostoevski')


--является коммутативной операцией;
SELECT * FROM reader FULL OUTER JOIN books
ON reader.ID=books.reader_id

SELECT * FROM books FULL OUTER JOIN reader
ON reader.ID=books.reader_id

--является объединением LEFT OUTER JOIN и RIGHT OUTER JOIN соединений этих таблиц
SELECT * FROM reader LEFT OUTER JOIN books
ON reader.ID=books.reader_id
UNION ALL
SELECT * FROM reader right outer join books
ON reader.ID=books.reader_id
EXCEPT
(SELECT * FROM reader FULL OUTER JOIN books
ON reader.ID=books.reader_id)

--включает соединение INNER JOIN этих таблиц
SELECT * FROM reader INNER JOIN books
ON reader.ID=books.reader_id
EXCEPT
(SELECT * FROM reader FULL OUTER JOIN books
ON reader.ID=books.reader_id)

--Создать три новых запроса:
--содержит данные левой таблицы и не содержит данные правой
SELECT PULPIT.FACULTY, PULPIT.PULPIT, PULPIT.PULPIT_NAME
FROM PULPIT FULL OUTER JOIN TEACHER
ON PULPIT.PULPIT = TEACHER.PULPIT
WHERE TEACHER.TEACHER is null

--содержит данные правой таблицы и не содержащие данные левой
SELECT TEACHER.TEACHER_NAME, TEACHER.TEACHER, TEACHER.PULPIT,TEACHER.GENDER
FROM PULPIT FULL OUTER JOIN TEACHER
ON PULPIT.PULPIT=TEACHER.PULPIT
WHERE TEACHER.TEACHER is not null

--содержит данные правой таблицы и левой таблиц
SELECT * FROM PULPIT FULL OUTER JOIN TEACHER
ON PULPIT.PULPIT = TEACHER.PULPIT

---Задание 9
-- аналогичный результату, полученному при выполнении запроса в задании 1
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM CROSS JOIN AUDITORIUM_TYPE
WHERE AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE 

---Задание 11 
--Создать таблицу TIMETABLE (Группа, аудитория, предмет, преподаватель, день недели, пара), 
--установить связи с другими таблицами, заполнить данными. 
CREATE table TIMETABLE (
DAY_NAME char(2) check (DAY_NAME in('пн', 'вт', 'ср', 'чт', 'пт', 'сб')),
LESSON integer check(LESSON between 1 and 4),
TEACHER char(10)  constraint TIMETABLE_TEACHER_FK  foreign key references TEACHER(TEACHER),
AUDITORIUM char(20) constraint TIMETABLE_AUDITORIUM_FK foreign key references AUDITORIUM(AUDITORIUM),
SUBJECT char(10) constraint TIMETABLE_SUBJECT_FK  foreign key references SUBJECT(SUBJECT),
IDGROUP integer constraint TIMETABLE_GROUP_FK  foreign key references GROUPS(IDGROUP),
)
INSERT into TIMETABLE values 
('пн', 1, 'СМЛВ', '313-1', 'СУБД', 15),
('пн', 2, 'СМЛВ', '313-1', 'ОАиП', 4),
('пн', 3, 'СМЛВ', '313-1', 'ОАиП', 11),
('ср', 1, 'МРЗ', '324-1', 'СУБД', 6),
('сб', 3, 'УРБ', '324-1', 'ПИС', 4),
('чт', 1, 'УРБ', '206-1', 'ПИС', 10),
('пн', 4, 'СМЛВ', '206-1', 'ОАиП', 3),
('пт', 1, 'БРКВЧ', '301-1', 'СУБД', 7),
('пт', 4, 'БРКВЧ', '301-1', 'ОАиП', 7),
('пн', 2, 'БРКВЧ', '413-1', 'СУБД', 8),
('пн', 2, 'ДТК', '423-1', 'СУБД', 7),
('пн', 4, 'ДТК', '423-1', 'ОАиП', 15),
('вт', 1, 'СМЛВ', '313-1', 'СУБД', 15),
('вт', 2, 'СМЛВ', '313-1', 'ОАиП', 4),
('вт', 3, 'УРБ', '324-1', 'ПИС', 4),
('вт', 4, 'СМЛВ', '206-1', 'ОАиП', 3)

--Написать запросы на наличие свободных аудиторий на определенную пару
SELECT AUDITORIUM FROM AUDITORIUM
EXCEPT( SELECT AUDITORIUM.AUDITORIUM
FROM TIMETABLE INNER JOIN AUDITORIUM 
ON AUDITORIUM.AUDITORIUM = TIMETABLE.AUDITORIUM 
AND TIMETABLE.LESSON = 2 )

--на определенный день недели
SELECT AUDITORIUM FROM AUDITORIUM
EXCEPT( SELECT AUDITORIUM.AUDITORIUM
FROM TIMETABLE  INNER JOIN AUDITORIUM 
ON AUDITORIUM.AUDITORIUM = TIMETABLE.AUDITORIUM
AND TIMETABLE.DAY_NAME = 'ср');

--наличие «окон» у преподавателей 
SELECT distinct TEACHER.TEACHER_NAME, t.DAY_NAME, t.LESSON
FROM TEACHER, TIMETABLE t
EXCEPT( SELECT distinct TEACHER.TEACHER_NAME, t.DAY_NAME, t.LESSON
FROM TEACHER
INNER JOIN TIMETABLE t ON TEACHER.TEACHER = t.TEACHER);

--наличие «окон» в группах
SELECT distinct GROUPS.IDGROUP, t.DAY_NAME, t.LESSON
FROM GROUPS, TIMETABLE t
EXCEPT( SELECT distinct GROUPS.IDGROUP, t.DAY_NAME, t.LESSON
FROM GROUPS 
INNER JOIN TIMETABLE t ON GROUPS.IDGROUP = t.IDGROUP) order by IDGROUP