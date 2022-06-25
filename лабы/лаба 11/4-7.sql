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
select @@SPID, 'update AUDITORIUM' '���������', * from AUDITORIUM
--t2--
--B--
begin transaction
select @@SPID
insert AUDITORIUM values ('26-1', '��', 80, '206-1')
update AUDITORIUM set AUDITORIUM='26-1'
					where AUDITORIUM='26-1'
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
									;
select @@SPID, 'update AUDITORIUM' '���������', * from AUDITORIUM
									where AUDITORIUM.AUDITORIUM = '26-1';
commit;
--t2--
--B--
begin transaction
select @@SPID
insert AUDITORIUM values ('216-1', '��', 80, '26-1')
update AUDITORIUM set AUDITORIUM='26-1'
					where AUDITORIUM='26-1'
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
    update AUDITORIUM set AUDITORIUM_NAME = '26-1' where AUDITORIUM = '26-1'
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