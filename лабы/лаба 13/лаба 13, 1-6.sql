use UNIVER
go

--1
/*Разработать скалярную функцию с именем COUNT_STUDENTS, 
которая вычисляет количество студентов на факультете, 
код которого задается параметром типа VARCHAR(20) с именем @faculty. 
Использовать внутреннее соединение таблиц FACULTY, GROUPS, STUDENT. 
Опробовать работу функции.
Внести изменения в текст функции с помощью оператора ALTER с тем,
чтобы функция принимала второй параметр @prof типа VARCHAR(20),
обозначающий специальность студентов.
Для параметров определить значения по умолчанию NULL. 
Опробовать работу функции с помощью SELECT-запросов.
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

declare @count int = dbo.COUNT_STUDENTS('ИДиП')
print 'Количество сутдентов: ' + cast(@count as varchar)
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

declare @count int = dbo.COUNT_STUDENTS('ИДиП', '1-40 01 02')
print 'Количество сутдентов: ' + cast(@count as varchar)

select distinct FACULTY, PROFESSION, dbo.COUNT_STUDENTS(FACULTY, PROFESSION)
from GROUPS

--2
/*Разработать скалярную функцию с именем FSUBJECTS,
принимающую параметр @p типа VARCHAR(20), значение которого задает код кафедры (столбец SUBJECT.PULPIT). 
Функция должна возвращать строку типа VARCHAR(300) с перечнем дисциплин в отчете. 

Создать и выполнить сценарий, который создает отчет, аналогичный представленному ниже. 
Примечание: использовать локальный статический курсор на основе SELECT-запроса к таблице SUBJECT.
*/
go

create function FSUBJECT (@p varchar(20)) returns varchar(300)
as begin
	declare @out varchar(300) = 'Дисциплины: '
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
/*. Разработать табличную функцию FFACPUL, результаты работы которой продемонстрированы на рисунке ниже. 
Функция принимает два параметра, задающих код факультета (столбец FACULTY.FACULTY) и код кафедры (столбец PULPIT.PULPIT).
Использует SELECT-запрос c левым внешним соединением между таблицами FACULTY и PULPIT. 
Если оба параметра функции равны NULL, то она воз-вращает список всех кафедр на всех факультетах. 
Если задан первый параметр (второй равен NULL), функ-ция возвращает список всех кафедр заданного факультета. 
Если задан второй параметр (первый равен NULL), функ-ция возвращает результирующий набор, содержащий стро-ку, соответствующую заданной кафедре.
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
select * from FFACPUL('ИТ', null)
select * from FFACPUL(null, 'ИСиТ')
select * from FFACPUL('ИТ', 'ИСиТ')

--4
/*На рисунке ниже показан сценарий, 
демонстрирующий работу скалярной функции FCTEACHER.
Функция принимает один параметр, задающий код кафедры.
Функция возвращает количество преподавателей на заданной параметром кафедре. 
Если параметр равен NULL, то возвращается общее количество преподавателей. */
go

create function FCTEACHER (@PULPIT varchar(20)) returns int
as begin
	declare @COUNT int = (select count(*)
						  from   TEACHER
						  where  TEACHER.PULPIT = isnull(@PULPIT, TEACHER.PULPIT))
	return @COUNT
end

go

print 'Количество преподавателей: ' + cast(dbo.FCTEACHER(null) as varchar)
print 'Количество преподавателей на кафедре ИСиТ:  ' + cast(dbo.FCTEACHER('ИСиТ') as varchar)

select PULPIT, dbo.FCTEACHER(PULPIT)
from   PULPIT

--6
/* Изменить эту функцию так, чтобы количество кафедр, количество групп, количество студентов и количество специально-стей вычислялось отдельными скалярными функциями.*/
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
([Факультет] varchar(50), [Количество кафедр] int, [Количество групп] int, [Количество студентов] int, [Количество специальностей] int)
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