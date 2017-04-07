-- 数据库表连续范围的问题
-- 创建模拟表实现连续范围的出现
-- create table test(a int not null auto_increment,name char(10),primary key(a))engine=InnoDB charset=utf8;
-- 
-- insert into test values(null,"liu"),(null,"li"),(null,"zhang"),(null,"fu"),(null,"wang"),(8,"tao"),(9,"yang"),(11,"ai"),(12,"dou"),(13,"guo");

-- 找寻不连续点
-- 第一步找寻不连续点的起始点
-- select a from test as A where not exists (select a from test as B where A.a+1 = B.a) and A.a < (select max(a) from test);

-- 第二步找寻结束点(小于最大值)
-- select a+1 as start_range,(select min(a)-1 from test as C where C.a > D.a) as end_range from
--   (select a from test as A where not exists (select a from test as B where A.a+1 = B.a) and A.a < (select max(a) from test)) as D;

-- 简化而来就是这样
-- select a+1 as start_range,(select min(a)-1 from test as C where C.a > A.a) as end_range
-- from test as A where not exists(select a from test as B where A.a + 1 = B.a ) and A.a < (select max(a) from test);

-- 创建储存过程来填补这个空白部分
-- drop procedure if exists fill_up;
-- delimiter $$
-- create procedure fill_up(in start_range int, in end_range int)
-- begin
-- 	while start_range<= end_range do
-- 		insert into test values(start_range,"demo");
--         set start_range = start_range +1;
-- 	end while;
-- end $$
-- delimiter ;

-- 全自动化过程(有待完善)
-- drop procedure if exists fill_up;
-- delimiter $$
-- create procedure fill_up()
-- begin
-- 	-- 首先找到start_range 和 end_range
-- 	select a+1 as start_range ,(select min(a)-1 from test as C where C.a > A.a) as end_range from test as A where not exists(select a from test as B where A.a+1 = B.a) and A.a < (select max(a) from test);
-- -- 	where start_range <= end_range do
-- -- 		insert into test values(start_range,"demo");
-- -- 		set start_range = start_range +1;
-- -- 	end while;
-- end; $$
-- delimiter ;
-- call fill_up();

