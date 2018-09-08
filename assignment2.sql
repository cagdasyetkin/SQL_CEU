/* On average, which month of the year do we sell the most by quantity and revenue */

select max(Revenue), Month from (

select round(sum(QUANTITY*PRICE)) as Revenue, Month(SALES_DATE) as Month from sales
group by Month
order by sum(QUANTITY*PRICE)

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
