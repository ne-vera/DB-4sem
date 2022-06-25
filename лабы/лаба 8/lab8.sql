--1
/*1. ����������� T-SQL-������, � �������: 

-�������� ����� �������� ���������� ������� � ������� ��������� SELECT, 
�������� ������ �������� ���������� ����������� � ������� ��������� PRINT. 
���������������� ����������.
*/
---�������� ���������� ���� 
--char 
---������ ��� ���������� ������������������� � ��������� ����������;
DECLARE @hello char(5)='Hello',
--varchar
		@world varchar(5)='world',

--datetime
		@date datetime,
--time
		@timestamp time,

--int
		@i int,
--smallint
		@smalli smallint,
--numeric
		@num numeric(12,5);

--��������� ������������ �������� ��������� ���� ���������� � ������� ��������� SET
SET @date=GETDATE();
SET @timestamp='13:13:13';

--����� �� ���� ���������� ��������� ��������, ���������� � ���������� ������� SELECT; 
--���������� ���������� ��������� ��������� �������� � ������� ��������� SELECT;
SELECT @i = (select count(*) from GROUPS),
		@smalli = (select cast(COUNT(*) as smallint) from GROUPS where PROFESSION LIKE '1-40 01 02')
--���� �� ���������� �������� ��� ������������� � �� ����������� �� ��������
--numeric
SELECT @hello 'char', @world 'varchar', @date 'datetime', @timestamp 'time'
print 'int i='+cast(@i as varchar(5));
print 'smallint smalli='+cast(@smalli as varchar(5));
print 'numeric num='+cast(@num as varchar(5));

