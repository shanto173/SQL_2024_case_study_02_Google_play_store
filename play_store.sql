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







