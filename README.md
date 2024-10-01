# SQL Case Study: Google Play Store

## Index:
1. [Overview](#overview)
2. [Before Cleaning Data](#before-cleaning-data)
3. [After Cleaning Data](#after-cleaning-data)
4. [Steps and SQL Queries](#steps-and-sql-queries)
   1. [Dropping a Column](#1dropping-a-column-name-unnamed-0)
   2. [Dropping Unnecessary Rows and Converting Reviews to Integer](#2-dropping-unnecessary-rows-and-converting-reviews-to-integer)
   3. [Cleaning Installs Column](#3-cleaning-installs-column)
   4. [Cleaning Price Column and Converting to Integer](#4-cleaning-price-column-and-converting-to-integer)
   5. [Dropping Null Values](#5-dropping-null-values)
   6. [Changing Column Names](#6-column-name-change)
   7. [Datetime Column Reformatting](#7-datetime-column-reformatting)
5. [Conclusion](#conclusion)

---

## Overview:
This case study aims to clean and analyze the **Google Play Store** dataset for various market analysis tasks. Below are several key tasks performed during the process, including cleaning the data, modifying data types, and preparing the dataset for further analysis.

---

## Before Cleaning Data:
![before_cleaning_data](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/before_Cleaning_data.png)

---

## After Cleaning Data:
![after_cleaning_data](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/After_cleaning.png)

---

## Steps and SQL Queries:

### 1. Dropping a Column
We removed the unnecessary column `Unnamed: 0` using the following SQL command:


### 1.Dropping a column name `Unnamed: 0`;
```SQL
# Droping a column 

alter table Playstore 
drop column  `Unnamed: 0`;

```

![before_Cleaning_data](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/droping_column.png)

### 2. Dropping Unnecessary Rows and Converting Reviews to Integer
To clean rows with invalid data in the `Reviews` column and change its datatype to `INTEGER`:
```SQL
DELETE FROM playstore WHERE reviews LIKE '%M';

ALTER TABLE playstore 
MODIFY COLUMN reviews INTEGER;

```


### 3. Cleaning Installs Column
The `Installs` column had symbols like `+` and `,` that were removed. We also converted the column from `TEXT` to `DOUBLE` for numerical analysis:

```sql
UPDATE playstore 
SET installs = REPLACE(REPLACE(installs, '+', ''), ',', '');

ALTER TABLE playstore
MODIFY COLUMN installs DOUBLE;

```

![Cleaning installs columns](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/cleaning_install_column.png)


### 4. Cleaning Price Column and Converting to Integer
The `Price` column was cleaned by removing the dollar sign and converting the column to `INTEGER`:

```SQL
UPDATE playstore 
SET Price = REPLACE(Price, '$', '');

ALTER TABLE playstore 
MODIFY COLUMN Price INTEGER;

```
![Cleaning price column](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/cleaning_price_column.png)


### 5. Dropping Null Values
We removed rows with `NULL` values across multiple columns:

```SQL
WITH temp AS (
    SELECT `index` 
    FROM playstore 
    WHERE App IS NULL OR Category IS NULL OR Rating IS NULL 
    OR Reviews IS NULL OR Size IS NULL OR Installs IS NULL 
    OR Type IS NULL OR Price IS NULL OR `Content Rating` IS NULL 
    OR Genres IS NULL OR `Last Updated` IS NULL 
    OR `Current Ver` IS NULL OR `Android Ver` IS NULL
)
DELETE FROM playstore WHERE `index` IN (SELECT `index` FROM temp);

```

### 6. Column name change 

```SQL
alter table playstore

change `Content Rating` `Content_Rating` text,
change `Current Ver` `Current_Ver` text,
change `Android Ver` `Android_Ver` text
change `Last Updated` `Last_Updated` text
;
```

### 7. DateTime Column Reformatting
The `Last_Updated` column was converted into the `DATETIME` format for proper time-series analysis:

```SQL
UPDATE playstore
SET Last_Updated = STR_TO_DATE(`Last_Updated`, '%d-%b-%y');

ALTER TABLE playstore
MODIFY COLUMN Last_Updated DATETIME;

```
![Date time reformating](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/Datetime.png)



## SQL case study question answer

### Question 1. You're working as a market analyst for a mobile app development company. Your task is to identify the most promising categories (TOP 5) for launching new free apps based on their average ratings.


```SQL
select Category,round(avg(rating),2) as 'avg_rating' from playstore 

group by Category order by avg_rating desc limit 5;

```
![Question 1](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/1.png)


### Question 2. As a business strategist for a mobile app company, your objective is to pinpoint the three categories that generate the most revenue from paid apps. This calculation is based on the product of the app price and its number of installations.


```SQL
select Category,round(avg(revenue),2) 'avg_revenue' from (

select *,(installs*Price) as 'Revenue' from playstore
) t group by Category order by avg_revenue  desc;

```
![Question 2](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/2.png)



### Question 3. As a data analyst for a gaming company, you're tasked with calculating the percentage of games within each category. This information will help the company understand the distribution of gaming apps across different categories.

```SQL
select *, (total_apps/(select count(*) from playstore))*100 as 'category_percentage' from (
select Category,count(*) 'total_apps' from playstore
group by Category
)t order by Category_percentage desc;

```
![Question 3](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/3.png)



### Question 4. As a data analyst at a mobile app-focused market research firm you’ll recommend whether the company should develop paid or free apps for each category based on the ratings of that category.

```SQL
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

```
![Question 4](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/4.png)





























































