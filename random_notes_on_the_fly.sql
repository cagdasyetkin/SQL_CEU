select year(s.SALES_DATE) year, month(s.SALES_DATE) month, count(*), sum(s.QUANTITY*s.PRICE) from sales s
group by year, month;

select year(s.SALES_DATE) year, count(*), sum(s.QUANTITY*s.PRICE) from sales s
group by year, quarter(s.SALES_DATE);

select year(s.SALES_DATE) year,
case when month(s.SALES_DATE) in (1,2,3) then 1
when month(s.SALES_DATE) in (4,5,6) then 2
when month(s.SALES_DATE) in (7,8,9) then 3
when month(s.SALES_DATE) in (10,11,12) then 4 end as q,

sum(s.QUANTITY*s.PRICE),
count(*)
from sales s

group by year, q;


select c.CUSTOMER_ID, c.FIRST_NAME, c.LAST_NAME, count(s.SALE_ID), count(co.COMPLAINT_ID), 
count(co.COMPLAINT_ID)/count(s.SALE_ID) from customers c


left join sales s
on c.CUSTOMER_ID = s.CUSTOMER_ID
left join complaints co
on s.SALE_ID = co.SALE_ID

group by c.CUSTOMER_ID

having (count(co.COMPLAINT_ID)/count(s.SALE_ID) * 100) > 0;


select p.PRODUCT_ID, p.WAREHOUSE_QUANTITY, s.QUANTITY from products p
left join sales s
on s.PRODUCT_ID = p.PRODUCT_ID
where p.WAREHOUSE_QUANTITY > 0;


/*joins*/
/* inner join; intersect of two tables */
/* cartesian is the full version */
select * from sales s left join customers c
on s.CUSTOMER_ID = c.CUSTOMER_ID;

select * from products p
left join sales s
on p.PRODUCT_ID = s.PRODUCT_ID
where p.PRODUCT_ID = 1;

select * 
from sales s
left join products p
on s.PRODUCT_ID = p.PRODUCT_ID
left join customers c
on s.CUSTOMER_ID = c.CUSTOMER_ID
left join delivery d
on s.DELIVERY_METHOD_ID = d.DELIVERY_METHOD_ID
where s.SALE_ID = 999;

select sum(QUANTITY*PRICE) as Cust_Spend from customers c
left join sales s
on c.CUSTOMER_ID = s.CUSTOMER_ID
left join delivery d
on d.DELIVERY_METHOD_ID= s.DELIVERY_METHOD_ID
where d.DELIVERY_METHOD = 'Home Delivery' and year(s.SALES_DATE) = 2015;


select CUSTOMER_ID, FIRST_NAME, LAST_NAME from customers
where age > 30;

select SALE_ID, CUSTOMER_ID, year(SALES_DATE) from sales
where year(SALES_DATE) = 2015;

select SALE_ID, CUSTOMER_ID, year(SALES_DATE) from sales
where year(SALES_DATE) = 2015 and
CUSTOMER_ID in (
				select CUSTOMER_ID, FIRST_NAME, LAST_NAME from customers
				where age > 30
				);
                

select max(DELIVERY_COST), DELIVERY_METHOD, COURIER from delivery
where DELIVERY_COST in (

select max(DELIVERY_COST) from delivery);

select 
first_name,
last_name,
substr(first_name, 1, 3) as id
from customers;

select
concat(FIRST_NAME, '', MIDDLE_NAME, ' ', LAST_NAME) as id
from customers;

select 
sum(Age) as _total_age, 
avg(Age) as _mean_age,
min(Age) as _min_age,
max(Age) as _max_age
from customers;

select count(*)
from customers;

select(select sum(age) from ceu.customers)/(select count(*) 
from ceu.customers);


select avg(age) from ceu.customers;

select * from customers where age = '';

select sum(QUANTITY) from sales;

select  avg(DELIVERY_COST) from delivery;

select min(Age) from customers;

select * from customers
where age = (select min(Age) from customers);

select min(first_name) from customers;

select 
first_name,
last_name,
concat(first_name, LAST_NAME, Age) as id
from customers;

select
concat(FIRST_NAME, '', MIDDLE_NAME, ' ', LAST_NAME) as id
from customers
where age = (select min(Age) from customers);

select distinct(count(PRODUCT_ID)) from products;

select count(distinct(product_id)) from products;

select sex, city, avg(Age) as avg_age from customers
where age  <>''
group by city, sex;


select DELIVERY_METHOD_ID, PRODUCT_ID, sum(QUANTITY) from sales
group by DELIVERY_METHOD_ID, PRODUCT_ID;

