--1
/*С помощью сценария, представленного на ри-сунке, создать таблицу TR_AUDIT.*/

create table TR_AUDIT
(
	ID int identity(1, 1),										-- ID
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),		-- DML operator name
	TRNAME varchar(50),											-- trigger name
	CC varchar(300)												-- comment
)

/*Разработать AFTER-триггер с именем TR_TEACHER_INS для таблицы TEACHER, 
реагирующий на событие INSERT. 
Триггер должен записывать строки вводимых данных в таблицу TR_AUDIT. 
В столбец СС помеща-ются значения столбцов вводимой строки. */
go

create trigger TR_TEACHER_INS on teacher after insert
as declare @teacher varchar(10), @teacher_name varchar(50),
			@gender char(1), @pulpit varchar(10), @in varchar(300)
print 'Операция вставки: '
set @teacher = (select TEACHER from inserted)
set @teacher_name = (select TEACHER_NAME from inserted)
set @gender = (select GENDER from inserted)
set @pulpit = (select PULPIT from inserted)
set @in = LTRIM(rtrim(@teacher)) + ' ' + LTRIM(rtrim(@teacher_name)) +
			' ' + LTRIM(rtrim(@gender)) + ' ' + LTRIM(rtrim(@pulpit))
insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TRACHER_INS', @in)

go

insert into TEACHER values ('ИВИИ', 'Иванов Иван Иванович', 'м', 'ИСиТ')
select * from TR_AUDIT order by ID

--2
/*Создать AFTER-триггер с именем TR_TEACHER_DEL для таблицы TEACHER, 
реагирующий на событие DELETE. 
Триггер должен записывать строку данных в таблицу TR_AUDIT для каждой удаляемой строки. 
В столбец СС помещаются значения столбца TEACHER удаляемой строки. */
go
create trigger TR_TEACHER_DEL on TEACHER after delete
as declare @teacher varchar(10), @teacher_name varchar(50),
			@gender char(1), @pulpit varchar(10), @in varchar(300)
print 'Событие: DELETE'
set @teacher = (select TEACHER from inserted)
set @teacher_name = (select TEACHER_NAME from inserted)
set @gender = (select GENDER from inserted)
set @pulpit = (select PULPIT from inserted)
set @in = LTRIM(rtrim(@teacher)) + ' ' + LTRIM(rtrim(@teacher_name)) +
			' ' + LTRIM(rtrim(@gender)) + ' ' + LTRIM(rtrim(@pulpit))
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TRACHER_DEL', @in)

go
delete from TEACHER where TEACHER='ИВИИ'
select * from TR_AUDIT order by ID

--3
/*Создать AFTER-триггер с именем TR_TEACHER_UPD для таблицы TEACHER, 
реагирующий на событие UPDATE. 
Триггер должен записывать строку данных в таблицу TR_AUDIT для каждой изменяемой строки.
В столбец СС помещаются значения столбцов изменяемой строки до и после изменения.*/
go
create trigger TR_TEACHER_UPD on TEACHER after update
as declare @teacher varchar(10), @teacher_name varchar(50),
			@gender char(1), @pulpit varchar(10), @in varchar(300)

print 'Событие: UPDATE'

set @teacher = (select TEACHER from deleted where TEACHER is not null)
set @teacher_name = (select TEACHER_NAME from deleted where TEACHER_NAME is not null)
set @gender = (select GENDER from deleted where GENDER is not null)
set @pulpit = (select PULPIT from deleted where PULPIT is not null)
set @in = LTRIM(rtrim(@teacher)) + ' ' + LTRIM(rtrim(@teacher_name)) +
			' ' + LTRIM(rtrim(@gender)) + ' ' + LTRIM(rtrim(@pulpit))

set @teacher = (select TEACHER from inserted where TEACHER is not null)
set @teacher_name = (select TEACHER_NAME from inserted where TEACHER_NAME is not null)
set @gender = (select GENDER from inserted where GENDER is not null)
set @pulpit = (select PULPIT from inserted  where PULPIT is not null)
set @in = LTRIM(rtrim(@teacher)) + ' ' + LTRIM(rtrim(@teacher_name)) +
			' ' + LTRIM(rtrim(@gender)) + ' ' + LTRIM(rtrim(@pulpit)) + @in

insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TRACHER_UPD', @in)
go

update TEACHER set TEACHER_NAME = 'Иванович Иван Иванович' where TEACHER = 'ИВИИ'
select * from TR_AUDIT order by ID

