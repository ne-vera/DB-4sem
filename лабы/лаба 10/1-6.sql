use UNIVER
go 

--1
/*Разработать сценарий, формирующий список дисциплин на кафедре ИСиТ. 
В отчет должны быть выведены краткие названия (поле SUBJECT) из таблицы SUBJECT в одну строку через запятую. 
Использовать встроенную функцию RTRIM.*/
declare @str char(20), @out varchar(300)=''
declare ISiT cursor 
			for (select SUBJECT from SUBJECT
					where PULPIT='ИСиТ')
	open ISiT;
	fetch ISiT into @str
	print 'дисциплины на кафедре ИСиТ'
	while @@FETCH_STATUS = 0
		begin
			set @out = rtrim(@str) + ', ' + @out;
			fetch ISiT into @str;
		end;
	print @out;
close ISiT
deallocate ISiT

--2
/*Разработать сценарий, демонстрирующий отличие глобального курсора от локального на примере базы данных X_UNIVER.*/
--локальный
declare loc cursor local
			for select PROGRESS.IDSTUDENT, PROGRESS.SUBJECT ,PROGRESS.NOTE
			from PROGRESS
declare @student varchar(10)
declare @subject varchar(10)
declare @note int
	open loc
	fetch loc into @student, @subject, @note
	print '1.' + @student + ': '+ @subject + cast(@note as varchar)

go
declare @student varchar(10)
declare @subject varchar(10)
declare @note int
fetch loc into @student, @subject, @note
	print '1.' + @student + ': '+ @subject + cast(@note as varchar)
go

--глобальный
declare glob cursor global for select PROGRESS.IDSTUDENT, PROGRESS.SUBJECT ,PROGRESS.NOTE
			from PROGRESS
declare @student varchar(10)
declare @subject varchar(10)
declare @note int
open glob
fetch glob into @student, @subject, @note
	print '1.' + @student + ': '+ @subject + cast(@note as varchar)
go

declare @student varchar(10)
declare @subject varchar(10)
declare @note int
fetch glob into @student, @subject, @note
	print '2.' + @student + ': '+ @subject + cast(@note as varchar)

deallocate glob
go

--3
/*Разработать сценарий, демонстрирующий отличие статических курсоров от динамических на примере базы данных X_UNIVER.*/
--Статический
declare stat cursor local static
		for select AUDITORIUM.AUDITORIUM,
					AUDITORIUM.AUDITORIUM_TYPE,
					AUDITORIUM.AUDITORIUM_CAPACITY
					from AUDITORIUM

declare @auditorium varchar(10)
declare @type varchar(5)
declare @capacity int

open stat
print 'Количество строк: ' + cast(@@cursor_rows as varchar(5))
update AUDITORIUM set AUDITORIUM_TYPE = 'ЛБ-К' where AUDITORIUM='236-1'
fetch stat into @auditorium, @type, @capacity
while @@FETCH_STATUS=0
	begin
	print @auditorium + ' ' + @type + ' ' + cast(@capacity as char)
	fetch stat into @auditorium,
					@type,
					@capacity
end
close stat
go

--Динамический
declare stat cursor local dynamic
		for select AUDITORIUM.AUDITORIUM,
					AUDITORIUM.AUDITORIUM_TYPE,
					AUDITORIUM.AUDITORIUM_CAPACITY
					from AUDITORIUM

declare @auditorium varchar(10)
declare @type varchar(5)
declare @capacity int

open stat
print 'Количество строк: ' + cast(@@cursor_rows as varchar(5))
update AUDITORIUM set AUDITORIUM_TYPE = 'ЛБ-К' where AUDITORIUM='206-1'
fetch stat into @auditorium, @type, @capacity
while @@FETCH_STATUS=0
	begin
	print @auditorium + ' ' + @type + ' ' + cast(@capacity as char)
	fetch stat into @auditorium,
					@type,
					@capacity
end
close stat
go

--4
/*Разработать сценарий, демонстрирующий свойства навигации в результиру-ющем наборе курсора с атрибутом SCROLL на примере базы данных X_UNIVER.
Использовать все известные ключевые слова в операторе FETCH.*/
declare allkeys cursor local dynamic scroll
		for select ROW_NUMBER() over (order by PROGRESS.SUBJECT),
								PROGRESS.IDSTUDENT,
								PROGRESS.SUBJECT,
								PROGRESS.NOTE
								from PROGRESS
declare @rn int, @id varchar(10), @subject varchar(10), @note int
open allkeys

fetch allkeys into @rn, @id, @subject, @note
print 'First: ' + cast(@rn as varchar) + '. ' + @id + ': ' + rtrim(cast(@subject as varchar)) + ' ' + cast(@note as varchar)

fetch next from allkeys into @rn, @id, @subject, @note
print 'Next: ' + cast(@rn as varchar) + '. ' + @id + ': ' + rtrim(cast(@subject as varchar)) + ' ' + cast(@note as varchar)

fetch relative 5 from allkeys into @rn, @id, @subject, @note
print 'Relative 5: ' + cast(@rn as varchar) + '. ' + @id + ': ' + rtrim(cast(@subject as varchar)) + ' ' + cast(@note as varchar)

fetch absolute -5 from allkeys into @rn, @id, @subject, @note
print 'Absolute -5: ' + cast(@rn as varchar) + '. ' + @id + ': ' + rtrim(cast(@subject as varchar)) + ' ' + cast(@note as varchar)

