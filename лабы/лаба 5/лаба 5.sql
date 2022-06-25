use UNIVER

--1
/*1. �� ������ ������ FACULTY, PULPIT � PROFESSION ������������ ������ ������������ ������ (������� PULPIT_NAME), 
������� ��������� �� ���������� (������� FACULTY), �������������� ���������� �� �������������, 
� ������������ (������� PROFESSION_NAME) �������� ���������� ����� ���������� ��� ����������. 
����������: ������������ � ������ WHERE �������� IN c ����������������� ����������� � ������� PROFESSION. */
SELECT PULPIT.PULPIT_NAME
FROM PULPIT, FACULTY
WHERE PULPIT.FACULTY=FACULTY.FACULTY
and
FACULTY.FACULTY in (Select PROFESSION.FACULTY FROM PROFESSION 
						Where (PROFESSION_NAME Like '%����������%' 
								OR PROFESSION_NAME Like '%����������%'))

--2
/*
2. ���������� ������ ������ 1 ����� �������, 
����� ��� �� ��������� ��� ������� � ����������� INNER JOIN ������ FROM �������� �������. 
��� ���� ��������� ���������� ������� ������ ���� ����������� ���������� ��������� �������. 
*/
SELECT PULPIT.PULPIT_NAME
FROM PULPIT INNER JOIN FACULTY
ON PULPIT.FACULTY=FACULTY.FACULTY
WHERE
FACULTY.FACULTY in (Select PROFESSION.FACULTY FROM PROFESSION 
						Where (PROFESSION_NAME Like '%����������%' 
								OR PROFESSION_NAME Like '%����������%'))

--3
/*3. ���������� ������, ����������� 1 ����� ��� ������������� ����������. 
����������: ������������ ���������� INNER JOIN ���� ������. */
SELECT Distinct PULPIT.PULPIT_NAME
FROM PULPIT 
INNER JOIN FACULTY ON PULPIT.FACULTY=FACULTY.FACULTY
INNER JOIN PROFESSION ON PULPIT.FACULTY=PROFESSION.FACULTY 
Where (PROFESSION_NAME Like '%����������%' OR PROFESSION_NAME Like '%����������%')

--4
/*4. �� ������ ������� AUDITORIUM ������������ ������ ��������� ����� ������� ������������ 
(������� AUDITORIUM_CAPACITY) ��� ������� ���� ��������� (AUDITORIUM_TYPE). 
��� ���� ��������� ������� ������������� � ������� �������� �����������. 
����������: ������������ ������������� ��������� c �������� TOP � ORDER BY*/
SELECT AUDITORIUM_TYPE, AUDITORIUM_CAPACITY
FROM AUDITORIUM a
Where AUDITORIUM_CAPACITY = (select top(1) AUDITORIUM_CAPACITY from AUDITORIUM aa
Where a.AUDITORIUM_TYPE=aa.AUDITORIUM_TYPE
order by AUDITORIUM_CAPACITY desc)
order by AUDITORIUM_CAPACITY desc

--5
/*5. �� ������ ������ FACULTY � PULPIT ������������ ������ ������������ ����������� (������� FACULTY_NAME), �� ������� ��� �� ����� ������� (������� PULPIT). 
����������: ������������ �������� EXISTS � ��������������� ���������. */
SELECT FACULTY.FACULTY_NAME
FROM FACULTY 
Where not exists (Select PULPIT.PULPIT from PULPIT
		Where FACULTY.FACULTY=PULPIT.FACULTY)

--6
/*6. �� ������ ������� PROGRESS ������������ ������, ���������� ������� �������� ������ (������� NOTE) �� �����������, ������� ��������� ����: ����, �� � ����. 
����������: ������������ ��� ����������������� ���������� � ������ SELECT; 
� ����������� ��������� ���������� ������� AVG. */
SELECT top 1
	(select avg (NOTE) from PROGRESS
				where PROGRESS.SUBJECT like '����') [����],
	(select avg (NOTE) from PROGRESS
				where PROGRESS.SUBJECT like '��') [��],
	(select avg (NOTE) from PROGRESS
				where PROGRESS.SUBJECT like '����') [����]

--7
/* ����������� SELECT-������, ��������������� ������� ���������� ALL ��������� � �����������.*/
SELECT SUBJECT, NOTE from PROGRESS
Where NOTE >=all
(select NOTE from PROGRESS
where SUBJECT like '�%')

--8
/*8. ����������� SELECT-������, ��������������� ������� ���������� ANY ��������� � �����������.*/
SELECT SUBJECT, NOTE from PROGRESS
Where NOTE >any
(select NOTE from PROGRESS
where SUBJECT like '�%')

--10
/*����� � ������� STUDENT ���������, � ������� ���� �������� � ���� ����. 
��������� �������.*/
SELECT distinct a.NAME, a.BDAY
	FROM STUDENT a inner join STUDENT b
	on a.BDAY=b.BDAY and a.IDSTUDENT!=b.IDSTUDENT
	order by BDAY
