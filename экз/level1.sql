use EXAM
go
/*1.	���������� ���������� �������, 
������� ���� ������ ��� ������� ���������� 
� ������������� �� �������� �������� ���� ������.*/
select CUST, count(ORDER_NUM),
		avg(AMOUNT)
from ORDERS
group by CUST
order by avg(AMOUNT)

/*2.	����� �����������, � ������� ���� ����� ���������� ���� 15000, � ������������� �� ��������� ������.*/
select ORDERS.REP
from ORDERS
where AMOUNT > 15000
order by AMOUNT

/*3.	����� ���������� � ������� ���� ��������� ��� ������� �������������.*/
select PRODUCTS.MFR_ID, SUM(PRODUCTS.QTY_ON_HAND), AVG(PRODUCTS.PRICE)
from PRODUCTS
group by MFR_ID

/*4.	����� �����������, � ������� ��� �������.*/
select CUSTOMERS.COMPANY
from CUSTOMERS
where not exists (select * from ORDERS where CUSTOMERS.CUST_NUM = ORDERS.CUST)

select COMPANY, CUST
from CUSTOMERS left outer join ORDERS
on CUSTOMERS.CUST_NUM = ORDERS.CUST
where CUST is null
group by COMPANY, CUST

/*5.	����� ������, ������� ��������� ��������� �� ������� EAST.*/
SELECT ORDERS.ORDER_NUM, SALESREPS.NAME, OFFICES.REGION
from ORDERS inner join SALESREPS
on ORDERS.REP=SALESREPS.EMPL_NUM
inner join OFFICES
on SALESREPS.REP_OFFICE=OFFICES.OFFICE
where OFFICES.REGION like 'East%'