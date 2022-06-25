use P_MyBase;
SELECT Distinct [Название передачи], [Вид рекламы], Дата FROM ЗАКАЗЫ WHERE Дата BETWEEN '20/03/2020' AND '2022-05-06'

SELECT [Название фирмы] FROM ЗАКАЗЧИКИ WHERE [Название фирмы] like 'Р%';

SELECT Distinct [Вид рекламы] FROM УСЛУГИ WHERE [Стоимость минуты] IN (900,1500);