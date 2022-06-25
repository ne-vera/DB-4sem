use UNIVER
GO
--1
/*. ����������� �������� ��������� ��� ���������� � ������ PSUBJECT. 
��������� ��������� ��������-������ ����� �� ������ ������� SUBJECT, 
����������� ������, ��������������� �� �������: 
� ����� ������ ��������� ������ ���������� ��-�������� �����, ���������� � �������������� �����.*/
create procedure PSUBJECT
as
begin
	declare @count int = (select count(*) from SUBJECT)
	select * from SUBJECT
	return @count
end

declare @count_output int = 0
exec @count_output = PSUBJECT
print '���������� �����' + cast(@count_output as varchar)

--drop procedure PSUBJECT

--2
/*����� ��������� PSUBJECT � ������� ������������ �������� (Object Explorer) SSMS
� ����� ����������� ���� ������� �������� �� ��������� �������� ���������� ALTER.
�������� ��������� PSUBJECT, ��������� � ������� 1, ����� �������,
����� ��� ��������� ��� ��-������� � ������� @p � @c. 
�������� @p �������� �������, ����� ��� VARCHAR(20) � �������� �� ��������� NULL. 
�������� @� �������� ��������, ����� ��� INT.
��������� PSUBJECT ������ ����������� �������������� �����, ����������� ������, 
��������������� �� ������� ����, �� ��� ���� ��������� ������,
��������������� ���� �������, ��������� ���������� @p. 
����� ����, ��������� ������ ����������� �������� ��������� ��������� @�, 
������ ���������� ����� � �������������� ������, 
� ����� ���������� �������� � ����� ������, ������ ������ ���������� ��������� (���������� ����� � ������� SUBJECT). 
*/
USE [UNIVER]
GO

/****** Object:  StoredProcedure [dbo].[PSUBJECT]    Script Date: 07.06.2022 10:30:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[PSUBJECT] @p varchar(20), @c int output
as
begin
	declare @count int = (select count(*) from SUBJECT)
	print '���������: @p = ' + @p + '; @c = ' + cast(@c as varchar)
	select SUBJECT.SUBJECT ���, SUBJECT.SUBJECT_NAME ����������, SUBJECT.PULPIT �������
	from SUBJECT
	where SUBJECT.PULPIT = @p
	set @c = @@ROWCOUNT
	return @count
end

go

declare @c int = 0
declare @count int = 0
declare @param int = 0
declare @p varchar(20) = null
exec @count = PSUBJECT @p = '����', @c = @param output
print '���-�� ��������� �� �������: ' + cast(@param as varchar)
print '���-�� ��������� �����: ' + cast(@count as varchar)
go
--3
/*������� ��������� ��������� ������� � ������ #SUBJECT. 
������������ � ��� �������� ������� ������ ��������������� �������� ��������������� ������ ��������� PSUBJECT, ������������� � ������� 2. 
�������� ��������� PSUBJECT ����� �������, ����� ��� �� ��������� ��������� ���������.
�������� ����������� INSERT� EXECUTE � ���������������� ���������� PSUBJECT,
�������� ������ � ������� #SUBJECT. 
*/

alter procedure PSUBJECT @p varchar(20)
as
begin
	select *
	from SUBJECT
	where SUBJECT.PULPIT = @p
end

go

--drop table #SUBJECT
create table #SUBJECT
(
	��� varchar(10) primary key,
	���������� varchar(50),
	������� varchar(10)
)
insert #SUBJECT exec PSUBJECT @p = '����'
select * from #SUBJECT

--4
/*����������� ��������� � ������ PAUDITORIUM_INSERT. 
��������� ��������� ������ ������� ���������: @a, @n, @c � @t. 
�������� @a ����� ��� CHAR(20), 
�������� @n ����� ��� VARCHAR(50), 
�������� @c ����� ��� INT � �������� �� ��������� 0,
�������� @t ����� ��� CHAR(10).
��������� ��������� ������ � ������� AUDITORIUM. 
�������� �������� AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY � AUDITORIUM_TYPE ����������� ������ 
�������� �������������� ����������� @a, @n, @c � @t.
��������� PAUDITORIUM_INSERT ������ ��������� �������� TRY/CATCH ��� ��������� ������.
� ������ ������������� ������, ��������� ������ ����������� ���������,
���������� ��� ������, ������� ����������� � ����� ��������� � ����������� �������� �����. 
��������� ������ ���������� � ����� ������ �������� -1 � ��� ������, ���� ��������� ������ � 1, ��-�� ���������� �������. 
���������� ������ ��������� � ���������� �����-����� �������� ������, ������� ����������� � ���-����.
*/
go

create procedure PAUDITORIUM_INSERT
				@a char(20), @n varchar(50), @c int = 0, @t char(10)
as
begin
	begin try
		insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
				values (@a, @n, @c, @t)
		return 1
	end try
	begin catch
			print '��� ������:  ' + cast(ERROR_NUMBER() as varchar)
			print '������� �����������: ' + cast(ERROR_SEVERITY() as varchar)
			print '����� ���������:   ' + cast(ERROR_MESSAGE() as varchar)
		return -1
	end catch
end

