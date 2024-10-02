SELECT * FROM sql_case_studys.playstore;

# Droping a column 

alter table playstore 
drop column  `Unnamed: 0`;

# Droping a row that contain a unnecessarry value and convert text datatype to Reviwes column into integer

delete from playstore where  reviews like '%M';

Alter table playstore 
modify column reviews integer
;
# // Clening the installs column 

update playstore t1
set installs = replace(replace(installs,'+',''),',','')
;
select installs,replace(installs,'+',''),replace(replace(installs,'+',''),',','') from playstore;
# converting text to double datatype 
alter table playstore
modify column installs double
;

# cleaning  price column and conver it into integer 

select Price,replace(Price,'$','') from playstore;

update playstore t1
set Price = replace(Price,'$','')
;

alter table playstore 
modify column Price integer
;

select * from playstore where type = 'Paid';

# droping null value 
with temp as (select `index` from playstore where App is null or category is null 
or rating is null or reviews is null 
or size is null or installs is null or Type is null or Price is null or `Content Rating` is null or Genres is null
or `Last updated` is null or `Current Ver` is null  or `Android Ver` is null 
)

delete from playstore where `index` in (select `index` from temp)

;


# cloumn name change 

alter table playstore

change `Last Updated` `Last_Updated` text
;

# re formating datetime column 
select `Last_Updated`,str_to_date(`Last_Updated`,'%d-%b-%y') from playstore;

update playstore
set last_updated = str_to_date(`Last_Updated`,'%d-%b-%y')
;

Alter table playstore
modify column Last_updated Datetime
;















/*
1.
You're working as a market analyst for a mobile app development company. 
Your task is to identify the most promising categories (TOP 5) for launching 
new free apps based on their average ratings.

*/

select Category,round(avg(rating),2) as 'avg_rating' from playstore 

group by Category order by avg_rating desc limit 5;


/*
2.
As a business strategist for a mobile app company, your objective is 
to pinpoint the three categories that generate the most revenue from paid apps. 
This calculation is based on the product of the app price and its number of installations.

*/

select Category,round(avg(revenue),2) 'avg_revenue' from (

select *,(installs*Price) as 'Revenue' from playstore
) t group by Category order by avg_revenue  desc;





/*
3.
As a data analyst for a gaming company, you're tasked with calculating the percentage of games within each category. 
This information will help the company understand the distribution of gaming apps across different categories.

*/

select *, (total_apps/(select count(*) from playstore))*100 as 'category_percentage' from (
select Category,count(*) 'total_apps' from playstore
group by Category
)t order by Category_percentage desc;




/*
4.
As a data analyst at a mobile app-focused market research firm you’ll recommend 
whether the company should develop paid or free apps for each category based on 
the ratings of that category.


*/

with t1 as (
select Category,round(avg(Rating),2) 'avg_rating_free' from playstore where Type = 'Free'
group by Category
),
t2 as (
select Category,round(avg(Rating),2) 'avg_rating_paid' from playstore where Type = 'Paid'
group by category
)


select t1.category,avg_rating_free,avg_rating_paid,
case 
	when avg_rating_free > avg_rating_paid then 'made_free_apps'
    else 'made_paid_apps'
end as 'suggestion'
from t1
join t2 
on t1.Category = t2.Category;








/*

Suppose you're a database administrator your databases have been
hacked and hackers are changing price of certain apps on the database, 
it is taking long for IT team to neutralize the hack, however you as a
 responsible manager don’t want your data to be changed, do some measure 
 where the changes in price can be recorded as you can’t stop hackers from making changes.

*/
# in order to solve this problem we have to use triggers  
# in order to store the changing inforamtion i need to create a table 

create table pricechagelog(
app varchar(255),
old_price decimal(10,2),
new_price decimal(10,2),
operation_type varchar(255),
operation_date timestamp 
);

# make a duplicate database for playstore i don't want to change anyting to my dataset 

create table play like playstore;

# inserting value into play dataset 
insert into play (
select * from playstore
);
 
# Creating a trigger

Delimiter //
create TRIGGER price_change_log
after update 
on play 
for each row
begin 
	insert into pricechagelog(app,old_price,new_price,operation_type,operation_date) values(
    new.app,old.price,new.price,'update',current_timestamp);

end;
// Delimiter ;
 
 
 update play t1
 set price = 40 where `index` = 0;
select * from play;






/*

Your IT team have neutralized the threat; however, hackers have made some changes in the prices, 
but because of your measure you have noted the changes, 
now you want correct data to be inserted into the database again.


*/

set sql_safe_updates = 0;

drop trigger price_change_log;

 update play t1
 join pricechagelog t2 on t1.`App` = t2.`App`
 set t1.price = t2.old_price;

select * from play;

select * from play;





/*

As a data person you are assigned the task of investigating the correlation 
between two numeric factors: app ratings and the quantity of reviews.

*/
# (x-avg(x))  (y-avg(y))   (x-avg(x))2  (y-avg(y))2  

set @x = (select round(avg(rating),2) from playstore);
set @y = (select round(avg(reviews),2) from playstore);

with temp as (
select *,round(rat*rat,2) as 'sqrt_x', round(rev*rev,2) as 'sqrt_y' from(

select rating , @x ,reviews,@y, round((rating-@x),2) as rat, round((reviews-@y),2) as rev  from playstore

)t1

)

select @numerator := round(sum(rat*rev),2), @deno_1 := round(sum(sqrt_x),2),@deno_2 := round(sum(sqrt_y),2) from t;

select round(@numerator/sqrt(@deno_1*@deno_2),2) as corrletion;






















































