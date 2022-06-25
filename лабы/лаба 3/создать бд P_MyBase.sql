USE master;
go
CREATE database P_MyBase
on primary 
(name=N'P_MyBase_mdf', filename=N'D:\учеба\БД\P_MyBase_mdf.mdf',
size = 1024Kb, maxsize=UNLIMITED, filegrowth=1024Kb),
(name = N'P_MyBase_ndf', filename = N'D:\учеба\БД\P_MyBase_ndf.ndf', 
   size = 10240KB, maxsize=1Gb, filegrowth=25%),
filegroup FG1
( name = N'P_MyBase_fg1_1', filename = N'D:\учеба\БД\P_MyBase_fgq-1.ndf', 
   size = 10240Kb, maxsize=1Gb, filegrowth=25%),
( name = N'P_MyBase_fg1_2', filename = N'D:\учеба\БД\P_MyBase_fgq-2.ndf', 
   size = 10240Kb, maxsize=1Gb, filegrowth=25%)
log on 
(name=N'P_MyBase_log', filename=N'D:\учеба\БД\P_MyBase_log.ldf',
size = 1024Kb, maxsize=2048Gb, filegrowth=10%)
go