declare @out int;
exec @out = PAUDITORIUM_INSERT @a = '136-1', @n = '136-1', @c = 60, @t = '��'
print '��� ������ ' + cast(@out as varchar)
 go

 --5
 /*����������� ��������� � ������ SUBJECT_REPORT,
����������� � ����������� �������� ����� ����� �� ������� ��������� �� ���������� �������. 
� ����� ������ ���� �������� ������� �������� (���� SUBJECT) �� ������� SUBJECT � ���� ������ ����� ������� (������������ ���������� ������� RTRIM). 
��������� ����� ������� �������� � ������ @p ���� CHAR(10), ������� ������������ ��� �������� ���� �������.
� ��� ������, ���� �� ��������� �������� @p ���������� ���������� ��� �������,
��������� ������ ������������ ������ � ���������� ������ � ����������. 
��������� SUBJECT_REPORT ������ ���������� � ����� ������ ���������� ���������, ������������ � ������. 
*/

create procedure SUBJECT_REPORT @p char(10)
as
begin
begin try
declare @SUBJ_OUT varchar(200) =''
declare @SUBJ_ONE varchar(20) = ''
declare @ROWCOUNT int = 0
declare cur cursor local static for (select SUBJECT from SUBJECT where SUBJECT.PULPIT = @p)
if not exists (select SUBJECT from SUBJECT where SUBJECT.PULPIT = @p)
		raiserror('������',11,1)
else
open cur
	fetch cur into @SUBJ_ONE
	while @@FETCH_STATUS = 0
	begin
		set @SUBJ_OUT += rtrim(@SUBJ_ONE) + ', '
		set @ROWCOUNT = @ROWCOUNT + 1
		fetch cur into @SUBJ_ONE
	end
	print @SUBJ_OUT
close cur
return @ROWCOUNT
end try
begin catch
	print '������ '
	print '����� ���������:   ' + cast(ERROR_MESSAGE() as varchar)
	print '������ ' + cast(@ROWCOUNT as varchar) 
end catch
end

go

declare @count int = 0
exec @count = SUBJECT_REPORT @p = '����'
print '����������: ' + cast(@count as varchar)

--6
/*6. ����������� ��������� � ������ PAUDITORIUM_INSERTX. 
��������� ��������� ���� ������� ����������: @a, @n, @c, @t � @tn. 
��������� @a, @n, @c, @t ���������� ���������� ��������� PAUDITORIUM_INSERT. 
�������������� �������� @tn �������� �������, ����� ��� VARCHAR(50), 
������������ ��� ����� �������� � ������� AUDITORIUM_TYPE.AUDITORIUM_TYPENAME.
��������� ��������� ��� ������. 
������ ������ ����������� � ������� AUDITORIUM_TYPE. 
�������� �������� AUDITORIUM_TYPE � AUDITORIUM_ TYPENAME ����������� ������ �������� �������������� ����������� @t � @tn. 
������ ������ ����������� ����� ������ ��������� PAUDITORIUM_INSERT.

���������� ������ � ������� AUDITORIUM_TYPE � ����� ��������� PAUDITORIUM_INSERT ������ ����������� � ������ ����� ����� ���������� � ������� ��������������� SERIALIZABLE. 
� ��������� ������ ���� ������������� ��������� ������ � ������� ��������� TRY/CATCH. ��� ������ ������ ���� ���������� � ������� ���������������� ��������� � ����������� �������� �����. 
��������� PAUDITORIUM_INSERTX ������ ���������� � ����� ������ �������� -1 � ��� ������, ���� ��������� ������ � 1, ���� ���������� ��������� ����������� �������. */



go

create procedure PAUDITORIUM_INSERTX
				@a char(20), @n varchar(50), @c int = 0, @t char(10), @tn varchar(50)
as
begin
	begin try
	set transaction isolation level SERIALIZABLE
	begin transaction
		insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
				values(@t, @tn)
		exec PAUDITORIUM_INSERT @a, @n, @c, @t
	commit tran
	return 1
	end try
	begin catch
			print '��� ������:  ' + cast(ERROR_NUMBER() as varchar)
			print '������� �����������: ' + cast(ERROR_SEVERITY() as varchar)
			print '����� ���������:   ' + cast(ERROR_MESSAGE() as varchar)
		if @@TRANCOUNT > 0 
				rollback tran
		return -1
	end catch
end

go
exec PAUDITORIUM_INSERTX @a = '111-1', @n = '111-1', @c = 50, @t = 'TYPE-1', @tn = 'TYPE-1'

/*��� ���������� � ������������� �������(��������)*/
--���������
drop procedure SUBJ_PR
go
create procedure SUBJ_PR @teacher varchar(50)
as
begin
	select distinct TIMETABLE.SUBJECT from TIMETABLE
	where TIMETABLE.TEACHER = @teacher
end

go
execute SUBJ_PR @teacher = '����'

--�������
GO
drop function SUBJ_FUNC

go
create function SUBJ_FUNC (@teacher varchar(50)) returns @subjects table ([�������] varchar(50))
as
begin
	declare cur cursor static for select distinct TIMETABLE.SUBJECT from TIMETABLE
					where TIMETABLE.TEACHER = @teacher
	declare @subj varchar(50);

	open cur
		fetch cur into @subj
		while @@FETCH_STATUS = 0
		begin
			insert @subjects values (@subj)
			fetch cur into @subj
		end
	return;
end

go
select * from SUBJ_FUNC('����')