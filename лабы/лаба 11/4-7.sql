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
select @@SPID, 'update AUDITORIUM' 'результат', * from AUDITORIUM
--t2--
--B--
begin transaction
select @@SPID
insert AUDITORIUM values ('26-1', 'ЛК', 80, '206-1')
update AUDITORIUM set AUDITORIUM='26-1'
					where AUDITORIUM='26-1'
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
									;
select @@SPID, 'update AUDITORIUM' 'результат', * from AUDITORIUM
									where AUDITORIUM.AUDITORIUM = '26-1';
commit;
--t2--
--B--
begin transaction
select @@SPID
insert AUDITORIUM values ('216-1', 'ЛК', 80, '26-1')
update AUDITORIUM set AUDITORIUM='26-1'
					where AUDITORIUM='26-1'
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
    update AUDITORIUM set AUDITORIUM_NAME = '26-1' where AUDITORIUM = '26-1'
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