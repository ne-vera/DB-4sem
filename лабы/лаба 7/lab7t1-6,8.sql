USE UNIVER
GO

--1
/*����������� ������������� � ������ �������������. 
������������� ������ ���� ��������� �� ������ SELECT-������� � ������� TEACHER � ��������� ��������� �������:
��� (TEACHER), 
��� ������������� (TEACHER_NAME), 
��� (GENDER), 
��� ������� (PULPIT). */

--drop view [�������������]

CREATE VIEW [�������������]
as select TEACHER.TEACHER [���],
		TEACHER.TEACHER_NAME [��� �������������],
		TEACHER.GENDER [���],
		TEACHER.PULPIT [��� �������] from TEACHER;
GO
select * from [�������������]

--2
/*����������� � ������� ������������� � ������ ���������� ������. 
������������� ������ ���� ��������� �� ������ SELECT-������� � �������� FACULTY � PULPIT.
������������� ������ ��������� ��������� �������: 
��������� (FACULTY.FACULTY_ NAME), 
���������� ������ (����������� �� ������ ����� ������� PULPIT). 
*/
--drop view [���������� ������]
go
CREATE VIEW [���������� ������]
as SELECT FACULTY.FACULTY_NAME [���������],
COUNT(*) [���������� ������]
from FACULTY inner join PULPIT
on FACULTY.FACULTY=PULPIT.FACULTY
group by FACULTY_NAME
GO

select * from [���������� ������]
--3
/*����������� � ������� ������������� � ������ ���������. 
������������� ������ ���� ��������� �� ������ ������� AUDITORIUM � ��������� �������: 
��� (AUDITORIUM), 
������������ ��������� (AUDITORIUM_NAME). 
������������� ������ ���������� ������ ���������� ��������� (� ������� AUDITORIUM_ TYPE ������, ������������ � ������� ��) 
� ��������� ���������� ��������� INSERT, UPDATE � DELETE.
*/
--drop view  ���������
go
CREATE VIEW ��������� (AUDITORIUM, AUDITORIUM_NAME)
as select AUDITORIUM.AUDITORIUM [���],
AUDITORIUM.AUDITORIUM_NAME [������������ ���������]
from AUDITORIUM
where AUDITORIUM.AUDITORIUM_TYPE like '��%'
GO

SELECT * FROM ���������

INSERT ��������� values (303-1, 303-1)
UPDATE ��������� set [AUDITORIUM_NAME]='000-0' where [AUDITORIUM]='236-1'

--4
/*����������� � ������� ������������� � ������ ����������_���������. 
������������� ������ ���� ��������� �� ������ SELECT-������� � ������� AUDITORIUM � ��������� ��������� �������:
��� (AUDITORIUM), 
������������ ��������� (AUDITORIUM_NAME). 
������������� ������ ���������� ������ ���������� ��������� (� ������� AUDITORIUM_TYPE ������, ������������ � �������� ��). 
���������� INSERT � UPDATE ���������-��, �� � ������ �����������, ����������� ��-���� WITH CHECK OPTION. 
*/
--drop view ����������_���������
go
CREATE VIEW ����������_��������� (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE)
as select AUDITORIUM [���], 
AUDITORIUM_NAME [������������ ���������],
AUDITORIUM_TYPE [���]
from AUDITORIUM
where AUDITORIUM_TYPE like '��%' WITH CHECK OPTION;
GO
select * from ����������_���������
--INSERT
INSERT ����������_���������  values ('333-1', '33-1', '��-�')
update ����������_��������� set [AUDITORIUM_NAME]=0 where AUDITORIUM='236-1'
update ����������_��������� set [AUDITORIUM_NAME]=0 where AUDITORIUM='301-1'

--5
/*����������� ������������� � ������ ����������. 
������������� ������ ���� ��������� �� ������ SELECT-������� � ������� SUBJECT, 
���������� ��� ���������� � ���������� ������� � ��������� ��������� �������: 
��� (SUBJECT), 
������������ ���������� (SUBJECT_NAME),
��� ������� (PULPIT). 
������������ TOP � ORDER BY.*/
--drop view ����������
go
CREATE VIEW ����������
as select TOP 10 SUBJECT [���], 
SUBJECT_NAME [������������ ����������],
PULPIT [��� �������]
from SUBJECT
ORDER BY SUBJECT
GO
Select * from ����������
--6
/*�������� ������������� ����������_������, 
��������� � ������� 2 ���, ����� ��� ���� ��������� � ������� ��������. 
������������������ �������� ������������� ������������� � ������� ��������. 
����������: ������������ ����� SCHEMABINDING.*/
go

alter view [���������� ������] with schemabinding
	as select
		f.FACULTY_NAME  [�������� ����������],
		count(p.PULPIT) [�������]
	from dbo.FACULTY as f 
		join dbo.PULPIT as p on p.FACULTY = f.FACULTY
	group by f.FACULTY_NAME;
go

select * from [���������� ������]
--8
/*����������� ������������� ��� ������� TIMETABLE (������������ ������ 6) � ���� ����������. 
������� �������� PIVOT � ������������ ���.*/

SELECT AUDITORIUM, [1] as [8.00-9.35], [2] as [9.50-11.25],
[3] as [11.40-13.15], [4] as [13.50-15.25]
from TIMETABLE
pivot (count (SUBJECT) for TIMETABLE.LESSON in ([1], [2], [3], [4])) pvt;