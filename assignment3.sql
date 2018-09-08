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