--2
/*����������� ������, � ������� ������������ ����� ����������� ���������. 
����� ����� ����������� ��������� 200, 
�� ������� ���������� ���������, 
������� ����������� ���������, 
���������� ���������, ����������� ������� ������ �������,
� ������� ����� ���������. 
����� ����� ����������� ��������� ������ 200, �� ������� ��������� � ������� ����� �����������*/
DECLARE @capacity int = (select SUM(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM),
@avg int, @below_avg int, @percent real
IF @capacity>200
begin
SELECT @avg=(select cast(AVG(AUDITORIUM.AUDITORIUM_CAPACITY) as int) from AUDITORIUM),
	@below_avg=(select count(*) from AUDITORIUM where AUDITORIUM_CAPACITY < (select cast(AVG(AUDITORIUM.AUDITORIUM_CAPACITY) as int) from AUDITORIUM) ),
	@percent = (100*@below_avg)/(select count(*) from AUDITORIUM)
SELECT @capacity '����� �����������', @avg '������� �����������',
		@below_avg '���������� ���������, ����������� ������� ������ �������',
		@percent '������� ����� ���������'
end
else IF @capacity<200 print '����� ����������� ' + cast(@capacity as varchar(3))

--3
/*3.	����������� T-SQL-������, ������� ������� �� ������ ���������� ����������: 
@@ROWCOUNT (����� ������������ �����); 
@@VERSION (������ SQL Server);
@@SPID (���������� ��������� ������������� ��������, ��������-��� �������� �������� ��������-���); 
@@ERROR (��� ��������� ������); 
@@SERVERNAME (��� �������); 
@@TRANCOUNT (���������� ������� ����������� ����������); 
@@FETCH_STATUS (�������� ���������� ���������� ����� ��������������� ������); 
@@NESTLEVEL (������� ����������� ������� ���������).
���������������� ���������.
*/
print '����� ������������ ����� ' + cast(@@rowcount as varchar(3));
print '������ SQL Server ' + cast(@@version as varchar(10));
print '������������� ��������, ����������� �������� �������� ����������� ' + cast(@@SPID as varchar(10));
print '��� ��������� ������ ' + cast(@@ERROR as varchar(10));
print '��� ������� ' + cast(@@SERVERNAME as varchar(15));
print '������� ����������� ���������� ' + cast(@@TRANCOUNT as varchar(10));
print '�������� ���������� ���������� ����� ��������������� ������ ' + cast(@@FETCH_STATUS as varchar(10));
print '������� ����������� ������� ��������� ' + cast(@@NESTLEVEL as varchar(10));

--4
/*���������� ���������� z ��� ��������� �������� �������� ������;*/
DECLARE @t int = 1, @x int = 2, @z float
	IF (@t>@x) SET @z=POWER(SIN(@t),2) 
	else IF (@t<@x) SET @z=4*(@t+@x)
	else SET @z=1-EXP(@x-1);
Print '@z= ' + cast(@z as varchar(10))

/*�������������� ������� ��� �������� � ����������� 
(��������, �������� ������� ���������� � �������� �. �.);*/
DECLARE @name varchar(50) = (select top 1 STUDENT.NAME from STUDENT)
SET @name=SUBSTRING(@name, 0, CHARINDEX(' ', @name)+1)
+SUBSTRING(@name, CHARINDEX(' ', @name)+1, 1) +'.'
+SUBSTRING(@name, CHARINDEX(' ', @name)+1, 1) +'.'
print @name

/*����� ���������, � ������� ���� �������� � ��������� ������,
� ����������� �� ��������;*/
DECLARE @nextmonth int = month(DATEADD(MONTH, 1, GETDATE()))
select STUDENT.NAME, DATEDIFF(year, STUDENT.BDAY, GETDATE())
from STUDENT
where
month(STUDENT.BDAY)= @nextmonth

/*����� ��� ������, � ������� �������� ��������� ������ ������� ������� �� ����.*/
DECLARE @group integer = 5
DECLARE @dow nvarchar(20)
SET @dow = (select top 1 DATENAME(DW,PROGRESS.PDATE)
from PROGRESS inner join STUDENT
on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
where PROGRESS.SUBJECT='����' and STUDENT.IDGROUP=@group)
print @dow

--5
/*. ������������������ ����������� IF� ELSE �� ������� ������� ������ ������ ���� ������ �_UNIVER.*/

DECLARE @am int = (select count(*) FROM STUDENT)
if(@am>100)
begin
PRINT '���������� ��������� ������ 100' 
PRINT '���������� ���������=' + cast(@am as varchar(3));
end;
ELSE
begin
PRINT '���������� ��������� ������ 100';
PRINT '���������� ��������� = ' + cast(@am as varchar(3));
end;

--6
/*����������� ��������, � ������� � ������� CASE ������������� ������, ���������� ���������� ���������� ���������� ��� ����� ���������.*/
SELECT COUNT(*), 
CASE 
			when PROGRESS.NOTE  between 0 and 3 then '�������������������'
			when PROGRESS.NOTE between 4 and 5 then '�����'
			when PROGRESS.NOTE between 6 and 8 then '������'
			else '�������'
			end
FROM PROGRESS
GROUP BY CASE
when PROGRESS.NOTE  between 0 and 3 then '�������������������'
			when PROGRESS.NOTE between 4 and 5 then '�����'
			when PROGRESS.NOTE between 6 and 8 then '������'
			else '�������'
			end

--7
/*������� ��������� ��������� ������� �� ���� �������� � 10 �����, ��������� �� � ������� ����������. 
������������ �������� WHILE*/

CREATE table #table
(
num float,
phrase varchar(20),
currentdate datetime
)
set nocount on
declare @i_c int = 1;
while @i_c < 10
begin
insert #table(num, phrase, currentdate)
	values(floor(3000*rand()), 'hello, world!', GETDATE())
	set @i_c = @i_c+1;
	end;
select * from #table
--8
/*����������� ������, ��������������� ������������� ��������� RETURN. */
declare @s_m float =3.5
print @s_m +0.5
print @s_m +1
return
print @s_m +1.5
--9
/*����������� �������� � ��������, � ������� ������������ ��� ��������� ������ ����� TRY � CATCH. 
��������� ������� ERROR_NUMBER (��� ��������� ������), 
ERROR_MESSAGE (��������� �� ������), 
ERROR_LINE (��� ��������� ������), 
ERROR_PROCEDURE (��� ��������� ��� NULL), 
ERROR_SEVERITY (������� ����������� ������), 
ERROR_ STATE (����� ������). �
��������������� ���������.*/

begin try
declare @er int = 1
set @er = @er / 0
end try

begin catch
print 'ERROR!'
print 'Error number:    ' + cast(ERROR_NUMBER() as varchar(100))
print 'Error severity:  ' + cast(ERROR_SEVERITY() as varchar(100))
print 'Error line:      ' + cast(ERROR_LINE() as varchar(100))
print 'Error state:     ' + cast(ERROR_STATE() as varchar(100))
print 'Error message:   ' + cast(ERROR_MESSAGE() as varchar(100))
end catch