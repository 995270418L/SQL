-- create table customers(
-- 	customer_id varchar(10) not null primary key,
--     city varchar(10) not null
-- );
-- insert into customers select '163','HangZhou';
-- insert into customers select '9you','ShangHai';
-- insert into customers select 'TX','HangZhou';
-- insert into customers select 'baidu','HangZhou';
-- create table orders(
-- 	order_id int not null auto_increment primary key,
--     customer_id varchar(10)
-- );
-- insert into orders select null,'163';
-- insert into orders select null,'163';
-- insert into orders select null,'9you';
-- insert into orders select null,'9you';
-- insert into orders select null,'9you';
-- insert into orders select null,'TX';
-- insert into orders select null,null;

-- 查询来自杭州且订单数小于2的客户,并且查询出他们的订单数量，查询结果按订单数大小来排列。
--  select c.customer_id,count(o.order_id) as number from customers as c
-- 	left join orders o on c.customer_id = o.customer_id   # left join 保留的是左边的表而不是右边的表,右边的表以null填充
--     where c.city="HangZhou"
--     group by c.customer_id
--     having number < 2
--     order by number desc;
-- 上面的sql执行顺序 1.from语句　形成虚拟表VT1 2. ON语句 根据o.customer_id=c..customer_id 形成虚拟表VT2 3. left join语句 将orders匹配的行作为外部行加入到VT2中,形成虚拟表VT3
--                 4.where语句 对VT3的表过滤,形成VT4 5.group by语句 根据group by中的列，对VT4中的记录进行分组操作，产生VT5。
--                 6. having语句 进行having过滤,形成VT6虚拟表    7.select语句 第二次执行select操作，选择指定的列，插入到虚拟表VT8中
--                 8. distinct语句　去重操作　　形成VT8表　　　　　9. order by语句　根据它的值排序
