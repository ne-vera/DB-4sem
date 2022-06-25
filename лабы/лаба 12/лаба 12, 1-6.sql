use UNIVER
GO
--1
/*. Разработать хранимую процедуру без параметров с именем PSUBJECT. 
Процедура формирует результи-рующий набор на основе таблицы SUBJECT, 
аналогичный набору, представленному на рисунке: 
К точке вызова процедура должна возвращать ко-личество строк, выведенных в результирующий набор.*/
create procedure PSUBJECT
as
begin
	declare @count int = (select count(*) from SUBJECT)
	select * from SUBJECT
	return @count
end

declare @count_output int = 0
exec @count_output = PSUBJECT
print 'количество строк' + cast(@count_output as varchar)

--drop procedure PSUBJECT

--2
/*Найти процедуру PSUBJECT с помощью обозревателя объектов (Object Explorer) SSMS
и через контекстное меню создать сценарий на изменение процдуры оператором ALTER.
Изменить процедуру PSUBJECT, созданную в задании 1, таким образом,
чтобы она принимала два па-раметра с именами @p и @c. 
Параметр @p является входным, имеет тип VARCHAR(20) и значение по умолчанию NULL. 
Параметр @с является выходным, имеет тип INT.
Процедура PSUBJECT должна формировать результирующий набор, аналогичный набору, 
представленному на рисунке выше, но при этом содержать строки,
соответствующие коду кафедры, заданному параметром @p. 
Кроме того, процедура должна формировать значение выходного параметра @с, 
равное количеству строк в результирующем наборе, 
а также возвращать значение к точке вызова, равное общему количеству дисциплин (количеству строк в таблице SUBJECT). 
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
	print 'Параметры: @p = ' + @p + '; @c = ' + cast(@c as varchar)
	select SUBJECT.SUBJECT код, SUBJECT.SUBJECT_NAME Дисциплина, SUBJECT.PULPIT кафедра
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
exec @count = PSUBJECT @p = 'ИСиТ', @c = @param output
print 'Кол-во дисциплин на кафедре: ' + cast(@param as varchar)
print 'Кол-во дисциплин всего: ' + cast(@count as varchar)
go
--3
/*Создать временную локальную таблицу с именем #SUBJECT. 
Наименование и тип столбцов таблицы должны соответствовать столбцам результирующего набора процедуры PSUBJECT, разработанной в задании 2. 
Изменить процедуру PSUBJECT таким образом, чтобы она не содержала выходного параметра.
Применив конструкцию INSERT… EXECUTE с модифицированной процедурой PSUBJECT,
добавить строки в таблицу #SUBJECT. 
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
	Код varchar(10) primary key,
	Дисциплина varchar(50),
	Кафедра varchar(10)
)
insert #SUBJECT exec PSUBJECT @p = 'ИСиТ'
select * from #SUBJECT

--4
/*Разработать процедуру с именем PAUDITORIUM_INSERT. 
Процедура принимает четыре входных параметра: @a, @n, @c и @t. 
Параметр @a имеет тип CHAR(20), 
параметр @n имеет тип VARCHAR(50), 
параметр @c имеет тип INT и значение по умолчанию 0,
параметр @t имеет тип CHAR(10).
Процедура добавляет строку в таблицу AUDITORIUM. 
Значения столбцов AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY и AUDITORIUM_TYPE добавляемой строки 
задаются соответственно параметрами @a, @n, @c и @t.
Процедура PAUDITORIUM_INSERT должна применять механизм TRY/CATCH для обработки ошибок.
В случае возникновения ошибки, процедура должна формировать сообщение,
содержащее код ошибки, уровень серьезности и текст сообщения в стандартный выходной поток. 
Процедура должна возвращать к точке вызова значение -1 в том случае, если произошла ошибка и 1, ес-ли выполнение успешно. 
Опробовать работу процедуры с различными значе-ниями исходных данных, которые вставляются в таб-лицу.
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
			print 'Код ошибки:  ' + cast(ERROR_NUMBER() as varchar)
			print 'Уровень серьезности: ' + cast(ERROR_SEVERITY() as varchar)
			print 'Текст сообщения:   ' + cast(ERROR_MESSAGE() as varchar)
		return -1
	end catch
end

declare @out int;
exec @out = PAUDITORIUM_INSERT @a = '136-1', @n = '136-1', @c = 60, @t = 'ЛК'
print 'Код ошибки ' + cast(@out as varchar)
 go

 --5
 /*Разработать процедуру с именем SUBJECT_REPORT,
формирующую в стандартный выходной поток отчет со списком дисциплин на конкретной кафедре. 
В отчет должны быть выведены краткие названия (поле SUBJECT) из таблицы SUBJECT в одну строку через запятую (использовать встроенную функцию RTRIM). 
Процедура имеет входной параметр с именем @p типа CHAR(10), который предназначен для указания кода кафедры.
В том случае, если по заданному значению @p невозможно определить код кафедры,
процедура должна генерировать ошибку с сообщением ошибка в параметрах. 
Процедура SUBJECT_REPORT должна возвращать к точке вызова количество дисциплин, отображенных в отчете. 
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
		raiserror('Ошибка',11,1)
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
	print 'Ошибка '
	print 'Текст сообщения:   ' + cast(ERROR_MESSAGE() as varchar)
	print 'Строка ' + cast(@ROWCOUNT as varchar) 
end catch
end

go

declare @count int = 0
exec @count = SUBJECT_REPORT @p = 'ИСиТ'
print 'Дисциплины: ' + cast(@count as varchar)

--6
/*6. Разработать процедуру с именем PAUDITORIUM_INSERTX. 
Процедура принимает пять входных параметров: @a, @n, @c, @t и @tn. 
Параметры @a, @n, @c, @t аналогичны параметрам процедуры PAUDITORIUM_INSERT. 
Дополнительный параметр @tn является входным, имеет тип VARCHAR(50), 
предназначен для ввода значения в столбец AUDITORIUM_TYPE.AUDITORIUM_TYPENAME.
Процедура добавляет две строки. 
Первая строка добавляется в таблицу AUDITORIUM_TYPE. 
Значения столбцов AUDITORIUM_TYPE и AUDITORIUM_ TYPENAME добавляемой строки задаются соответственно параметрами @t и @tn. 
Вторая строка добавляется путем вызова процедуры PAUDITORIUM_INSERT.

Добавление строки в таблицу AUDITORIUM_TYPE и вызов процедуры PAUDITORIUM_INSERT должны выполняться в рамках одной явной транзакции с уровнем изолированности SERIALIZABLE. 
В процедуре должна быть предусмотрена обработка ошибок с помощью механизма TRY/CATCH. Все ошибки должны быть обработаны с выдачей соответствующего сообщения в стандартный выходной поток. 
Процедура PAUDITORIUM_INSERTX должна возвращать к точке вызова значение -1 в том случае, если произошла ошибка и 1, если выполнения процедуры завершилось успешно. */



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
			print 'Код ошибки:  ' + cast(ERROR_NUMBER() as varchar)
			print 'Уровень серьезности: ' + cast(ERROR_SEVERITY() as varchar)
			print 'Текст сообщения:   ' + cast(ERROR_MESSAGE() as varchar)
		if @@TRANCOUNT > 0 
				rollback tran
		return -1
	end catch
end

go
exec PAUDITORIUM_INSERTX @a = '111-1', @n = '111-1', @c = 50, @t = 'TYPE-1', @tn = 'TYPE-1'

/*все дисциплины у определенного препода(параметр)*/
--процедура
drop procedure SUBJ_PR
go
create procedure SUBJ_PR @teacher varchar(50)
as
begin
	select distinct TIMETABLE.SUBJECT from TIMETABLE
	where TIMETABLE.TEACHER = @teacher
end

go
execute SUBJ_PR @teacher = 'СМЛВ'

--функция
GO
drop function SUBJ_FUNC

go
create function SUBJ_FUNC (@teacher varchar(50)) returns @subjects table ([Предмет] varchar(50))
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
select * from SUBJ_FUNC('СМЛВ')