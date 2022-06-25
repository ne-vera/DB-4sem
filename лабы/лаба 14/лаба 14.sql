--1
/*� ������� ��������, ��������������� �� ��-�����, ������� ������� TR_AUDIT.*/

create table TR_AUDIT
(
	ID int identity(1, 1),										-- ID
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),		-- DML operator name
	TRNAME varchar(50),											-- trigger name
	CC varchar(300)												-- comment
)

/*����������� AFTER-������� � ������ TR_TEACHER_INS ��� ������� TEACHER, 
����������� �� ������� INSERT. 
������� ������ ���������� ������ �������� ������ � ������� TR_AUDIT. 
� ������� �� ������-���� �������� �������� �������� ������. */
go

create trigger TR_TEACHER_INS on teacher after insert
as declare @teacher varchar(10), @teacher_name varchar(50),
			@gender char(1), @pulpit varchar(10), @in varchar(300)
print '�������� �������: '
set @teacher = (select TEACHER from inserted)
set @teacher_name = (select TEACHER_NAME from inserted)
set @gender = (select GENDER from inserted)
set @pulpit = (select PULPIT from inserted)
set @in = LTRIM(rtrim(@teacher)) + ' ' + LTRIM(rtrim(@teacher_name)) +
			' ' + LTRIM(rtrim(@gender)) + ' ' + LTRIM(rtrim(@pulpit))
insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TRACHER_INS', @in)

go

insert into TEACHER values ('����', '������ ���� ��������', '�', '����')
select * from TR_AUDIT order by ID

--2
/*������� AFTER-������� � ������ TR_TEACHER_DEL ��� ������� TEACHER, 
����������� �� ������� DELETE. 
������� ������ ���������� ������ ������ � ������� TR_AUDIT ��� ������ ��������� ������. 
� ������� �� ���������� �������� ������� TEACHER ��������� ������. */
go
create trigger TR_TEACHER_DEL on TEACHER after delete
as declare @teacher varchar(10), @teacher_name varchar(50),
			@gender char(1), @pulpit varchar(10), @in varchar(300)
print '�������: DELETE'
set @teacher = (select TEACHER from inserted)
set @teacher_name = (select TEACHER_NAME from inserted)
set @gender = (select GENDER from inserted)
set @pulpit = (select PULPIT from inserted)
set @in = LTRIM(rtrim(@teacher)) + ' ' + LTRIM(rtrim(@teacher_name)) +
			' ' + LTRIM(rtrim(@gender)) + ' ' + LTRIM(rtrim(@pulpit))
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TRACHER_DEL', @in)

go
delete from TEACHER where TEACHER='����'
select * from TR_AUDIT order by ID

--3
/*������� AFTER-������� � ������ TR_TEACHER_UPD ��� ������� TEACHER, 
����������� �� ������� UPDATE. 
������� ������ ���������� ������ ������ � ������� TR_AUDIT ��� ������ ���������� ������.
� ������� �� ���������� �������� �������� ���������� ������ �� � ����� ���������.*/
go
create trigger TR_TEACHER_UPD on TEACHER after update
as declare @teacher varchar(10), @teacher_name varchar(50),
			@gender char(1), @pulpit varchar(10), @in varchar(300)

print '�������: UPDATE'

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

update TEACHER set TEACHER_NAME = '�������� ���� ��������' where TEACHER = '����'
select * from TR_AUDIT order by ID

--4
/*������� AFTER-������� � ������ TR_TEACHER ��� ������� TEACHER, 
����������� �� ������� INSERT, DELETE, UPDATE. 
������� ������ ���������� ������ ������ � ������� TR_AUDIT ��� ������ ���������� ������. 
� ���� �������� ���������� �������, ���������������� ������� � ��������� � ������� �� ��������������� ������� ����������. 
����������� ��������, ��������������� ����������������� ��������. */
go
create trigger TR_TEACHER on TEACHER after insert, update, delete
as declare @teacher varchar(10), @teacher_name varchar(50),
			@gender char(1), @pulpit varchar(10), @in varchar(300)
