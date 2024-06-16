/*create database and make this database by default*/
create database project_flight;
use project_flight;

/*permission for any structural changes*/
set sql_safe_updates = 0;

/*create table economy by using command prompt as file size is big*/
create table economy (
date	char(10),
airline	varchar(20),
ch_code	varchar(5),
num_code	int,
dep_time	time,
source	varchar(30),
time_taken	varchar(20),
stop	varchar(10),
arr_time	time,
destination	varchar(30),
price int
);

/*extract records from table*/
select * from economy limit 50;

select count(*) total_rows from economy;

/*change data type of date column from text to date by using str_to_date*/
update economy
set date = str_to_date(date,"%d-%m-%Y");

/*update stop column data*/
update economy
set stop = if(stop = "non-stop ","non_stop",if(stop = "2+-stop","two_stop","one_stop"));
/*if condition here says that to put two_stop in place of 2+-stop and similarly change one_stop and non_stop*/


/*make another new column with the help of existing two columns*/
alter table economy
add column flight_code varchar(50);

update economy
set flight_code = concat(ch_code,"-",num_code);

/*categorized dep_time column into 6 different time period*/
select dep_time,case
when dep_time between "00:01:00" and "04:00:00" then "late_night"
when dep_time between "04:01:00" and "08:00:00" then "early_morning"
when dep_time between "08:01:00" and "12:00:00" then "morning"
when dep_time between "12:01:00" and "16:00:00" then "afternoon"
when dep_time between "16:01:00" and "20:00:00" then "evening"
else "night"
end as dep_period from economy;

/*categorized arr_time column into 6 different time period*/
select arr_time,case
when arr_time between "00:01:00" and "04:00:00" then "late_night"
when arr_time between "04:01:00" and "08:00:00" then "early_morning"
when arr_time between "08:01:00" and "12:00:00" then "morning"
when arr_time between "12:01:00" and "16:00:00" then "afternoon"
when arr_time between "16:01:00" and "20:00:00" then "evening"
else "night"
end as arr_period from economy;

/*change time_taken column from text to time*/
select time_taken,replace(replace(time_taken,"h ",":"),"m","") as time_require from economy;

/*create table business by using command prompt as file size is big*/
create table business (
date	char(10),
airline	varchar(20),
ch_code	varchar(5),
num_code	int,
dep_time	time,
source	varchar(30),
time_taken	varchar(20),
stop	varchar(10),
arr_time	time,
destination	varchar(30),
price int
);

/*extract records from table*/
select * from business limit 50;

select count(*) total_rows from business;

/*same changes done as above table*/
update business
set date = str_to_date(date,"%d-%m-%Y");

update business
set stop = if(stop = "non-stop ","non_stop",if(stop = "2+-stop","two_stop","one_stop"));

alter table business
add column flight_code varchar(50);

update business
set flight_code = concat(ch_code,"-",num_code);

select dep_time,case
when dep_time between "00:01:00" and "04:00:00" then "late_night"
when dep_time between "04:01:00" and "08:00:00" then "early_morning"
when dep_time between "08:01:00" and "12:00:00" then "morning"
when dep_time between "12:01:00" and "16:00:00" then "afternoon"
when dep_time between "16:01:00" and "20:00:00" then "evening"
else "night"
end as dep_period from business;

select arr_time,case
when arr_time between "00:01:00" and "04:00:00" then "late_night"
when arr_time between "04:01:00" and "08:00:00" then "early_morning"
when arr_time between "08:01:00" and "12:00:00" then "morning"
when arr_time between "12:01:00" and "16:00:00" then "afternoon"
when arr_time between "16:01:00" and "20:00:00" then "evening"
else "night"
end as arr_period from business;

select time_taken,replace(replace(time_taken,"h ",":"),"m","") as time_require from business;


/*no of airline in the dataset*/
select count(airline) from economy;
select count(distinct airline) from economy;


/*no of city in the dataset*/
select count(distinct source) as city_name from economy;


/*Q. no of flight share among different airlines*/
select airline, count(*) no_of_flight from economy
group by airline
order by 2 desc;


/*Q. price changes based on departure time period*/
with cte as (
select *,case
when dep_time between "00:01:00" and "04:00:00" then "late_night"
when dep_time between "04:01:00" and "08:00:00" then "early_morning"
when dep_time between "08:01:00" and "12:00:00" then "morning"
when dep_time between "12:01:00" and "16:00:00" then "afternoon"
when dep_time between "16:01:00" and "20:00:00" then "evening"
else "night"
end as dep_period from economy
)
select dep_period, round(avg(price)) price
from cte
group by dep_period
order by 2 desc;


/*Q. price changes based on arrival time period*/
with cte as (
select *,case
when arr_time between "00:01:00" and "04:00:00" then "late_night"
when arr_time between "04:01:00" and "08:00:00" then "early_morning"
when arr_time between "08:01:00" and "12:00:00" then "morning"
when arr_time between "12:01:00" and "16:00:00" then "afternoon"
when arr_time between "16:01:00" and "20:00:00" then "evening"
else "night"
end as arr_period from economy
)
select arr_period, round(avg(price)) price
from cte
group by arr_period
order by 2 desc;


/*Q. price changes with changes in route*/
with cte as (
select concat(source,"-",destination) as flight_route, price
from economy
)select flight_route, round(avg(price)) from cte group by flight_route order by 2 desc;


/*Q. price varies among different airlines monthwise*/
select airline,monthname(date), avg(price) from economy group by airline,monthname(date);
      

/*Q. common flight_code between economy and business, see price change*/       
select e.airline, flight_code, e.price eco_price, b.price busi_price
from economy e inner join business b using(flight_code);   


/*Q. no of flights price wrt stoppage*/ 
select stop, round(avg(price)) price
from economy  
group by stop order by 2;  




/* END OF CODING */