fetch prior from allkeys into @rn, @id, @subject, @note
print 'Prior: ' + cast(@rn as varchar) + '. ' + @id + ': ' + rtrim(cast(@subject as varchar)) + ' ' + cast(@note as varchar)

fetch last from allkeys into @rn, @id, @subject, @note
print 'Last: ' + cast(@rn as varchar) + '. ' + @id + ': ' + rtrim(cast(@subject as varchar)) + ' ' + cast(@note as varchar)

close allkeys

go

--5
/*Создать курсор, демонстрирующий применение конструкции CURRENT OF в секции WHERE с использованием операторов UPDATE и DELETE.*/
declare cur cursor local dynamic for
		select PROGRESS.IDSTUDENT, PROGRESS.SUBJECT, PROGRESS.NOTE
		from PROGRESS for update
declare @id varchar(10),  @subject varchar(10), @note int
open cur

fetch cur into @id, @subject, @note
print  @id + ': ' + rtrim(cast(@subject as varchar)) + ' ' + cast(@note as varchar)
delete PROGRESS where CURRENT OF cur

fetch cur into @id, @subject, @note
update PROGRESS set NOTE = NOTE + 1 where CURRENT OF cur
print  @id + ': ' + rtrim(cast(@subject as varchar)) + ' ' + cast(@note as varchar)
close cur
go
--6
/*6. Разработать SELECT-запрос, с помощью которого из таблицы PROGRESS удаляются строки, содержащие информацию о студентах, получивших оценки ниже 4 (использовать объединение таблиц PROGRESS, STUDENT, GROUPS). 
Разработать SELECT-запрос, с помощью которого в таблице PROGRESS для студента с конкретным номером IDSTUDENT корректируется оценка (увеличивается на единицу).
*/

declare below cursor local dynamic for
select PROGRESS.IDSTUDENT, STUDENT.NAME, PROGRESS.NOTE
		from PROGRESS join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where PROGRESS.NOTE < 4
		for update
declare @id varchar(10),  @name varchar(40), @note int

open below
fetch below into @id, @name, @note
print @id + ': ' + @name + ' ' + cast(@note as varchar)
delete PROGRESS where CURRENT OF below
delete STUDENT where CURRENT OF below
close below
go

declare correl cursor local dynamic for
select PROGRESS.IDSTUDENT, STUDENT.NAME, PROGRESS.NOTE
		from PROGRESS join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where PROGRESS.IDSTUDENT = 1002
		for update
declare @id varchar(10),  @name varchar(40), @note int

open correl
fetch correl into @id, @name, @note
update PROGRESS set NOTE = NOTE + 1 where current of correl
print @id + ': ' + @name + ' ' + cast(@note as varchar)
close correl
go

--8
declare faculty cursor local static for
		select FACULTY.FACULTY, PULPIT.PULPIT, count(TEACHER.TEACHER), SUBJECT.SUBJECT
		from FACULTY join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
		join TEACHER on TEACHER.PULPIT = PULPIT.PULPIT
		join SUBJECT on SUBJECT.PULPIT = PULPIT.PULPIT
		group by FACULTY.FACULTY, PULPIT.PULPIT, SUBJECT.SUBJECT
declare @faculty varchar(10), @pulpit varchar(10), @teacher int, @subject varchar(10)

open faculty
fetch faculty into @faculty, @pulpit, @teacher, @subject
while @@FETCH_STATUS = 0
begin
print 'Факультет: ' + @faculty + 
		'Кафедра: ' + @pulpit +
		'Количество преподавателей: ' + cast(@teacher as varchar) +
		' Дисциплины: ' + @subject
fetch faculty into @faculty, @pulpit, @teacher, @subject
end
close faculty
go



declare @faculty varchar(10), @pulpit varchar(10), @teacher int, @subject varchar(10), @subjectNum int, @subjecStr varchar(max)
declare faculty cursor local static for
				select FACULTY.FACULTY
				from FACULTY
open faculty
fetch faculty into @faculty
while @@FETCH_STATUS = 0
begin
		print 'Факультет: ' + @faculty
		fetch faculty into @faculty
		declare pulpit cursor local static for
						select PULPIT.PULPIT
						from PULPIT
						where PULPIT.FACULTY = @faculty
		open pulpit
			fetch pulpit into @pulpit
			while @@FETCH_STATUS = 0
			begin
				print '	Кафедра: ' + @pulpit
				fetch pulpit into @pulpit
				select @teacher = COUNT(*) from TEACHER where TEACHER.PULPIT = @pulpit
				print '		Количество преподавателей: ' + cast(@teacher as varchar)
				select @subjectNum = COUNT(*) from SUBJECT where SUBJECT.PULPIT = @pulpit
				if @subjectNum = 0
					begin
						print ' Дисциплины: нет'
					end
				else 
					begin
						declare subj cursor local for
								select SUBJECT.SUBJECT
								from SUBJECT
								where SUBJECT.PULPIT = @pulpit
						open subj
							fetch subj into @subject
							while @@FETCH_STATUS = 0
							begin
								set @subjecStr += RTRIM(@subject) + '; '
								print ' Дисциплины: ' + @subjecStr
								fetch subj into @subject
							end
						close subj
					end
			end
		close pulpit
end
close faculty