if (select COUNT(*) from inserted) > 0 and  (select count(*) from deleted) > 0
begin
	print '�������: UPDATE'
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
	print '�������: INSERT'
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
	print '�������: DELETE'
	set @teacher = (select TEACHER from inserted)
	set @teacher_name = (select TEACHER_NAME from inserted)
	set @gender = (select GENDER from inserted)
	set @pulpit = (select PULPIT from inserted)
	set @in = LTRIM(rtrim(@teacher)) + ' ' + LTRIM(rtrim(@teacher_name)) +
				' ' + LTRIM(rtrim(@gender)) + ' ' + LTRIM(rtrim(@pulpit))
	insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TRACHER', @in)
end

insert into TEACHER values ('����', '������ ���� ��������','�','����')
select * from TR_AUDIT order by ID

update TEACHER set PULPIT='��'  where TEACHER='����'
select * from TR_AUDIT order by ID

delete from TEACHER where TEACHER='����'
select * from TR_AUDIT order by ID

--5
/*����������� ��������, ������� ������������� �� ������� ���� ������ X_UNIVER, 
��� �������� ����������� ����������� ����������� �� ������������ AFTER-��������.*/
insert into TEACHER values ('TEST', 'TEST TEACHER', '�', 'TEST')
select * from TR_AUDIT order by ID

--6
/*������� ��� ������� TEACHER ��� AFTER-�������� � �������: 
TR_TEACHER_ DEL1, TR_TEACHER_DEL2 � TR_TEA-CHER_ DEL3. 
�������� ������ ����������� �� ����-��� DELETE � ����������� ��������������� ������ � ������� TR_AUDIT. 
�������� ������ ��������� ������� TEACHER. 
����������� ���������� ��������� ��� ������� TEACHER, ����������� �� ������� DELETE ��������� �������: 
������ ������ ����������� ������� � ������ TR_TEACHER_DEL3, 
��������� � ������� TR_TEACHER_DEL2. 
����������: ������������ ��������� ������������� SYS.TRIGGERS � SYS.TRIGGERS_ EVENTS,
� ����� ��������� �������-�� SP_SETTRIGGERORDERS. 
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

delete from TEACHER where TEACHER = '����'
select * from TR_AUDIT order by ID

--7
/*����������� ��������, ��������������� �� ������� ���� ������ X_UNIVER �����������: AFTER-������� �������� ������ ����������, � ������ �������� ����������� ��������, ���������������� �������.*/
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
if @TEACHER like '%����%'
begin
	insert into TR_AUDIT (STMT, TRNAME, CC) values 
	('INS', 'TR_TEACHER_TRAN', '�������� ����������')
	raiserror('�������� ���������', 10, 1)
	rollback
end

insert into TEACHER values ('����', '������� ������ ����������', '�', '��')
select * from TR_AUDIT order by ID

--8
/*��� ������� FACULTY ������� INSTEAD OF-�������, ����������� �������� ����� � �������. 
����������� ��������, ������� ������������� �� ������� ���� ������ X_UNIVER, 
��� �������� ����������� ����������� ���������, ���� ���� INSTEAD OF-�������.
� ������� ��������� DROP ������� ��� DML-��������, ��������� � ���� ������������ ������.
*/
GO
create trigger TR_TEACHER_INSTEAD_OF on TEACHER instead of delete
as raiserror('�������� ���������', 10, 1)
return

set nocount on
delete from TEACHER where TEACHER = '����'
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
/*������� DDL-�������, ����������� �� ��� DDL-������� � �� UNIVER. 
������� ������ ��������� ��������� ����� ������� � ������� ������������. 
���� ���������� ������� ������ ������������ ����������,
������� ��������: ��� �������, ��� � ��� �������, 
� ���-�� ������������� �����, � ������ ���������� ���������� ���������. 
����������� ��������, ��������������� ������ ��������. 
*/
GO
create trigger TR_TEACHER_DDL on database 
for DDL_DATABASE_LEVEL_EVENTS  as   
declare @EVENT_TYPE varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)')
declare @OBJ_NAME varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)')
declare @OBJ_TYPE varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)')
if @OBJ_NAME = 'TEACHER' 
begin
	print '��� �������: ' + cast(@EVENT_TYPE as varchar)
	print '��� �������: ' + cast(@OBJ_NAME as varchar)
	print '��� �������: ' + cast(@OBJ_TYPE as varchar)
	raiserror('�������� � �������� ���������', 16, 1)
	rollback  
end


alter table TEACHER drop column TEACHER_NAME

