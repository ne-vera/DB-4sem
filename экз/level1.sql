use EXAM
go
/*1.	ѕодсчитать количество заказов, 
среднюю цену заказа дл€ каждого покупател€ 
и отсортировать по среднему значению цены заказа.*/
select CUST, count(ORDER_NUM),
		avg(AMOUNT)
from ORDERS
group by CUST
order by avg(AMOUNT)

/*2.	Ќайти сотрудников, у которых есть заказ стоимостью выше 15000, и отсортировать по стоимости заказа.*/
select ORDERS.REP
from ORDERS
where AMOUNT > 15000
order by AMOUNT

/*3.	Ќайти количество и среднюю цену продуктов дл€ каждого производител€.*/
select PRODUCTS.MFR_ID, SUM(PRODUCTS.QTY_ON_HAND), AVG(PRODUCTS.PRICE)
from PRODUCTS
group by MFR_ID

/*4.	Ќайти покупателей, у которых нет заказов.*/
select CUSTOMERS.COMPANY
from CUSTOMERS
where not exists (select * from ORDERS where CUSTOMERS.CUST_NUM = ORDERS.CUST)

select COMPANY, CUST
from CUSTOMERS left outer join ORDERS
on CUSTOMERS.CUST_NUM = ORDERS.CUST
where CUST is null
group by COMPANY, CUST

/*5.	Ќайти заказы, которые оформл€ли менеджеры из региона EAST.*/
SELECT ORDERS.ORDER_NUM, SALESREPS.NAME, OFFICES.REGION
from ORDERS inner join SALESREPS
on ORDERS.REP=SALESREPS.EMPL_NUM
inner join OFFICES
on SALESREPS.REP_OFFICE=OFFICES.OFFICE
where OFFICES.REGION like 'East%'