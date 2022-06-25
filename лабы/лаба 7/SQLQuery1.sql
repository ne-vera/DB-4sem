USE UNIVER
GO

--1
/*����������� ������������� � ������ �������������. 
������������� ������ ���� ��������� �� ������ SELECT-������� � ������� TEACHER � ��������� ��������� �������:
��� (TEACHER), 
��� ������������� (TEACHER_NAME), 
��� (GENDER), 
��� ������� (PULPIT). */
CREATE VIEW [�������������]
as select TEACHER.TEACHER [���],
		TEACHER.TEACHER_NAME [��� �������������],
		TEACHER.GENDER [���],
		TEACHER.PULPIT [��� �������] from TEACHER;
GO
--2
/*����������� � ������� ������������� � ������ ���������� ������. 
������������� ������ ���� ��������� �� ������ SELECT-������� � �������� FACULTY � PULPIT.
������������� ������ ��������� ��������� �������: 
��������� (FACULTY.FACULTY_ NAME), 
���������� ������ (����������� �� ������ ����� ������� PULPIT). 
*/

CREATE VIEW [���������� ������]
as SELECT FACULTY.FACULTY_NAME [���������],
COUNT(*) [���������� ������]
from FACULTY inner join PULPIT
on FACULTY.FACULTY=PULPIT.FACULTY
group by FACULTY_NAME
GO
--3
/*����������� � ������� ������������� � ������ ���������. 
������������� ������ ���� ��������� �� ������ ������� AUDITORIUM � ��������� �������: 
��� (AUDITORIUM), 
������������ ��������� (AUDITORIUM_NAME). 
������������� ������ ���������� ������ ���������� ��������� (� ������� AUDITORIUM_ TYPE ������, ������������ � ������� ��) 
� ��������� ���������� ��������� INSERT, UPDATE � DELETE.
*/

CREATE VIEW ��������� (AUDITORIUM, AUDITORIUM_NAME)
as select AUDITORIUM.AUDITORIUM,
AUDITORIUM.AUDITORIUM_NAME
from AUDITORIUM
where AUDITORIUM.AUDITORIUM_TYPE like '��%'
GO

SELECT * FROM ���������

INSERT ��������� values('200-3�', '200-3�')
INSERT ��������� values('303-1', '303-1')
