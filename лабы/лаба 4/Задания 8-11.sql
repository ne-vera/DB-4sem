use UNIVER	

---������� 8
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


--�������� ������������� ���������;
SELECT * FROM reader FULL OUTER JOIN books
ON reader.ID=books.reader_id

SELECT * FROM books FULL OUTER JOIN reader
ON reader.ID=books.reader_id

--�������� ������������ LEFT OUTER JOIN � RIGHT OUTER JOIN ���������� ���� ������
SELECT * FROM reader LEFT OUTER JOIN books
ON reader.ID=books.reader_id
UNION ALL
SELECT * FROM reader right outer join books
ON reader.ID=books.reader_id
EXCEPT
(SELECT * FROM reader FULL OUTER JOIN books
ON reader.ID=books.reader_id)

--�������� ���������� INNER JOIN ���� ������
SELECT * FROM reader INNER JOIN books
ON reader.ID=books.reader_id
EXCEPT
(SELECT * FROM reader FULL OUTER JOIN books
ON reader.ID=books.reader_id)

--������� ��� ����� �������:
--�������� ������ ����� ������� � �� �������� ������ ������
SELECT PULPIT.FACULTY, PULPIT.PULPIT, PULPIT.PULPIT_NAME
FROM PULPIT FULL OUTER JOIN TEACHER
ON PULPIT.PULPIT = TEACHER.PULPIT
WHERE TEACHER.TEACHER is null

--�������� ������ ������ ������� � �� ���������� ������ �����
SELECT TEACHER.TEACHER_NAME, TEACHER.TEACHER, TEACHER.PULPIT,TEACHER.GENDER
FROM PULPIT FULL OUTER JOIN TEACHER
ON PULPIT.PULPIT=TEACHER.PULPIT
WHERE TEACHER.TEACHER is not null

--�������� ������ ������ ������� � ����� ������
SELECT * FROM PULPIT FULL OUTER JOIN TEACHER
ON PULPIT.PULPIT = TEACHER.PULPIT

---������� 9
-- ����������� ����������, ����������� ��� ���������� ������� � ������� 1
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM CROSS JOIN AUDITORIUM_TYPE
WHERE AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE 

---������� 11 
--������� ������� TIMETABLE (������, ���������, �������, �������������, ���� ������, ����), 
--���������� ����� � ������� ���������, ��������� �������. 
CREATE table TIMETABLE (
DAY_NAME char(2) check (DAY_NAME in('��', '��', '��', '��', '��', '��')),
LESSON integer check(LESSON between 1 and 4),
TEACHER char(10)  constraint TIMETABLE_TEACHER_FK  foreign key references TEACHER(TEACHER),
AUDITORIUM char(20) constraint TIMETABLE_AUDITORIUM_FK foreign key references AUDITORIUM(AUDITORIUM),
SUBJECT char(10) constraint TIMETABLE_SUBJECT_FK  foreign key references SUBJECT(SUBJECT),
IDGROUP integer constraint TIMETABLE_GROUP_FK  foreign key references GROUPS(IDGROUP),
)
INSERT into TIMETABLE values 
('��', 1, '����', '313-1', '����', 15),
('��', 2, '����', '313-1', '����', 4),
('��', 3, '����', '313-1', '����', 11),
('��', 1, '���', '324-1', '����', 6),
('��', 3, '���', '324-1', '���', 4),
('��', 1, '���', '206-1', '���', 10),
('��', 4, '����', '206-1', '����', 3),
('��', 1, '�����', '301-1', '����', 7),
('��', 4, '�����', '301-1', '����', 7),
('��', 2, '�����', '413-1', '����', 8),
('��', 2, '���', '423-1', '����', 7),
('��', 4, '���', '423-1', '����', 15),
('��', 1, '����', '313-1', '����', 15),
('��', 2, '����', '313-1', '����', 4),
('��', 3, '���', '324-1', '���', 4),
('��', 4, '����', '206-1', '����', 3)

--�������� ������� �� ������� ��������� ��������� �� ������������ ����
SELECT AUDITORIUM FROM AUDITORIUM
EXCEPT( SELECT AUDITORIUM.AUDITORIUM
FROM TIMETABLE INNER JOIN AUDITORIUM 
ON AUDITORIUM.AUDITORIUM = TIMETABLE.AUDITORIUM 
AND TIMETABLE.LESSON = 2 )

--�� ������������ ���� ������
SELECT AUDITORIUM FROM AUDITORIUM
EXCEPT( SELECT AUDITORIUM.AUDITORIUM
FROM TIMETABLE  INNER JOIN AUDITORIUM 
ON AUDITORIUM.AUDITORIUM = TIMETABLE.AUDITORIUM
AND TIMETABLE.DAY_NAME = '��');

--������� ����� � �������������� 
SELECT distinct TEACHER.TEACHER_NAME, t.DAY_NAME, t.LESSON
FROM TEACHER, TIMETABLE t
EXCEPT( SELECT distinct TEACHER.TEACHER_NAME, t.DAY_NAME, t.LESSON
FROM TEACHER
INNER JOIN TIMETABLE t ON TEACHER.TEACHER = t.TEACHER);

--������� ����� � �������
SELECT distinct GROUPS.IDGROUP, t.DAY_NAME, t.LESSON
FROM GROUPS, TIMETABLE t
EXCEPT( SELECT distinct GROUPS.IDGROUP, t.DAY_NAME, t.LESSON
FROM GROUPS 
INNER JOIN TIMETABLE t ON GROUPS.IDGROUP = t.IDGROUP) order by IDGROUP