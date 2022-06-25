use UNIVER
go

--1
/*1. �� ������ ������� AUDITORIUM ����������� SELECT-������, 
����������� ������������, 
�����������
� ������� ����������� ���������, 
��������� ����������� ���� ��������� 
� ����� ���������� ���������. */

SELECT max(AUDITORIUM.AUDITORIUM_CAPACITY) [������������ �����������],
		min(AUDITORIUM.AUDITORIUM_CAPACITY) [����������� �����������],
		avg(AUDITORIUM.AUDITORIUM_CAPACITY) [������� �����������],
		sum(AUDITORIUM.AUDITORIUM_CAPACITY) [��������� ����������� ����],
		COUNT(*) [����� ����������]
FROM AUDITORIUM

--2
/*�� ������ ������ AUDITORIUM � AUDI-TORIUM_TYPE ����������� ������, 
����������� ��� ������� ���� ��������� ������������, 
�����������, 
������� ����������� ���������, 
��������� ���-�������� ���� ��������� 
� ����� ������-���� ��������� ������� ����.

�������������� ����� ������ �����-���� ������� � ������������� ���� ��������� (������� AUDITORIUM_TYPE.AU-DITORIUM_TYPENAME) 
� ������� � ������������ ����������. 
������������ ���������� ���������� ������, ������ GROUP BY � ���������� �������. 
*/
SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,
		max(AUDITORIUM.AUDITORIUM_CAPACITY) [������������ �����������],
		min(AUDITORIUM.AUDITORIUM_CAPACITY) [����������� �����������],
		avg(AUDITORIUM.AUDITORIUM_CAPACITY) [������� �����������],
		sum(AUDITORIUM.AUDITORIUM_CAPACITY) [��������� ����������� ����],
		COUNT(*) [����� ����������]
FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE
GROUP BY AUDITORIUM_TYPE.AUDITORIUM_TYPENAME

--3
/*����������� ������ �� ������ ������� PROGRESS, ������� �������� ���������� ��������������� ������ � �������� ���������. 
��� ���� ������, ��� ���������� ����� ������ �������������� � �������, �������� �������� ������; 
����� �������� � ������� ���������� ������ ���� ����� ���������� ����� � ������� PROGRESS. 
������������ ��������� � ������ FROM, � ���������� ��������� GROUP BY, ���-������� ����������� �� ������� �������. � ������ GROUP BY, � SELECT-������ ���������� � � ORDER BY �������� �����-�� ��������� CASE. 
*/

SELECT *
FROM (select Case when PROGRESS.NOTE between 4 and 5 then '4-5'
				when PROGRESS.NOTE between 6 and 7 then '6-7'
				when PROGRESS.NOTE between 8 and 9 then '8-9'
				when PROGRESS.NOTE = 10 then '10'
				end [������],
				count(*) [����������]
FROM PROGRESS
Group by Case
				when PROGRESS.NOTE between 4 and 5 then '4-5'
				when PROGRESS.NOTE between 6 and 7 then '6-7'
				when PROGRESS.NOTE between 8 and 9 then '8-9'
				when PROGRESS.NOTE = 10 then '10'
				end
		) as G
		ORDER BY Case [������]
				when '6-7' then 3
				when '8-9' then 2
				when '4-5' then 4
				when '10' then 1
				end

--4
/*����������� SELECT-������� �� ������ ������ FACULTY, GROUPS, STUDENT � PROGRESS, 
������� �������� ������� ��������������� ������ ��� ������� ����� ������ �������������. 
������ ������������� � ������� �������� ������� ������.
��� ���� ������� ������, ��� ������� ������ ������ �������������� � ��������� �� ���� ������ ����� �������. 
������������ ���������� ���������� ������, ���������� ������� AVG � ���������� ������� CAST � ROUND..
*/

SELECT FACULTY.FACULTY, 
		GROUPS.PROFESSION, 
		(2014 - GROUPS.YEAR_FIRST) [����],
		round(avg(cast(PROGRESS.NOTE as float(4))),2) [������� ������]
FROM FACULTY full join GROUPS
	on FACULTY.FACULTY=GROUPS.FACULTY
	full join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	full join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
HAVING (GROUPS.YEAR_FIRST is not null and GROUPS.PROFESSION is not null)
ORDER BY [������� ������] DESC

/*
���������� SELECT-������, ����������-��� � ������� 4 ���, ����� � ������� �������� �������� ������ �������������� ������ ������ �� ����������� � ������ �� � ����. 
������������ WHERE*/
SELECT FACULTY.FACULTY, 
		GROUPS.PROFESSION, 
		(2014 - GROUPS.YEAR_FIRST) [����],
round(avg(cast(PROGRESS.NOTE as float(4))),2) [������� ������]
FROM FACULTY full join GROUPS
	on FACULTY.FACULTY=GROUPS.FACULTY
	full join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	full join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE PROGRESS.SUBJECT in ('����','����')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.YEAR_FIRST