/*Find out customer who has purchased more than 100.000Ft*/
select 
CUSTOMER_ID, sum(QUANTITY*PRICE) as sales
from sales
group by CUSTOMER_ID
having sum(QUANTITY*PRICE) > 100000


select *
from ceu.sales s
left join ceu.customers c
on s.CUSTOMER_ID = c.CUSTOMER_ID
;
select *
from ceu.products p
left join ceu.sales s
on p.PRODUCT_ID = s.PRODUCT_ID
where p.PRODUCT_ID = 1
;
select *
from ceu.sales s
left join ceu.products p
on  p.PRODUCT_ID = s.PRODUCT_ID
left join ceu.customers c
on s.CUSTOMER_ID = c.CUSTOMER_ID
left join ceu.delivery d
on s.DELIVERY_METHOD_ID = d.DELIVERY_METHOD_ID
where s.SALE_ID = 999;

select sum(s.PRICE*s.QUANTITY) as Customer_Spending
from ceu.sales s
left join ceu.delivery d
on s.DELIVERY_METHOD_ID = d.DELIVERY_METHOD_ID
where d.DELIVERY_METHOD = "Home Delivery" and 
year (s.SALES_DATE) = 2015
;
select p.PRODUCT_NAME, sum(s.QUANTITY) as quan
from ceu.sales s
left join ceu.customers c
on s.CUSTOMER_ID = c.CUSTOMER_ID
left join ceu.products p
on p.PRODUCT_ID = s.PRODUCT_ID
where year(s.SALES_DATE) = 2015 and c.SEX = "female"
group by p.PRODUCT_NAME
order by quan desc;

select p.PRODUCT_NAME, p.WAREHOUSE_QUANTITY, sum(s.QUANTITY) as quan
from ceu.sales s
left join ceu.products p
on p.PRODUCT_ID = s.PRODUCT_ID
left join ceu.customers c
on s.CUSTOMER_ID = c.CUSTOMER_ID
where c.AGE > 65
group by p.PRODUCT_NAME, p.WAREHOUSE_QUANTITY
order by quan desc
;


select * from sales;
select * from products;

/*Is there any product which we made no sell in 2015 February?*/

select * from products p
left join (select * from sales where year(sales.SALES_DATE) = 2015 and month(sales.SALES_DATE) = 2) as s
on s.PRODUCT_ID = p.PRODUCT_ID
where s.QUANTITY is null
group by p.PRODUCT_NAME;



/*How many customers are there who have spent more than 500.000Ft purchasing from us? */
select count(CUSTOMER_ID) from
(select c.CUSTOMER_ID, sum(s.PRICE*s.QUANTITY) as purchase from customers c
left join sales s
on c.CUSTOMER_ID = s.CUSTOMER_ID
group by c.CUSTOMER_ID
having purchase > 500000) as MyDataTable;
/*What is the average amount they spent on each purchase?*/
select c.CUSTOMER_ID, 
	   sum(s.PRICE*s.QUANTITY) as Purchase, 
       round(sum(s.PRICE*s.QUANTITY)/sum(s.QUANTITY)) as AvgPrice 
from customers c
left join sales s
on c.CUSTOMER_ID = s.CUSTOMER_ID
group by c.CUSTOMER_ID
having purchase > 500000;


/*How much profit did we make in 2015 (Assume that orders> 20.000Ft are eligible for free shipping) ?*/

/*without free shipping*/
select sum((s.PRICE*s.QUANTITY)-(d.DELIVERY_COST)) as profit  from sales s

left join delivery d
            
on d.DELIVERY_METHOD_ID=s.DELIVERY_METHOD_ID
where year(s.SALES_DATE) = 2015;

/*now I can create a new delivery table where there is only cost for sales < 20000*/
select d.DELIVERY_COST, d.DELIVERY_METHOD_ID from sales s
left join delivery d
on d.DELIVERY_METHOD_ID=s.DELIVERY_METHOD_ID
where s.PRICE*s.QUANTITY < 20000;
/*I can use this table to filter*/

/*How much profit did we make in 2015 (Assume that orders> 20.000Ft are eligible for free shipping) ?*/
select sum((sales.PRICE*sales.QUANTITY)-(del.DELIVERY_COST)) as profit  from sales

left join (select d.DELIVERY_COST, d.DELIVERY_METHOD_ID from sales s
			left join delivery d
			on d.DELIVERY_METHOD_ID=s.DELIVERY_METHOD_ID
			where s.PRICE*s.QUANTITY < 20000) del
            
on del.DELIVERY_METHOD_ID=sales.DELIVERY_METHOD_ID
where year(sales.SALES_DATE) = 2015;


