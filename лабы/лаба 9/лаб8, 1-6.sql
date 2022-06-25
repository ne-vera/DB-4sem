use UNIVER
go

--1
/*С помощью SSMS определить все индексы, которые имеются в БД UNIVER. 
Определить, какие из них являются кластеризованными, а какие некластеризованными. */
exec sp_helpindex 'AUDITORIUM'
exec sp_helpindex 'AUDITORIUM_TYPE'
exec sp_helpindex 'FACULTY'
exec sp_helpindex 'GROUPS'
exec sp_helpindex 'PROFESSION'
exec sp_helpindex 'PULPIT'
exec sp_helpindex 'STUDENT'
exec sp_helpindex 'SUBJECT' --некластеризованный индекс SUBJECT_NAME
exec sp_helpindex 'TEACHER'

/*Создать временную локальную таблицу.
Заполнить ее данными (не менее 1000 строк). */
CREATE table #EXPLRE
(
	ID int identity(1,1),
	TITLE varchar(100)
)

SET nocount on; --не выводить сообщения о выводе строк
DECLARE @i int = 0;
WHILE @i < 1000
begin
	INSERT #EXPLRE(TITLE)
		values(REPLICATE('string',10));
IF (@i % 100 = 0) print @i;
SET @i = @i + 1;
end;

/*Разработать SELECT-запрос. 
По-лучить план запроса и определить его стоимость. */
select * from #EXPLRE where ID between 1500 and 2500 order by ID

checkpoint;
DBCC DROPCLEANBUFFERS

/*Создать кластеризованный индекс, уменьшающий стоимость SELECT-запроса.*/
create clustered index #EXPLRE_CL on #EXPLRE(ID asc)
--drop index #EXPLRE_CL

--2
/*Создать временную локальную таб-лицу. 
Заполнить ее данными (10000 строк или больше). */
CREATE table #task2
(
	ID int identity(1,1),
	NUM int,
	TITLE varchar(100)
);

set nocount on;
DECLARE @in int = 0;
WHILE @in < 10000
begin
	INSERT #task2(NUM, TITLE)
		values(FLOOR(3000*RAND()),REPLICATE('string',10));
SET @in = @in + 1;
end;

/*Разработать SELECT-запрос. 
Получить план запроса и определить его стоимость. */

select count(*)[количество строк] from #task2
select * from #task2

create index #task2_cl on #task2(ID,NUM)
--drop index #task2_cl

select * from #task2 where NUM > 1500 and ID >1000
select * from #task2 order by ID,NUM

select * from #task2 where NUM = 300 and ID >100
--3
/*Создать некластеризованный индекс покрытия, уменьшающий сто-имость SELECT-запроса. */
CREATE index #task2 on #task2(NUM) INCLUDE (ID)

SELECT	ID from #task2 where NUM>100

--4
/*Создать некластеризованный фильтруемый индекс, уменьшаю-щий стоимость SELECT-запроса.*/
CREATE index #task2_where on #task2(ID) where (ID>=1500 and ID<9000)
SELECT ID from #task2 where ID between 5000 and 8000

--5
/*Создать некластеризованный ин-декс. Оценить уровень фрагментации индекса. */
CREATE index #task2_NUM on #task2(NUM)

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
	FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
	OBJECT_ID(N'#task2'), NULL, NULL, NULL) ss
	JOIN sys.indexes ii on ss.object_id = ii.object_id
	and ss.index_id=ii.index_id
	WHERE name is not null


INSERT top(10000) #task2(NUM, TITLE) select NUM, TITLE from #task2	

ALTER index #task2_NUM on #task2 reorganize;
ALTER index #task2_NUM on #task2 rebuild with (online = off)

--6
drop index #task2_NUM on #task2

CREATE index #task2_NUM on #task2(NUM)
			with (fillfactor = 65)

INSERT top(50) #task2(NUM, TITLE) select NUM, TITLE from #task2	
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
	FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
	OBJECT_ID(N'#task2'), NULL, NULL, NULL) ss
	JOIN sys.indexes ii on ss.object_id = ii.object_id
	and ss.index_id=ii.index_id
	WHERE name is not null

--7