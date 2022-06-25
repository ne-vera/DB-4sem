use P_MyBase;
ALTER Table ЗАКАЗЧИКИ ADD [Расчетный счет] nchar(20);
SELECT * FROM ЗАКАЗЧИКИ;

ALTER Table ЗАКАЗЧИКИ ADD Местонахождение nvarchar(20) default 'Минск';

ALTER Table ЗАКАЗЧИКИ DROP column [Расчетный счет];