--4
/*Создать AFTER-триггер с именем TR_TEACHER для таблицы TEACHER, 
реагирующий на события INSERT, DELETE, UPDATE. 
Триггер должен записывать строку данных в таблицу TR_AUDIT для каждой изменяемой строки. 
В коде триггера определить событие, активизировавшее триггер и поместить в столбец СС соответствующую событию информацию. 
Разработать сценарий, демонстрирующий работоспособность триггера. */
go
create trigger TR_TEACHER on TEACHER after insert, update, delete
as declare @teacher varchar(10), @teacher_name varchar(50),
			@gender char(1), @pulpit varchar(10), @in varchar(300)
if (select COUNT(*) from inserted) > 0 and  (select count(*) from deleted) > 0
begin
	print 'Событие: UPDATE'
	set @teacher = (select TEACHER from deleted where TEACHER is not null)
	set @teacher_name = (select TEACHER_NAME from deleted where TEACHER_NAME is not null)
	set @gender = (select GENDER from deleted where GENDER is not null)
	set @pulpit = (select PULPIT from deleted where PULPIT is not null)
	set @in = LTRIM(rtrim(@teacher)) + ' ' + LTRIM(rtrim(@teacher_name)) +
				' ' + LTRIM(rtrim(@gender)) + ' ' + LTRIM(rtrim(@pulpit))

	set @teacher = (select TEACHER from inserted where TEACHER is not null)
	set @teacher_name = (select TEACHER_NAME from inserted where TEACHER_NAME is not null)
	set @gender = (select GENDER from inserted where GENDER is not null)
	set @pulpit = (select PULPIT from inserted  where PULPIT is not null)
	set @in = LTRIM(rtrim(@teacher)) + ' ' + LTRIM(rtrim(@teacher_name)) +
				' ' + LTRIM(rtrim(@gender)) + ' ' + LTRIM(rtrim(@pulpit)) + @in

	insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TRACHER', @in)
end

if (select COUNT(*) from inserted) > 0 and  (select count(*) from deleted) = 0
begin
	print 'Событие: INSERT'
	set @teacher = (select TEACHER from inserted)
	set @teacher_name = (select TEACHER_NAME from inserted)
	set @gender = (select GENDER from inserted)
	set @pulpit = (select PULPIT from inserted)
	set @in = LTRIM(rtrim(@teacher)) + ' ' + LTRIM(rtrim(@teacher_name)) +
				' ' + LTRIM(rtrim(@gender)) + ' ' + LTRIM(rtrim(@pulpit))
	insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TRACHER', @in)
end

if (select COUNT(*) from inserted) = 0 and  (select count(*) from deleted) > 0
begin
	print 'Событие: DELETE'
	set @teacher = (select TEACHER from inserted)
	set @teacher_name = (select TEACHER_NAME from inserted)
	set @gender = (select GENDER from inserted)
	set @pulpit = (select PULPIT from inserted)
	set @in = LTRIM(rtrim(@teacher)) + ' ' + LTRIM(rtrim(@teacher_name)) +
				' ' + LTRIM(rtrim(@gender)) + ' ' + LTRIM(rtrim(@pulpit))
	insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TRACHER', @in)
end

insert into TEACHER values ('ПВПП', 'Петров Петр Петрович','м','ИСиТ')
select * from TR_AUDIT order by ID

update TEACHER set PULPIT='ЛВ'  where TEACHER='ПВПП'
select * from TR_AUDIT order by ID

delete from TEACHER where TEACHER='ПВПП'
select * from TR_AUDIT order by ID

--5
/*Разработать сценарий, который демонстрирует на примере базы данных X_UNIVER, 
что проверка ограничения целостности выполняется до срабатывания AFTER-триггера.*/
insert into TEACHER values ('TEST', 'TEST TEACHER', 'м', 'TEST')
select * from TR_AUDIT order by ID

--6
/*Создать для таблицы TEACHER три AFTER-триггера с именами: 
TR_TEACHER_ DEL1, TR_TEACHER_DEL2 и TR_TEA-CHER_ DEL3. 
Триггеры должны реагировать на собы-тие DELETE и формировать соответствующие строки в таблицу TR_AUDIT. 
Получить список триггеров таблицы TEACHER. 
Упорядочить выполнение триггеров для таблицы TEACHER, реагирующих на событие DELETE следующим образом: 
первым должен выполняться триггер с именем TR_TEACHER_DEL3, 
последним – триггер TR_TEACHER_DEL2. 
Примечание: использовать системные представления SYS.TRIGGERS и SYS.TRIGGERS_ EVENTS,
а также системную процеду-ру SP_SETTRIGGERORDERS. 
*/
go

