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














































