HAVING (GROUPS.YEAR_FIRST is not null and GROUPS.PROFESSION is not null)
ORDER BY [������� ������] DESC

--5
/*�� ������ ������ FACULTY, GROUPS, STUDENT � PROGRESS ����������� SELECT-������,
� ������� ��������� �������������, 
���������� � ������� ������ ��� ����� ��������� �� ���������� ���. 
������������ ����������� �� ����� FACULTY, PROFESSION, SUBJECT.
*/
SELECT GROUPS.PROFESSION,
		PROGRESS.SUBJECT,
		avg(PROGRESS.NOTE) [������� ������]
FROM FACULTY inner join GROUPS
	on FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT 
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE FACULTY.FACULTY='����'
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT

/*�������� � ������ ����������� ROLLUP � ���������������� ���������. 
*/
SELECT GROUPS.PROFESSION,
	PROGRESS.SUBJECT,
	avg(PROGRESS.NOTE) [������� ������]
FROM FACULTY inner join GROUPS
	on FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT 
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE FACULTY.FACULTY LIKE'����'
GROUP BY ROLLUP (FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT)

--6
/*��������� �������� SELECT-������ �.5 � �������������� CUBE-�����������*/
SELECT GROUPS.PROFESSION,
		PROGRESS.SUBJECT,
		avg(PROGRESS.NOTE) [������� ������]
FROM FACULTY inner join GROUPS
	on FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT 
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE FACULTY.FACULTY LIKE '����'
GROUP BY CUBE (FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT)

--7
/*�� ������ ������ GROUPS, STUDENT � PROGRESS ����������� SELECT-������, � ������� ������������ ���������� ����� ���������.
� ������� ������ ���������� �������������, ����������, ������� ������ ��������� �� ���������� ���.*/
/*�������� ����������� ������, � ������� ������������ ���������� ����� ��������� �� ���������� ����.*/
/*���������� ���������� ���� �������� � �������������� ���������� UNION � UNION ALL. ��������� ����������. */
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [������� ������]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE '����'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
UNION
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [������� ������]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE '����'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT


SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [������� ������]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
	WHERE GROUPS.FACULTY LIKE '����'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
UNION ALL
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [������� ������]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE '����'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

--8
/*�������� ����������� ���� �������� �����, ��������� � ���������� ���������� �������� ������ 8. ��������� ���������.
������������ �������� INTERSECT.*/

SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [������� ������]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE '���'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
UNION
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [������� ������]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE '����'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
INTERSECT
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [������� ������]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
	WHERE GROUPS.FACULTY LIKE '���'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
UNION ALL
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [������� ������]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE '����'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

--9
/*�������� ������� ����� ���������� �����, ��������� � ���������� �������� ������ 8.
 ��������� ���������. 
������������ �������� EXCEPT.*/

SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [������� ������]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE '���'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
UNION
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [������� ������]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE '����'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
EXCEPT
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [������� ������]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
	WHERE GROUPS.FACULTY LIKE '���'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT
UNION ALL
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [������� ������]
FROM GROUPS inner join STUDENT
	on GROUPS.IDGROUP=STUDENT.IDGROUP
	inner join PROGRESS
	on STUDENT.IDSTUDENT=PROGRESS.IDSTUDENT
WHERE GROUPS.FACULTY LIKE '����'
GROUP BY GROUPS.PROFESSION, PROGRESS.SUBJECT

--10
/*�� ������ ������� PROGRESS ���������� ��� ������ ���������� ���������� ���������, ���������� ������ 8 � 9. 
������������ �����������, ������ HAVING, ����������. 
*/
SELECT PROGRESS.SUBJECT, count(*)
FROM PROGRESS
GROUP BY PROGRESS.SUBJECT, PROGRESS.NOTE
HAVING PROGRESS.NOTE IN (8,9)
ORDER BY PROGRESS.SUBJECT DESC


--12
/*���������� ���������� ��������� � ������ ������, �� ������ ���������� � ����� � ������������ ����� ��������.*/
SELECT DISTINCT FACULTY.FACULTY, GROUPS.IDGROUP, count(STUDENT.IDSTUDENT) as [���������� ���������]
FROM FACULTY full join GROUPS on GROUPS.FACULTY=FACULTY.FACULTY
full join STUDENT on GROUPS.IDGROUP=STUDENT.IDGROUP
GROUP BY ROLLUP (FACULTY.FACULTY, GROUPS.IDGROUP)

/*���������� ���������� ��������� �� ����� � ��������� ����������� � �������� � ����� ����� ��������*/
SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPE, COUNT(AUDITORIUM.AUDITORIUM) as [���������� ���������], SUM(AUDITORIUM.AUDITORIUM_CAPACITY) as [��������� �����������]
FROM AUDITORIUM_TYPE inner join AUDITORIUM on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE
GROUP BY ROLLUP (AUDITORIUM_TYPE.AUDITORIUM_TYPE)