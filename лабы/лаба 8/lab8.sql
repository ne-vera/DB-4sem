--1
/*1. Разработать T-SQL-скрипт, в котором: 

-значения одной половины переменных вывести с помощью оператора SELECT, 
значения другой половины переменных распечатать с помощью оператора PRINT. 
Проанализировать результаты.
*/
---объявить переменные типа 
--char 
---первые две переменные проинициализировать в операторе объявления;
DECLARE @hello char(5)='Hello',
--varchar
		@world varchar(5)='world',

--datetime
		@date datetime,
--time
		@timestamp time,

--int
		@i int,
--smallint
		@smalli smallint,
--numeric
		@num numeric(12,5);

--присвоить произвольные значения следующим двум переменным с помощью оператора SET
SET @date=GETDATE();
SET @timestamp='13:13:13';

--одной из этих переменных присвоить значение, полученное в результате запроса SELECT; 
--оставшимся переменным присвоить некоторые значения с помощью оператора SELECT;
SELECT @i = (select count(*) from GROUPS),
		@smalli = (select cast(COUNT(*) as smallint) from GROUPS where PROFESSION LIKE '1-40 01 02')
--одну из переменных оставить без инициализации и не присваивать ей значения
--numeric
SELECT @hello 'char', @world 'varchar', @date 'datetime', @timestamp 'time'
print 'int i='+cast(@i as varchar(5));
print 'smallint smalli='+cast(@smalli as varchar(5));
print 'numeric num='+cast(@num as varchar(5));

