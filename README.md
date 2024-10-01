# SQL_2024_case_study_02_Google_play_store


# Before Cleaning data

![before_Cleaning_data](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/before_Cleaning_data.png)

# After Cleaning data

![After_Cleaning_data](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/After_cleaning.png)

### Dropping a column name `Unnamed: 0`;
```SQL
# Droping a column 

alter table Playstore 
drop column  `Unnamed: 0`;

```

![before_Cleaning_data](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/droping_column.png)

### Dropping a row and converting the Review row into an integer datatype.

```SQL
# Droping a row that contains an unnecessary value and convert the text datatype to the Reviews column into an integer

delete from playstore where  reviews like '%M';

Alter table playstore 
modify column reviews integer;
```


### Cleaning installs column.

```SQL
# Cleaning install column and convert it into text to double

update playstore t1
set installs = replace(replace(installs,'+',''),',','');

alter table playstore
modify column installs double

```
![Cleaning installs columns](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/cleaning_install_column.png)


### cleaning  price column and converting it into the integer 

```SQL
# cleaning  price column and convert it into the integer 

select Price,replace(Price,'$','') from playstore;

update playstore t1
set Price = replace(Price,'$','')
;

alter table playstore 
modify column Price integer
;
```
![Cleaning price column](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/cleaning_price_column.png)


### Dropping null values from dataset

```SQL
# droping null value 
with temp as (select `index` from playstore where App is null or category is null 
or rating is null or reviews is null 
or size is null or installs is null or Type is null or Price is null or `Content Rating` is null or Genres is null
or `Last updated` is null or `Current Ver` is null  or `Android Ver` is null 
)

delete from playstore where `index` in (select `index` from temp)
```

### COlumn name change 

```SQL
alter table playstore

change `Content Rating` `Content_Rating` text,
change `Current Ver` `Current_Ver` text,
change `Android Ver` `Android_Ver` text
change `Last Updated` `Last_Updated` text
;
```

### Datetime column reformating

```SQL
update playstore
set last_updated = str_to_date(`Last_Updated`,'%d-%b-%y')
;


Alter table playstore
modify column Last_updated Datetime;
```
![Date time reformating](https://github.com/shanto173/SQL_2024_case_study_02_Google_play_store/blob/main/images/Datetime.png)














































































