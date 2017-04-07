
-- ２.4.1生日问题

-- use test;
-- create table employees like employees.employees;
-- insert into employees select * from employees.employees limit 10;
-- #人为的插入一个员工，
-- insert into employees select 10011,'1972-02-29','Jiang','David','M','1992-2-20';
-- select * from employees;

#得到所有员工的出生信息
-- se计算生日日期脚本
-- 1.取得时间差。2.得最近的年份(curr,next)。3.得最近的日期('2-28,2-29')特殊处理。 4.和当前日期比较得出最近的生日日期
-- 
-- select name,birthday,
-- 	if(curr > today,curr,next) as birth_day
-- from(	
-- 	select name,birthday,today,
-- 		date_add(curr,interval if(day(birthday) = 29 && day(curr) = 28, 1 , 0) day) as curr,
-- 		date_add(next,interval if(day(birthday) = 29 && day(next) = 28, 1 , 0) day) as next
-- 	from(
-- 		select name,birthday,today,
-- 			date_add(birthday,interval diff year) as curr,
-- 			date_add(birthday,interval diff+1 year) as next 
-- 		from (
-- 			select concat(last_name," ",first_name) as name, 
-- 				birth_date as birthday,
-- 				(year(now()) - year(birth_date)) as diff , 
-- 				now() as today 
-- 			from employees
-- 		) as a
-- 	) as b
-- ) as c

-- 2.4.2 星期数的问题
-- 计算当前日期是星期几 weekday函数
-- set @a = '2017-3-12';
-- set lc_time_names='zh_CN';   #设置语言
-- select dayname(now());       #显示日期

-- 根据1900-01-01是周一来计算
-- set @a = '2017-03-12';
-- select datediff(now(),'1900-01-01') % 7;  # 1+6 = 7

-- 按周分组

-- select week('2010-12-31'),week('2011-01-01');  #其实2011-01-01是跨年份的一周,不应该为0的，说明week函数不适合按周分组
-- 解决办法: 和1900-01-01等准确日期做比较可以准确的出当前周数 
-- 建表测试
-- create table sales(id int auto_increment primary key,date datetime not null,cost int unsigned not null );
-- insert into sales(date,cost) values('2010-12-31',100);  #52
-- insert into sales(date,cost) values('2011-01-01',200);  #0,周六,第二天就是下一周了
-- insert into sales(date,cost) values('2011-01-02',100);  #1
-- insert into sales(date,cost) values('2011-01-06',100);  #1
-- insert into sales(date,cost) values('2011-01-10',100);  #2
-- -- week函数按周分组
-- select week(date),sum(cost) from sales group by week(date);

-- 选取参照日期(1900-01-01)
-- select floor(datediff(date,'1900-01-01') /7 ) as a , sum(cost) from sales group by floor(datediff(date,'1900-01-01') /7 );  #实现了按周统计，但返回的是距离1900-01-01的周数，改变一下
-- 按每周的开始和结束时间来显示
--  select date_add('1900-01-01',interval floor(datediff(date,'1900-01-01') /7 ) * 7 day) as week_start, 
--  	   date_add('1900-01-01',interval floor(datediff(date,'1900-01-01') / 7 ) * 7 + 6 day) as week_end, 
--         sum(cost),date from sales group by id,floor(datediff(date,'1900-01-01') /7);

-- 写一个存储过程计算两个日期之间的工作日(不算节假日)
-- drop procedure if exists pGetWorksDay;
-- delimiter $$
-- create procedure pGetWorksDay(s datetime,e datetime)
-- begin
-- 	select (floor(days/7)*5 + days%7 
-- 		- case when 6 between wd and wd+days%7-1 then 1 else 0 end
-- 		- case when 7 between wd and wd+days%7-1 then 1 else 0 end) as workdays
-- 	from
-- 		(select datediff(e,s)+1 as days, weekday(s)+1 as wd) as a;
-- end;
-- delimiter ;
-- call pGetWorksDay('2005-01-01','2015-12-31');
-- call pGetWorksDay('2017-01-01','2017-03-21');
-- call pGetWorksDay('2017-01-01','2018-01-01');