--2
/*Разработать скрипт, в котором определяется общая вместимость аудиторий. 
Когда общая вместимость превышает 200, 
то вывести количество аудиторий, 
среднюю вместимость аудиторий, 
количество аудиторий, вместимость которых меньше средней,
и процент таких аудиторий. 
Когда общая вместимость аудиторий меньше 200, то вывести сообщение о размере общей вместимости*/
DECLARE @capacity int = (select SUM(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM),
@avg int, @below_avg int, @percent real
IF @capacity>200
begin
SELECT @avg=(select cast(AVG(AUDITORIUM.AUDITORIUM_CAPACITY) as int) from AUDITORIUM),
	@below_avg=(select count(*) from AUDITORIUM where AUDITORIUM_CAPACITY < (select cast(AVG(AUDITORIUM.AUDITORIUM_CAPACITY) as int) from AUDITORIUM) ),
	@percent = (100*@below_avg)/(select count(*) from AUDITORIUM)
SELECT @capacity 'Общая вместимость', @avg 'Средняя вместимость',
		@below_avg 'Количество аудиторий, вместимость которых меньше средней',
		@percent 'Процент таких аудиторий'
end
else IF @capacity<200 print 'Общая вместимость ' + cast(@capacity as varchar(3))

--3
/*3.	Разработать T-SQL-скрипт, который выводит на печать глобальные переменные: 
@@ROWCOUNT (число обработанных строк); 
@@VERSION (версия SQL Server);
@@SPID (возвращает системный идентификатор процесса, назначен-ный сервером текущему подключе-нию); 
@@ERROR (код последней ошибки); 
@@SERVERNAME (имя сервера); 
@@TRANCOUNT (возвращает уровень вложенности транзакции); 
@@FETCH_STATUS (проверка результата считывания строк результирующего набора); 
@@NESTLEVEL (уровень вложенности текущей процедуры).
Проанализировать результат.
*/
print 'число обработанных строк ' + cast(@@rowcount as varchar(3));
print 'версия SQL Server ' + cast(@@version as varchar(10));
print 'идентификатор процесса, назначенный сервером текущему подключению ' + cast(@@SPID as varchar(10));
print 'код последней ошибки ' + cast(@@ERROR as varchar(10));
print 'имя сервера ' + cast(@@SERVERNAME as varchar(15));
print 'уровень вложенности транзакции ' + cast(@@TRANCOUNT as varchar(10));
print 'проверка результата считывания строк результирующего набора ' + cast(@@FETCH_STATUS as varchar(10));
print 'уровень вложенности текущей процедуры ' + cast(@@NESTLEVEL as varchar(10));

--4
/*вычисление переменной z для различных значений исходных данных;*/
DECLARE @t int = 1, @x int = 2, @z float
	IF (@t>@x) SET @z=POWER(SIN(@t),2) 
	else IF (@t<@x) SET @z=4*(@t+@x)
	else SET @z=1-EXP(@x-1);
Print '@z= ' + cast(@z as varchar(10))

/*преобразование полного ФИО студента в сокращенное 
(например, Макейчик Татьяна Леонидовна в Макейчик Т. Л.);*/
DECLARE @name varchar(50) = (select top 1 STUDENT.NAME from STUDENT)
SET @name=SUBSTRING(@name, 0, CHARINDEX(' ', @name)+1)
+SUBSTRING(@name, CHARINDEX(' ', @name)+1, 1) +'.'
+SUBSTRING(@name, CHARINDEX(' ', @name)+1, 1) +'.'
print @name

/*поиск студентов, у которых день рождения в следующем месяце,
и определение их возраста;*/
DECLARE @nextmonth int = month(DATEADD(MONTH, 1, GETDATE()))
select STUDENT.NAME, DATEDIFF(year, STUDENT.BDAY, GETDATE())
from STUDENT
where
month(STUDENT.BDAY)= @nextmonth

/*поиск дня недели, в который студенты некоторой группы сдавали экзамен по СУБД.*/
DECLARE @group integer = 5
DECLARE @dow nvarchar(20)
SET @dow = (select top 1 DATENAME(DW,PROGRESS.PDATE)
from PROGRESS inner join STUDENT
on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
where PROGRESS.SUBJECT='СУБД' and STUDENT.IDGROUP=@group)
print @dow

--5
/*. Продемонстрировать конструкцию IF… ELSE на примере анализа данных таблиц базы данных Х_UNIVER.*/

DECLARE @am int = (select count(*) FROM STUDENT)
if(@am>100)
begin
PRINT 'Количество студентов больше 100' 
PRINT 'Количество студентов=' + cast(@am as varchar(3));
end;
ELSE
begin
PRINT 'Количество студентов меньше 100';
PRINT 'Количество студентов = ' + cast(@am as varchar(3));
end;

--6
/*Разработать сценарий, в котором с помощью CASE анализируются оценки, полученные студентами некоторого факультета при сдаче экзаменов.*/
SELECT COUNT(*), 
CASE 
			when PROGRESS.NOTE  between 0 and 3 then 'Неудовлетворительно'
			when PROGRESS.NOTE between 4 and 5 then 'Сдано'
			when PROGRESS.NOTE between 6 and 8 then 'Хорошо'
			else 'Отлично'
			end
FROM PROGRESS
GROUP BY CASE
when PROGRESS.NOTE  between 0 and 3 then 'Неудовлетворительно'
			when PROGRESS.NOTE between 4 and 5 then 'Сдано'
			when PROGRESS.NOTE between 6 and 8 then 'Хорошо'
			else 'Отлично'
			end

--7
/*Создать временную локальную таблицу из трех столбцов и 10 строк, заполнить ее и вывести содержимое. 
Использовать оператор WHILE*/

CREATE table #table
(
num float,
phrase varchar(20),
currentdate datetime
)
set nocount on
declare @i_c int = 1;
while @i_c < 10
begin
insert #table(num, phrase, currentdate)
	values(floor(3000*rand()), 'hello, world!', GETDATE())
	set @i_c = @i_c+1;
	end;
select * from #table
--8
/*Разработать скрипт, демонстрирующий использование оператора RETURN. */
declare @s_m float =3.5
print @s_m +0.5
print @s_m +1
return
print @s_m +1.5
--9
/*Разработать сценарий с ошибками, в котором используются для обработки ошибок блоки TRY и CATCH. 
Применить функции ERROR_NUMBER (код последней ошибки), 
ERROR_MESSAGE (сообщение об ошибке), 
ERROR_LINE (код последней ошибки), 
ERROR_PROCEDURE (имя процедуры или NULL), 
ERROR_SEVERITY (уровень серьезности ошибки), 
ERROR_ STATE (метка ошибки). П
роанализировать результат.*/

begin try
declare @er int = 1
set @er = @er / 0
end try

begin catch
print 'ERROR!'
print 'Error number:    ' + cast(ERROR_NUMBER() as varchar(100))
print 'Error severity:  ' + cast(ERROR_SEVERITY() as varchar(100))
print 'Error line:      ' + cast(ERROR_LINE() as varchar(100))
print 'Error state:     ' + cast(ERROR_STATE() as varchar(100))
print 'Error message:   ' + cast(ERROR_MESSAGE() as varchar(100))
end catch