create trigger TR_TEACHER_DEL1 on TEACHER after delete
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print 'DELETE Trigger 1'
set @IN = 'Trigger Normal Priority'
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL1', @IN)

go
create trigger TR_TEACHER_DEL2 on TEACHER after delete
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print 'DELETE Trigger 2'
set @IN = 'Trigger Low Priority'
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL2', @IN)

go
create trigger TR_TEACHER_DEL3 on TEACHER after delete
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print 'DELETE Trigger 3'
set @IN = 'Trigger Highest Priority'
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL3', @IN)
go

select t.name, e.type_desc 
from sys.triggers t join  sys.trigger_events e  
on t.object_id = e.object_id  
where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE'

exec SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', @order = 'First', @stmttype = 'DELETE'
exec SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', @order = 'Last',  @stmttype = 'DELETE'

delete from TEACHER where TEACHER = 'ИВИИ'
select * from TR_AUDIT order by ID

--7
/*Разработать сценарий, демонстрирующий на примере базы данных X_UNIVER утверждение: AFTER-триггер является частью транзакции, в рамках которого выполняется оператор, активизировавший триггер.*/
go
create trigger TR_TEACHER_TRAN on TEACHER after insert	
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print 'Transaction Trigger'
set @TEACHER = (select TEACHER from INSERTED)
set @TEACHER_NAME = (select TEACHER_NAME from INSERTED)
set @GENDER = (select GENDER from INSERTED)
set @PULPIT = (select PULPIT from INSERTED)
set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
		  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))
if @TEACHER like '%СССС%'
begin
	insert into TR_AUDIT (STMT, TRNAME, CC) values 
	('INS', 'TR_TEACHER_TRAN', 'Проверка транзакции')
	raiserror('Проверка ранзакции', 10, 1)
	rollback
end

insert into TEACHER values ('СССС', 'Сидоров Степан Степанович', 'м', 'ЛВ')
select * from TR_AUDIT order by ID

--8
/*Для таблицы FACULTY создать INSTEAD OF-триггер, запрещающий удаление строк в таблице. 
Разработать сценарий, который демонстрирует на примере базы данных X_UNIVER, 
что проверка ограничения целостности выполнена, если есть INSTEAD OF-триггер.
С помощью оператора DROP удалить все DML-триггеры, созданные в этой лабораторной работе.
*/
GO
create trigger TR_TEACHER_INSTEAD_OF on TEACHER instead of delete
as raiserror('Удаление запрещено', 10, 1)
return

set nocount on
delete from TEACHER where TEACHER = 'СССС'
select * from TR_AUDIT order by ID

go
drop trigger TR_TEACHER_INS
drop trigger TR_TEACHER_DEL
drop trigger TR_TEACHER_UPD
drop trigger TR_TEACHER
drop trigger TR_TEACHER_DEL1
drop trigger TR_TEACHER_DEL2
drop trigger TR_TEACHER_DEL3
drop trigger TR_TEACHER_TRAN
drop trigger TR_TEACHER_INSTEAD_OF

--9
/*Создать DDL-триггер, реагирующий на все DDL-события в БД UNIVER. 
Триггер должен запрещать создавать новые таблицы и удалять существующие. 
Свое выполнение триггер должен сопровождать сообщением,
которое содержит: тип события, имя и тип объекта, 
а так-же пояснительный текст, в случае запрещения выполнения оператора. 
Разработать сценарий, демонстрирующий работу триггера. 
*/
GO
create trigger TR_TEACHER_DDL on database 
for DDL_DATABASE_LEVEL_EVENTS  as   
declare @EVENT_TYPE varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)')
declare @OBJ_NAME varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)')
declare @OBJ_TYPE varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)')
if @OBJ_NAME = 'TEACHER' 
begin
	print 'Тип события: ' + cast(@EVENT_TYPE as varchar)
	print 'Имя события: ' + cast(@OBJ_NAME as varchar)
	print 'Тип объекта: ' + cast(@OBJ_TYPE as varchar)
	raiserror('Операции с таблицей запрещены', 16, 1)
	rollback  
end


alter table TEACHER drop column TEACHER_NAME

