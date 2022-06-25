

--1
/*Разработать сценарий, демонстрирующий работу в режиме неявной транзакции.
Проанализировать пример, приведенный справа, в котором создается таблица Х, и создать сценарий для другой таблицы.
*/
if exists (select * from sys.objects where object_id = object_id('dbo.X'))
	drop table X

set nocount on
declare @count int, @flag varchar = 'c'
set implicit_transactions on
create table X(num int)
insert X values (1), (2), (3)
set @count = (select count(*) from X)
print 'Количество строк в таблице Х: ' + cast(@count as varchar)
if @flag = 'c' 
	commit
else
	rollback
set implicit_transactions off

if exists (select * from sys.objects where object_id = object_id('dbo.X'))
	print 'таблица Х есть'
else
	print 'таблицы Х нет'

--2
/*. Разработать сценарий, демонстрирующий свойство атомарности явной транзакции на примере базы данных X_UNIVER. 
В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. 
Опробовать работу сценария при использовании различных операторов модификации таблиц.
*/
use UNIVER
go

begin try
	begin tran
		delete from AUDITORIUM where AUDITORIUM = '123-1'
		insert into AUDITORIUM values('test0', 'ЛБ-К', 40, 'test1')
		insert into AUDITORIUM values('test0', 'ЛК', 50, 'test2')
	commit tran
end try
begin catch
	print 'Ошибка!' + error_message()
	if @@TRANCOUNT > 0
		rollback tran
end catch

go
--3
/*Разработать сценарий, демонстрирующий применение оператора SAVE TRAN на примере базы данных X_UNIVER. 
В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. 
Опробовать работу сценария при использовании различных контрольных точек и различных операторов модификации таб-лиц.
*/
declare @point varchar(3)

begin try
	begin tran
		delete from AUDITORIUM where AUDITORIUM = '123-1'
		set @point = 'p1'; save tran @point
		insert into AUDITORIUM values('test1', 'ЛБ-К', 40, 'test1')
		set @point = 'p2'; save tran @point
		insert into AUDITORIUM values('test1', 'ЛК', 50, 'test2')
		set @point = 'p3'; save tran @point
	commit tran
end try
begin catch
	print 'Ошибка! ' + error_message()
	if @@TRANCOUNT > 0
	begin
		print 'Контрольная точка: ' + cast(@point as varchar)
		rollback tran @point
		commit tran
	end
end catch

--4
/*4. Разработать два сценария A и B на примере базы данных X_UNIVER. 
Сценарий A представляет собой явную транзакцию с уровнем изолированности READ UNCOMMITED, сценарий B – явную транзакцию с уровнем изолированности READ COMMITED (по умолчанию). 
Сценарий A должен демонстрировать, что уровень READ UNCOMMITED допускает неподтвержденное, неповторяющееся и фантомное чтение. 
*/

--A--

set transaction isolation level READ UNCOMMITTED 
begin transaction 
--t1---
select @@SPID, 'insert AUDITORIUM' 'результат', * from AUDITORIUM;
select @@SPID, 'update AUDITORIUM' 'результат', * from AUDITORIUM;
--t2--
--B--
begin transaction
select @@SPID
insert AUDITORIUM values ('266-1', 'ЛК', 80, '206-1')
update AUDITORIUM set AUDITORIUM='266-1'
					where AUDITORIUM='266-1'
--t1--
--t2---
rollback

--5
/*Разработать два сценария A и B на примере базы данных X_UNIVER. 
Сценарии A и В  представляют собой явные транзакции с уровнем изолированности READ COMMITED. 
Сценарий A должен демонстрировать, что уровень READ COMMITED не допускает неподтвержденного чтения, но при этом возможно неповторя-ющееся и фантомное чтение
*/
--A--

set transaction isolation level READ COMMITTED 
begin transaction 
--t1---
select @@SPID, 'insert AUDITORIUM' 'результат', * from AUDITORIUM
									where AUDITORIUM.AUDITORIUM = '26-1';
select @@SPID, 'update AUDITORIUM' 'результат', * from AUDITORIUM
									where AUDITORIUM.AUDITORIUM = '26-1';
commit;
--t2--
--B--
begin transaction
select @@SPID
insert AUDITORIUM values ('226-1', 'ЛК', 80, '226-1')
update AUDITORIUM set AUDITORIUM='226-1'
					where AUDITORIUM='226-1'
--t1--
--t2---
rollback

--6
/*6. Разработать два сценария A и B на примере базы данных X_UNIVER. 
Сценарий A представляет собой явную транзакцию с уровнем изолированности REPEATABLE READ. Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED. 
Сценарий A должен демонстрировать, что уровень REAPETABLE READ не допускает неподтвержденного чтения и неповторяющегося чтения, но при этом возможно фантомное чтение. 
*/
set transaction isolation level  REPEATABLE READ 
begin transaction 
select AUDITORIUM_CAPACITY from AUDITORIUM where AUDITORIUM = '26-1'
-- t1 ---
-- t2 ---
select case
       when AUDITORIUM_CAPACITY = 50 then 'insert'  else ' ' 
end 'результат', AUDITORIUM from AUDITORIUM where AUDITORIUM = '26-1'
commit

-- B ---	
begin transaction 	  
--- t1 --
insert AUDITORIUM values ('26-1', 'ЛК', 10, '26-1');
commit

--t2 ---

--7
/*Разработать два сценария A и B на примере базы данных X_UNIVER. 
Сценарий A представляет со-бой явную транзакцию с уров-нем изолированности SERIAL-IZABLE. 
Сценарий B – явную транзак-цию с уровнем изолированно-сти READ COMMITED.
Сценарий A должен демон-стрировать отсутствие фантом-ного, неподтвержденного и не-повторяющегося чтения
*/
set transaction isolation level SERIALIZABLE 
begin transaction 
	delete AUDITORIUM where AUDITORIUM = '26-1'
    insert AUDITORIUM values ('26-1', 'ЛК', 10, '26-1')
    update AUDITORIUM set AUDITORIUM_NAME = '206-1' where AUDITORIUM = '26-1'
    select AUDITORIUM from AUDITORIUM where AUDITORIUM = '26-1'
-- t1 ---
	select AUDITORIUM from AUDITORIUM where AUDITORIUM = '26-1'
---t2 --
commit 	

--- B ---	
begin transaction 	  
	delete AUDITORIUM where AUDITORIUM_NAME = '26-1'; 
    insert AUDITORIUM values ('26-1', 'ЛК', 10, 'ЛК')
    update AUDITORIUM set AUDITORIUM_NAME = '26-1' where AUDITORIUM = '26-1'
    select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '26-1'
-- t1 ---
commit
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '26-1'
---t2 --

--8
/*Разработать сценарий, демонстрирующий свойства вложенных транзакций, на примере базы данных X_UNIVER. */
begin tran
	insert AUDITORIUM_TYPE values ('ЛК-С', 'для вложенной');
	begin tran
		update AUDITORIUM set AUDITORIUM = '206-1' where AUDITORIUM_TYPE = 'ЛБ'
		commit
		if @@TRANCOUNT > 0 rollback
	select
		(select count(*) from AUDITORIUM where AUDITORIUM_TYPE='ЛК-С') 'АУДИТОРИИ',
		(select count(*) from AUDITORIUM_TYPE  where AUDITORIUM_TYPE='ЛК-С') 'ТИПЫ'