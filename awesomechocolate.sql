select * from sql_pro.dbo.awesomechocolate


-- copy of the file

select * into awesomechocolate_staging
from awesomechocolate

insert into awesomechocolate_staging
select * from awesomechocolate

--check for duplicates

select * , ROW_NUMBER() over ( partition by [Sales Person] ,Geography , product ,Amount, Units order by [Sales Person] )
as row_numb
from sql_pro.dbo.awesomechocolate_staging



with cte_table as (

select * , ROW_NUMBER() over ( partition by [Sales Person] ,Geography , product ,Amount, Units order by (select null) )
as row_numb
from sql_pro.dbo.awesomechocolate_staging

) delete from cte_table
 where row_numb >1

--- standardization


update sql_pro.dbo.awesomechocolate_staging
set amount = convert(int, amount ) -- it doesn't work

--so converting the type of column
ALTER TABLE sql_pro.dbo.awesomechocolate_staging
ALTER COLUMN amount int;


-- checking for any blank spaces 
select Units from sql_pro.dbo.awesomechocolate_staging
where Units = null or Units=''

--cleaning completed

--EDA

select Geography ,sum(amount)as total_sum from sql_pro.dbo.awesomechocolate_staging
group by  Geography -- sales by country




select top 5  product , sum(units) as sum_of_units from sql_pro.dbo.awesomechocolate_staging
group by product
order by 2 desc -- top 5 selling units 



select [Sales Person] ,Geography, sum(amount)as total_sales from sql_pro.dbo.awesomechocolate_staging
group by [Sales Person] , Geography
order by Amount desc



SELECT 
    [Sales Person] AS SalesmanName,
    Geography,
    SUM(amount) AS TotalSales
FROM 
    sql_pro.dbo.awesomechocolate_staging
GROUP BY 
    [Sales Person], Geography
ORDER BY 
    TotalSales DESC; -- Best Sales person by country



select a.product, sum(units*[cost per unit]) as total_revenue , sum(amount-(units*[cost per unit])) as total_profit from  sql_pro.dbo.awesomechocolate_staging as a 
inner join sql_pro.dbo.rates as b on a.Product=b.Product
group by a.Product
order by 3 desc -- profits by product 



-- which product to discontinue 
with cte as (
select a.product, sum(units*[cost per unit]) as total_revenue , sum(amount-(units*[cost per unit])) as total_profit from  sql_pro.dbo.awesomechocolate_staging as a 
inner join sql_pro.dbo.rates as b on a.Product=b.Product
group by a.Products
 )
select * from cte
where total_revenue>total_profit

order by 3 desc -- these products we can discontinue







