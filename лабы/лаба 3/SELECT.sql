use P_MyBase;
SELECT * FROM ЗАКАЗЧИКИ;

SELECT [Название фирмы], Фамилия FROM ЗАКАЗЧИКИ;

SELECT COUNT(*) FROM ЗАКАЗЧИКИ;

SELECT  [Вид рекламы] [Дешевле 1100] FROM УСЛУГИ where [Стоимость минуты] < 1100;

SELECT Distinct TOP(2) [Вид рекламы], [Стоимость минуты] FROM УСЛУГИ Order by [Стоимость минуты] Desc;