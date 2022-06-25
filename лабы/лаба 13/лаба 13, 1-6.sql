use UNIVER
go

--1
/*����������� ��������� ������� � ������ COUNT_STUDENTS, 
������� ��������� ���������� ��������� �� ����������, 
��� �������� �������� ���������� ���� VARCHAR(20) � ������ @faculty. 
������������ ���������� ���������� ������ FACULTY, GROUPS, STUDENT. 
���������� ������ �������.
������ ��������� � ����� ������� � ������� ��������� ALTER � ���,
����� ������� ��������� ������ �������� @prof ���� VARCHAR(20),
������������ ������������� ���������.
��� ���������� ���������� �������� �� ��������� NULL. 
���������� ������ ������� � ������� SELECT-��������.
*/

--drop function COUNT_STUDENTS
--GO

create function COUNT_STUDENTS (@faculty varchar(20)) returns int
as begin
declare @count int = (select count(*)
								from STUDENT
								join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
								join FACULTY on FACULTY.FACULTY = GROUPS.FACULTY
								where GROUPS.FACULTY = @faculty)
	return @count
end

go

declare @count int = dbo.COUNT_STUDENTS('����')
print '���������� ���������: ' + cast(@count as varchar)
go

alter function COUNT_STUDENTS (@faculty varchar(20) = null, @prof varchar(20) = null) returns int
as begin
declare @count int = (select count(*)
								from STUDENT
								join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
								join FACULTY on FACULTY.FACULTY = GROUPS.FACULTY
								where GROUPS.FACULTY = isnull(@faculty, GROUPS.FACULTY)
								and GROUPS.PROFESSION = isnull(@prof, GROUPS.PROFESSION))
	return @count
end

go

declare @count int = dbo.COUNT_STUDENTS('����', '1-40 01 02')
print '���������� ���������: ' + cast(@count as varchar)

select distinct FACULTY, PROFESSION, dbo.COUNT_STUDENTS(FACULTY, PROFESSION)
from GROUPS

--2
/*����������� ��������� ������� � ������ FSUBJECTS,
����������� �������� @p ���� VARCHAR(20), �������� �������� ������ ��� ������� (������� SUBJECT.PULPIT). 
������� ������ ���������� ������ ���� VARCHAR(300) � �������� ��������� � ������. 

������� � ��������� ��������, ������� ������� �����, ����������� ��������������� ����. 
����������: ������������ ��������� ����������� ������ �� ������ SELECT-������� � ������� SUBJECT.
*/
go

create function FSUBJECT (@p varchar(20)) returns varchar(300)
as begin
	declare @out varchar(300) = '����������: '
	declare @subj varchar(50) = ' '
	declare cur cursor local static for
		(select SUBJECT.SUBJECT
				from SUBJECT
				where SUBJECT.PULPIT = @p)
	open cur
		fetch cur into @subj
		while @@FETCH_STATUS = 0
		begin
			set @out += RTRIM(LTRIM(@subj)) + ', '
		end
	close cur
	return @out
end

go

select PULPIT, dbo.FSUBJECT(PULPIT) from PULPIT

--3
/*. ����������� ��������� ������� FFACPUL, ���������� ������ ������� ������������������ �� ������� ����. 
������� ��������� ��� ���������, �������� ��� ���������� (������� FACULTY.FACULTY) � ��� ������� (������� PULPIT.PULPIT).
���������� SELECT-������ c ����� ������� ����������� ����� ��������� FACULTY � PULPIT. 
���� ��� ��������� ������� ����� NULL, �� ��� ���-������� ������ ���� ������ �� ���� �����������. 
���� ����� ������ �������� (������ ����� NULL), ����-��� ���������� ������ ���� ������ ��������� ����������. 
���� ����� ������ �������� (������ ����� NULL), ����-��� ���������� �������������� �����, ���������� ����-��, ��������������� �������� �������.
*/
go

create function FFACPUL (@FACULTY varchar(20), @PULPIT varchar(20)) returns table
as return
	select FACULTY.FACULTY, PULPIT.PULPIT
	from   FACULTY left join PULPIT
	on	   PULPIT.FACULTY = FACULTY.FACULTY
	where  FACULTY.FACULTY = isnull(@FACULTY, FACULTY.FACULTY)
	and	   PULPIT.PULPIT = isnull (@PULPIT, PULPIT.PULPIT)

go

select * from FFACPUL(null, null)
select * from FFACPUL('��', null)
select * from FFACPUL(null, '����')
select * from FFACPUL('��', '����')

--4
/*�� ������� ���� ������� ��������, 
��������������� ������ ��������� ������� FCTEACHER.
������� ��������� ���� ��������, �������� ��� �������.
������� ���������� ���������� �������������� �� �������� ���������� �������. 
���� �������� ����� NULL, �� ������������ ����� ���������� ��������������. */
go

create function FCTEACHER (@PULPIT varchar(20)) returns int
as begin
	declare @COUNT int = (select count(*)
						  from   TEACHER
						  where  TEACHER.PULPIT = isnull(@PULPIT, TEACHER.PULPIT))
	return @COUNT
end

go

print '���������� ��������������: ' + cast(dbo.FCTEACHER(null) as varchar)
print '���������� �������������� �� ������� ����:  ' + cast(dbo.FCTEACHER('����') as varchar)

select PULPIT, dbo.FCTEACHER(PULPIT)
from   PULPIT

--6
/* �������� ��� ������� ���, ����� ���������� ������, ���������� �����, ���������� ��������� � ���������� ����������-���� ����������� ���������� ���������� ���������.*/
go

create function COUNT_PULPITS (@FACULTY varchar(20)) returns int
as begin
	declare @COUNT int = (select count(PULPIT) from PULPIT where FACULTY = isnull(@FACULTY, FACULTY))
	return @COUNT
end

go

create function COUNT_GROUPS (@FACULTY varchar(20)) returns int
as begin
	declare @COUNT int = (select count(IDGROUP) from GROUPS where FACULTY = isnull(@FACULTY, FACULTY))
	return @COUNT
end

go

create function COUNT_PROFESSIONS (@FACULTY varchar(20)) returns int
as begin
	declare @COUNT int =  (select count(PROFESSION) from PROFESSION where FACULTY = isnull(@FACULTY, FACULTY))
	return @COUNT
end

go

create function FACULTY_REPORT(@c int) returns @fr table
([���������] varchar(50), [���������� ������] int, [���������� �����] int, [���������� ���������] int, [���������� ��������������] int)
as begin 
	declare @f varchar(30);
	declare cc CURSOR static for 
	select FACULTY from FACULTY 
	where  dbo.COUNT_STUDENTS(FACULTY, default) > @c; 

	open cc;  
		fetch cc into @f;
	    while @@fetch_status = 0
			begin
	            insert @fr values(@f,  dbo.COUNT_PULPITS(@f),
	            dbo.COUNT_GROUPS(@f),   dbo.COUNT_STUDENTS(@f, default),
	            dbo.COUNT_PROFESSIONS(@f)); 
	            fetch cc into @f;  
	       end;   
	return; 
end;

go

select * from FACULTY_REPORT(0)