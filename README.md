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




 
### Question 5. As a database administrator, your databases have been hacked and hackers are changing the price of certain apps in the database. While it is taking some time for the IT team to neutralize the hack, you, as a responsible manager, don't want your data to be changed without tracking. You decide to implement a measure where any changes in the price can be recorded. The goal is to log the changes made to the `Price` field by the hackers.

### Solution: Implementing Triggers

To tackle this problem, we will use **SQL triggers** that will log any changes to the `Price` field of the `playstore` dataset into a separate table for future auditing.

### Steps:

1. **Create a Table for Logging Price Changes**  
   We'll create a table called `pricechagelog` to store information on each price change, including the old price, new price, app name, the type of operation (in this case, an update), and the timestamp of the change.

   ```SQL
   CREATE TABLE pricechagelog (
       app VARCHAR(255),
       old_price DECIMAL(10, 2),
       new_price DECIMAL(10, 2),
       operation_type VARCHAR(255),
       operation_date TIMESTAMP
   
   
2. **Make a Duplicate Database Table for Experimentation**  
   Since we don’t want to change the original `playstore` dataset, we create a duplicate table called `play` and insert all data from `playstore`.

   ```SQL
	  CREATE TABLE play LIKE playstore;
	
	INSERT INTO play 
	SELECT * FROM playstore;



3. **Create the Trigger for Price Changes**  
   We create an **AFTER UPDATE** trigger on the `play` table that automatically logs any changes to the `Price` field into the `pricechagelog` table.

   ```SQL
	 DELIMITER //

	CREATE TRIGGER price_change_log
	AFTER UPDATE 
	ON play 
	FOR EACH ROW
	BEGIN 
	    INSERT INTO pricechagelog(app, old_price, new_price, operation_type, operation_date) 
	    VALUES (NEW.app, OLD.price, NEW.price, 'update', CURRENT_TIMESTAMP);
	END;
	
	// DELIMITER ;


   

4. **Testing the Trigger**  
   To test the trigger, we perform an update on the `Pric`e field of the `play` table and check if the change is logged correctly in the `pricechagelog` table.
   ```SQL
	 UPDATE play t1
	SET price = 40 
	WHERE `index` = 0;
	
	SELECT * FROM play;

   
![Question 5](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/5.png)



### Question 6. Your IT team has neutralized the threat; however, hackers have made some changes in the prices. Since you had measures in place to log the changes, you can now restore the correct data into the database.

```SQL
SET sql_safe_updates = 0;

-- Dropping the price change log trigger
DROP TRIGGER price_change_log;

-- Updating the play table with the correct prices from pricechagelog
UPDATE play t1
JOIN pricechagelog t2 
ON t1.`App` = t2.`App`
SET t1.price = t2.old_price;

-- Selecting all data from the play table to verify the update
SELECT * FROM play;

```
![Question 4](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/6.png)




### Question 7. s a data person you are assigned the task of investigating the correlation between two numeric factors: app ratings and the quantity of reviews.



### Steps:

1. **Calculate the averages (means) of ratings and reviews**  

   ```SQL
	  SET @x = (SELECT ROUND(AVG(rating), 2) FROM playstore);
	SET @y = (SELECT ROUND(AVG(reviews), 2) FROM playstore);


   
2. **Step 2: Create a temporary table to calculate (x - avg(x)) and (y - avg(y)) along with their squares**  
   

   ```SQL
	  WITH temp AS (
	    SELECT *, ROUND(rat * rat, 2) AS 'sqrt_x', ROUND(rev * rev, 2) AS 'sqrt_y'
	    FROM (
	        SELECT rating, @x, reviews, @y, 
               ROUND((rating - @x), 2) AS rat, 
               ROUND((reviews - @y), 2) AS rev  
        FROM playstore
    ) t1

3. **Step 3: Calculate the numerator and denominator for Pearson Correlation**  

   ```SQL
	SELECT @numerator := ROUND(SUM(rat * rev), 2), 
       @deno_1 := ROUND(SUM(sqrt_x), 2), 
       @deno_2 := ROUND(SUM(sqrt_y), 2) 
	FROM temp;

4. **Step 4: Compute the Pearson correlation coefficient**  
  
   ```SQL
	 SELECT ROUND(@numerator / SQRT(@deno_1 * @deno_2), 2) AS correlation;

![Question 7](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/7.png)


	observation: The Pearson correlation coefficient between app ratings and the quantity of reviews is **0.07**.
	
	This indicates a very weak positive correlation, meaning that there is a slight tendency for apps with more reviews to have slightly higher ratings, but the relationship is not strong.










































