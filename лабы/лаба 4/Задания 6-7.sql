use UNIVER

 --������� 6
 --������ ������� ������ � ��������������
SELECT PULPIT.PULPIT_NAME, ISNULL (TEACHER.TEACHER_NAME, '***') [�������������]
FROM PULPIT LEFT OUTER JOIN TEACHER
ON PULPIT.PULPIT = TEACHER.PULPIT

--������� 7
--�������� ������� ������ � ��������� LEFT OUTER JOIN
SELECT PULPIT.PULPIT_NAME, ISNULL (TEACHER.TEACHER_NAME, '***') [�������������]
FROM TEACHER LEFT OUTER JOIN PULPIT
ON PULPIT.PULPIT = TEACHER.PULPIT
--���������� ������ ����� �������, ����� ��������� ����������� ���������, �� ����������� ���������� ������ RIGHT OUTER JOIN
SELECT PULPIT.PULPIT_NAME, ISNULL (TEACHER.TEACHER_NAME, '***') [�������������]
FROM TEACHER RIGHT OUTER JOIN PULPIT
ON PULPIT.PULPIT = TEACHER.PULPIT

