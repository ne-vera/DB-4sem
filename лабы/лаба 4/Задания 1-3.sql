use UNIVER

--������� 1
--�������� ����� ��������� � ��������������� �� ������������ ����� ���������.
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE

--������� 2
---�������� ����� ��������� � ��������������� �� ������������ ����� ���������, ���������� "���������"
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE AND
AUDITORIUM_TYPE.AUDITORIUM_TYPENAME Like '%���������%'

--������� 3
--SELECT-������, ����������� �������������� ����� ����������� ������� �� ������� 1, �� ��� ���������� INNER JOIN
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM, AUDITORIUM_TYPE
WHERE AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE
--SELECT-������, ����������� �������������� ����� ����������� ������� �� ������� 2, �� ��� ���������� INNER JOIN
--���������� au � aut ������� ����� ����� �������� ������, �������� ����� as �������
SELECT au.AUDITORIUM, aut.AUDITORIUM_TYPENAME
FROM AUDITORIUM au, AUDITORIUM_TYPE aut
WHERE au.AUDITORIUM_TYPE=aut.AUDITORIUM_TYPE AND
aut.AUDITORIUM_TYPENAME Like '%���������%'

