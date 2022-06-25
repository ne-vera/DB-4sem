use UNIVER
 
--������� 4
--�� ������ ������ PRORGESS, STUDENT, GROUPS, SUBJECT, PULPIT � FACULTY ������������ �������� ���������, ���������� ��������������� ������ (������� PROGRESS.NOTE) �� 6 �� 8. 
--�������������� ����� ������ ��������� �������: ���������, �������, �������������, ����������, ��� ��������, ������. � ������� ������ ������ ���� �������� ��������������� ������ ��������: �����, ����, ������. 
--�������������� ����� ������������� � ������� ����������� �� �������� FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION, STUDENT. STUDENT_NAME � � ������� �������� �� ������� PROGRESS.NOTE.
-- ������������ ���������� INNER JOIN, �������� BETWEEN � ��������� CASE.

SELECT PROGRESS.NOTE, STUDENT.NAME,GROUPS.IDGROUP, SUBJECT.SUBJECT,PULPIT.PULPIT,FACULTY.FACULTY,
Case
when (PROGRESS.NOTE = 6) then '�����'
when (PROGRESS.NOTE = 7) then '����'
when (PROGRESS.NOTE = 8) then '������'
end [������]
FROM PROGRESS inner join STUDENT 
ON PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT AND PROGRESS.NOTE BETWEEN 6 AND 8
INNER JOIN GROUPS ON STUDENT.IDGROUP =GROUPS.IDGROUP 
INNER JOIN SUBJECT ON PROGRESS.SUBJECT=SUBJECT.SUBJECT
INNER JOIN FACULTY ON GROUPS.FACULTY= FACULTY.FACULTY
INNER JOIN PULPIT ON SUBJECT.PULPIT= PULPIT.PULPIT
ORDER BY PROGRESS.NOTE desc, FACULTY.FACULTY, PULPIT.PULPIT, STUDENT.NAME

--������� 5
--���������� �� ��������������� ������� ���� ���������: ������� ���������� ����-�� � ������� 7, ����� ������ � ������� 8 � ����� ������ � ������� 6
SELECT PROGRESS.NOTE, STUDENT.NAME,GROUPS.IDGROUP, SUBJECT.SUBJECT,PULPIT.PULPIT,FACULTY.FACULTY,
Case
when (PROGRESS.NOTE = 6) then '�����'
when (PROGRESS.NOTE = 7) then '����'
when (PROGRESS.NOTE = 8) then '������'
end [������]
FROM PROGRESS inner join STUDENT
ON PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT AND PROGRESS.NOTE BETWEEN 6 AND 8
INNER JOIN GROUPS ON STUDENT.IDGROUP =GROUPS.IDGROUP 
INNER JOIN SUBJECT ON PROGRESS.SUBJECT=SUBJECT.SUBJECT
INNER JOIN FACULTY ON GROUPS.FACULTY= FACULTY.FACULTY
INNER JOIN PULPIT ON SUBJECT.PULPIT= PULPIT.PULPIT
ORDER BY (case
when (PROGRESS.NOTE =6) then 3
when (PROGRESS.NOTE =7) then 1
when (PROGRESS.NOTE =8) then 2
end)
