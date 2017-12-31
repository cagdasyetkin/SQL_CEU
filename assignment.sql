/* We are curious about the sales numbers of those products which have at least 8000 purchase unit price, 
and because of marketing purposes only those products which were delivered with international express method or the courier was FedEx.
Your boss requested the result in the below layout */

select d.DELIVERY_METHOD, pc.PRODUCT_CLASS_NAME, p.PRODUCT_NAME, 
s.QUANTITY as number, s.PRICE*s.QUANTITY as Revenue  

from sales s

left join delivery d
on s.DELIVERY_METHOD_ID = d.DELIVERY_METHOD_ID
left join products p
on p.PRODUCT_ID = s.PRODUCT_ID
left join product_classes pc
on pc.PRODUCT_CLASS_ID = p.PRODUCT_CLASS_ID

where p.PURCHASE_UNIT_PRICE > 8000 and
d.DELIVERY_METHOD = 'FedEx' or d.DELIVERY_METHOD = 'International Express'
order by Revenue desc;


/* In which year was product number 13 sold in the smallest quantity? */

select year(SALES_DATE) from sales
where PRODUCT_ID = 13
group by year(SALES_DATE) asc limit 1;



/* On average, which month of the year do we sell the most by quantity and revenue */

select max(Revenue), Month from (

select round(sum(QUANTITY*PRICE)) as Revenue, Month(SALES_DATE) as Month from sales
group by Month
order by sum(QUANTITY*PRICE) desc

) as Revenue;

select max(Quantity), Month from (

select round(sum(QUANTITY)) as Quantity, Month(SALES_DATE) as Month from sales
group by Month
order by sum(QUANTITY)

) as Quantity;

/*List the sales, quantity and revenue of product 72, totaled by month and year, order by revenue descending*/

select year(SALES_DATE) as Year, month(SALES_DATE) as Month, 
sum(QUANTITY) as TotQuantity, sum(QUANTITY*PRICE) as TotRevenue 
from sales
where PRODUCT_ID = 72
group by Month, Year
order by sum(QUANTITY*PRICE) desc; 

/*In which year and month was product 72 sold at highest average price, rounded to nearest whole number*/

select max(AvgPrice), year, month from (

select round(PRICE/QUANTITY) as AvgPrice, 
Month(SALES_DATE) as Month, Year(SALES_DATE) as Year from sales
where PRODUCT_ID = 72
group by Month
order by round(PRICE/QUANTITY) desc, Year

) as prod72;


/*Count the number of female customers whose names appear at least 20 times in the customer table*/
select count(FIRST_NAME), FIRST_NAME from customers
where SEX = 'Female'
group by FIRST_NAME
having count(FIRST_NAME) > 20;

/*Calculate the total revenue of sales made in 2015 February which generates at least 50.000 Ft*/
select sum(rev) as '2015 FEB Revenue' from (
select round(sum(QUANTITY*PRICE)) as rev from sales
where Month(SALES_DATE) = 2 and Year(SALES_DATE) = 2015
group by SALE_ID
having round(sum(QUANTITY*PRICE)) >= 50000) as s;

/*What proportion of 2015 total revenue do the abovementioned sales amount to? (in percentage)*/

select round((sum(FebRev)/Total)*100,1) as '2015 FEB %' from (
    select round(sum(QUANTITY*PRICE)) as FebRev from sales
	where Month(SALES_DATE) = 2 and Year(SALES_DATE) = 2015
	group by SALE_ID
	having round(sum(QUANTITY*PRICE)) >= 50000) as Feb2015, (
    
    select round(sum(QUANTITY*PRICE)) as Total from sales
	where Year(SALES_DATE) = 2015) as TOTAL2015;
  
  
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
select TopCust.SALE_ID, round((TopCust.PRICE*TopCust.QUANTITY)/TopCust.QUANTITY) as AvgPrice from (

select s.SALE_ID, s.PRICE, s.QUANTITY, sum(s.PRICE*s.QUANTITY) as purchase from customers c
left join sales s
on c.CUSTOMER_ID = s.CUSTOMER_ID
group by c.CUSTOMER_ID
having purchase > 500000) as TopCust;
