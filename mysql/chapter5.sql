-- 体验self join(层次结构时特别有用)
-- 员工与经理问题
-- create table emp(
-- 	emp_no int primary key,
--     mgr_no int,
--     emp_name varchar(30)
-- );
-- 
-- insert into emp values(1,null,'David'),(4,1,'Jim'),(3,1,'Tommy'),(2,3,'Mariah'),(5,3,'Selina'),(6,4,'John'),(8,3,'Monty');

-- 从表中找寻每个员工的经理姓名
-- select a.emp_name as emp_name ,b.emp_name as mgr_name from emp a left join emp b on a.mgr_no = b.emp_no;

-- 滑动订单问题
-- create table MonthlyOrders(
-- 	ordermonth date,
--     ordernum int unsigned,
--     primary key(ordermonth)
-- );
-- 
-- insert into MonthlyOrders values("2010-02-01",23);
-- insert into MonthlyOrders values("2010-03-01",26);
-- insert into MonthlyOrders values("2010-04-01",24);
-- insert into MonthlyOrders values("2010-05-01",27);
-- insert into MonthlyOrders values("2010-06-01",26);
-- insert into MonthlyOrders values("2010-07-01",32);
-- insert into MonthlyOrders values("2010-08-01",34);
-- insert into MonthlyOrders values("2010-09-01",30);
-- insert into MonthlyOrders values("2010-10-01",31);
-- insert into MonthlyOrders values("2010-11-01",32);
-- insert into MonthlyOrders values("2010-12-01",33);
-- insert into MonthlyOrders values("2011-01-01",32);
-- insert into MonthlyOrders values("2011-02-01",34);
-- insert into MonthlyOrders values("2011-03-01",34);
-- insert into MonthlyOrders values("2011-04-01",38);
-- insert into MonthlyOrders values("2011-05-01",35);
-- insert into MonthlyOrders values("2011-06-01",49);
-- insert into MonthlyOrders values("2011-07-01",56);
-- insert into MonthlyOrders values("2011-08-01",55);
-- insert into MonthlyOrders values("2011-09-01",74);
-- insert into MonthlyOrders values("2011-10-01",75);
-- insert into MonthlyOrders values("2011-11-01",14);
-- insert into MonthlyOrders values("2011-12-01",14);

-- 去的每个月上一年的订单数量

-- select date_format(a.ordermonth,"%Y%m") as fromdate, date_format(b.ordermonth,"%Y%m") as enddate, sum(c.ordernum) as orders from MonthlyOrders as a
-- 	left join MonthlyOrders as b on b.ordermonth = date_add(a.ordermonth,interval 11 month)
--     left join MonthlyOrders as c on c.ordermonth between a.ordermonth and b.ordermonth
--     group by a.ordermonth,b.ordermonth;

-- Block Nested-Loops Join算法,当表的列没有索引时使用缓存的方法来加快联接速率(join_buffer_size)

-- create table employees_noindex(
-- 	emp_no int(11) not null,
--     birth_date date not null,
--     firth_name varchar(14) not null,
--     last_name varchar(16) not null,
--     gender enum('M','F') not null,
--     hire_date date not null
-- );
-- create table titles_noindex(
-- 	emp_no int(11) not null,
--     title varchar(50) not null,
--     from_date date not null,
--     to_date date default null
-- );
-- insert into employees_noindex select * from employees;
-- insert into titles_noindex select * from titles;

-- 使用Block Nexted Loop(无需索引)
-- explain select b.emp_no,a.title,a.from_date,a.to_date from employees_noindex b inner join titles_noindex a on a.emp_no=b.emp_no;
 
-- 使用Simple Nested Loop算法(需要索引)
-- explain select b.emp_no ,a.title,a.from_date,a.to_date from employees b inner join titles a on  a.emp_no = b.emp_no;5

-- 数据库之间的连接操作 垂直连接
-- drop table if exists x;
-- drop table if exists y;
-- create table x( a varchar(1));
-- create table y(a varchar(1));
-- insert into x values('a'),('b'),('c');
-- insert into y values('a'),('b');

-- select a as m from x
-- union
-- select 1 as n from dual
-- union 
-- select 'abc' as o from dual
-- union
-- select now() as p from dual;

-- Except 功能的实现　实现　返回位于第一个输入中但不位于第二个输入中的不重复行

-- left join实现方法
-- select x.a from x left join y on x.a=y.a where y.a is null ;  

-- not exists 实现方法
-- select a from x where not exists (select a from y where y.a = x.a);

-- 但以上实现方法存在一个当null值时的问题，看
-- drop table if exists x;
-- drop table if exists y;
-- create table x(a varchar(1),b varchar(1));
-- create table y(a varchar(1),b varchar(1));
-- insert into x values('a','b'),('b',null),('c','d'),('c','d'),('c','d'),('c','c'),('e','f');
-- insert into y values('a','b'),('c','c'),('c','d');

-- 理论上结果为('e','f'); 看实际结果
-- left join
-- select distinct x.a,x.b from x left join y on x.a=y.a and x.b = y.b where y.a is null and y.b is null;
-- not exists
-- select distinct * from x where not exists (select distinct * from y where y.a=x.a and y.b = x.b);

-- 老问题 null值使用 " = " 比较会返回null值
-- 修改如下（原理是是使用count计数来找出不同的(1))
-- select * from (select distinct 'X' as resource,a,b from x union all select 'Y',a,b from y) as A
-- group by a,b  -- 按照a,b分组
-- having count(*)=1  and A.resource='X'; 