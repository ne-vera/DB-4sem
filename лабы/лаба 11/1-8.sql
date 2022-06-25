

--1
/*����������� ��������, ��������������� ������ � ������ ������� ����������.
���������������� ������, ����������� ������, � ������� ��������� ������� �, � ������� �������� ��� ������ �������.
*/
if exists (select * from sys.objects where object_id = object_id('dbo.X'))
	drop table X

set nocount on
declare @count int, @flag varchar = 'c'
set implicit_transactions on
create table X(num int)
insert X values (1), (2), (3)
set @count = (select count(*) from X)
print '���������� ����� � ������� �: ' + cast(@count as varchar)
if @flag = 'c' 
	commit
else
	rollback
set implicit_transactions off

if exists (select * from sys.objects where object_id = object_id('dbo.X'))
	print '������� � ����'
else
	print '������� � ���'

--2
/*. ����������� ��������, ��������������� �������� ����������� ����� ���������� �� ������� ���� ������ X_UNIVER. 
� ����� CATCH ������������� ������ ��������������� ��������� �� �������. 
���������� ������ �������� ��� ������������� ��������� ���������� ����������� ������.
*/
use UNIVER
go

begin try
	begin tran
		delete from AUDITORIUM where AUDITORIUM = '123-1'
		insert into AUDITORIUM values('test0', '��-�', 40, 'test1')
		insert into AUDITORIUM values('test0', '��', 50, 'test2')
	commit tran
end try
begin catch
	print '������!' + error_message()
	if @@TRANCOUNT > 0
		rollback tran
end catch

go
--3
/*����������� ��������, ��������������� ���������� ��������� SAVE TRAN �� ������� ���� ������ X_UNIVER. 
� ����� CATCH ������������� ������ ��������������� ��������� �� �������. 
���������� ������ �������� ��� ������������� ��������� ����������� ����� � ��������� ���������� ����������� ���-���.
*/
declare @point varchar(3)

begin try
	begin tran
		delete from AUDITORIUM where AUDITORIUM = '123-1'
		set @point = 'p1'; save tran @point
		insert into AUDITORIUM values('test1', '��-�', 40, 'test1')
		set @point = 'p2'; save tran @point
		insert into AUDITORIUM values('test1', '��', 50, 'test2')
		set @point = 'p3'; save tran @point
	commit tran
end try
begin catch
	print '������! ' + error_message()
	if @@TRANCOUNT > 0
	begin
		print '����������� �����: ' + cast(@point as varchar)
		rollback tran @point
		commit tran
	end
end catch

--4
/*4. ����������� ��� �������� A � B �� ������� ���� ������ X_UNIVER. 
�������� A ������������ ����� ����� ���������� � ������� ��������������� READ UNCOMMITED, �������� B � ����� ���������� � ������� ��������������� READ COMMITED (�� ���������). 
�������� A ������ ���������������, ��� ������� READ UNCOMMITED ��������� ����������������, ��������������� � ��������� ������. 
*/

--A--

set transaction isolation level READ UNCOMMITTED 
begin transaction 
--t1---
select @@SPID, 'insert AUDITORIUM' '���������', * from AUDITORIUM;
select @@SPID, 'update AUDITORIUM' '���������', * from AUDITORIUM;
--t2--
--B--
begin transaction
select @@SPID
insert AUDITORIUM values ('266-1', '��', 80, '206-1')
update AUDITORIUM set AUDITORIUM='266-1'
					where AUDITORIUM='266-1'
--t1--
--t2---
rollback

--5
/*����������� ��� �������� A � B �� ������� ���� ������ X_UNIVER. 
�������� A � �  ������������ ����� ����� ���������� � ������� ��������������� READ COMMITED. 
�������� A ������ ���������������, ��� ������� READ COMMITED �� ��������� ����������������� ������, �� ��� ���� �������� ���������-������ � ��������� ������
*/
--A--

set transaction isolation level READ COMMITTED 
begin transaction 
--t1---
select @@SPID, 'insert AUDITORIUM' '���������', * from AUDITORIUM
									where AUDITORIUM.AUDITORIUM = '26-1';
select @@SPID, 'update AUDITORIUM' '���������', * from AUDITORIUM
									where AUDITORIUM.AUDITORIUM = '26-1';
commit;
--t2--
--B--
begin transaction
select @@SPID
insert AUDITORIUM values ('226-1', '��', 80, '226-1')
update AUDITORIUM set AUDITORIUM='226-1'
					where AUDITORIUM='226-1'
--t1--
--t2---
rollback

--6
/*6. ����������� ��� �������� A � B �� ������� ���� ������ X_UNIVER. 
�������� A ������������ ����� ����� ���������� � ������� ��������������� REPEATABLE READ. �������� B � ����� ���������� � ������� ��������������� READ COMMITED. 
�������� A ������ ���������������, ��� ������� REAPETABLE READ �� ��������� ����������������� ������ � ���������������� ������, �� ��� ���� �������� ��������� ������. 
*/
set transaction isolation level  REPEATABLE READ 
begin transaction 
select AUDITORIUM_CAPACITY from AUDITORIUM where AUDITORIUM = '26-1'
-- t1 ---
-- t2 ---
select case
       when AUDITORIUM_CAPACITY = 50 then 'insert'  else ' ' 
end '���������', AUDITORIUM from AUDITORIUM where AUDITORIUM = '26-1'
commit

-- B ---	
begin transaction 	  
--- t1 --
insert AUDITORIUM values ('26-1', '��', 10, '26-1');
commit

--t2 ---

--7
/*����������� ��� �������� A � B �� ������� ���� ������ X_UNIVER. 
�������� A ������������ ��-��� ����� ���������� � ����-��� ��������������� SERIAL-IZABLE. 
�������� B � ����� �������-��� � ������� ������������-��� READ COMMITED.
�������� A ������ �����-���������� ���������� ������-����, ����������������� � ��-�������������� ������
*/
set transaction isolation level SERIALIZABLE 
begin transaction 
	delete AUDITORIUM where AUDITORIUM = '26-1'
    insert AUDITORIUM values ('26-1', '��', 10, '26-1')
    update AUDITORIUM set AUDITORIUM_NAME = '206-1' where AUDITORIUM = '26-1'
    select AUDITORIUM from AUDITORIUM where AUDITORIUM = '26-1'
-- t1 ---
	select AUDITORIUM from AUDITORIUM where AUDITORIUM = '26-1'
---t2 --
commit 	

--- B ---	
begin transaction 	  
	delete AUDITORIUM where AUDITORIUM_NAME = '26-1'; 
    insert AUDITORIUM values ('26-1', '��', 10, '��')
    update AUDITORIUM set AUDITORIUM_NAME = '26-1' where AUDITORIUM = '26-1'
    select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '26-1'
-- t1 ---
commit
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '26-1'
---t2 --

--8
/*����������� ��������, ��������������� �������� ��������� ����������, �� ������� ���� ������ X_UNIVER. */
begin tran
	insert AUDITORIUM_TYPE values ('��-�', '��� ���������');
	begin tran
		update AUDITORIUM set AUDITORIUM = '206-1' where AUDITORIUM_TYPE = '��'
		commit
		if @@TRANCOUNT > 0 rollback
	select
		(select count(*) from AUDITORIUM where AUDITORIUM_TYPE='��-�') '���������',
		(select count(*) from AUDITORIUM_TYPE  where AUDITORIUM_TYPE='��-�') '����'