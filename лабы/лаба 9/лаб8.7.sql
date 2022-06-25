use P_MyBase
go

select * from ЗАКАЗЫ
create index #Заказы on ЗАКАЗЫ([Название передачи] asc)

create index #Услуги on УСЛУГИ([Стоимость минуты]) where ([Стоимость минуты] > 900)
select [Стоимость минуты] from УСЛУГИ where [Стоимость минуты] = 1000
