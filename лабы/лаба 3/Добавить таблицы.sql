use P_MyBase;
CREATE table УСЛУГИ
([Вид рекламы] nvarchar(50),
[Длительность в минутах] numeric(6,3),
[Стоимость минуты] money,
constraint ADVERT_TYPE_PK primary key([Вид рекламы])
) on FG1;

CREATE table ЗАКАЗЧИКИ
([Название фирмы] nvarchar(50),
Фамилия nvarchar(40),
Имя nvarchar(40),
Отчество nvarchar(40),
Телефон nchar(11),
БИК nchar(9),
ИНН nchar(12),
constraint FIRM_NAME_PK primary key([Название фирмы])
)on FG1;

CREATE table ЗАКАЗЫ
([Название передачи] nvarchar(50),
[Название фирмы] nvarchar(50) constraint FIRM_NAME_FK foreign key references ЗАКАЗЧИКИ([Название фирмы]),
[Вид рекламы] nvarchar(50) constraint ADVERT_TYPE_FK foreign key references УСЛУГИ([Вид рекламы]),
Дата smalldatetime,
Рейтинг tinyint constraint RATE_CHK check(Рейтинг>=0 AND Рейтинг<=100),
constraint SHOW_NAME_PK primary key([Название передачи]),
)on FG1;
