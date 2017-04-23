-- 事务

-- completion_type变量对commit work 的影响
-- 当competion_type = 1的时候 
-- drop table if exists t;
-- create table t(a int primary key);

-- set @@completion_type = 1 ;     -- commit work 会自动生成一个链事务
-- begin;     -- 开启事务 == start transaction （在存储过程中只能使用start transaction因为begin ... end联系在一起）
-- insert into t select 1; 
-- commit work;     -- 提交 此时表中存在这一记录,理论上事务也已经没了
-- 
-- insert into t select 2;   -- 插入第二个数据2
-- 
-- rollback;    -- 回退，如果没有事务存在数据并不会受影响,但是查询表t可以得到只有一个数据1存在，2不见了.   这是由于commit work 在completion_type为1的时候提交事务会自动生成一个链事务。
    -- 两种方法解决，一. 将competion_type设为0,二是使用commit 命令替代commit work;

-- 当competion_type=2 的时候
-- set @@completion_type = 2;               -- commit work == commit and release（断开与服务器的连接）
-- begin;
-- insert into t select 1;
-- commit work;
-- select @@version;     -- 测试与服务器的连接    result ---->>>  Error Code: 2013. Lost connection to MySQL server during query

-- rollback to savepoint 并没有真正意义上的结束一个事务
-- begin;
-- insert into t select 1;
-- 
-- savepoint t1;
-- 
-- insert into t select 2;
-- 
-- savepoint t2;
-- 
-- release savepoint t1;     -- 释放point t1
-- 
-- insert into t select 2;   -- error ,主键重复
-- 
-- rollback to savepoint t2;    -- 回滚到savepoint t2
-- 
-- select * from t;   -- 查看t中的数据   a   1  2
-- 
-- rollback;    --  回滚事务，如果rollback会提交事务的话 下一个select 语句结果中全部数据依然会有,否则，数据全部回滚,null
-- 
-- select * from t;   -- 查看t中数据   a  1  2

-- 循环提交事务导致时间耗费严重
-- load1

-- drop procedure if exists load1;
-- delimiter &&
-- 
-- create procedure load1(count int unsigned)
-- begin
-- 	declare s int unsigned default 1;
--     declare c char(80) default repeat('a',80);
--     while s <= count do
-- 		insert into t select c;
-- 		commit;
-- 		set s= s+1;
--     end while;
-- end &&
-- 
-- delimiter ;

-- call load1(10000);   32.825 sec


-- load3 加快时间的版本
-- delimiter %%
-- 
-- create procedure load3(count int unsigned)
-- begin
-- 	declare s int unsigned default 1;
--     declare c char(80) default repeat('b',80);
--     start transaction;
--     while s <= count do
--     insert into t select c;
--     set s = s + 1;
--     end while;
--     commit;
-- end %%
-- 
-- delimiter ;

-- truncate t;
-- call load3(10000) 0.214 sec

-- 在事务中使用自动回滚
-- delimiter %%
-- 
-- create procedure sp_auto_rollback_demo()
-- begin 
--     declare exit handler for sqlexception begin rollback; select -1; end;             -- 捕捉sqlexception 然后依次执行 rollback; select -1 ;命令
-- 	start  transaction;
--     insert into b select 1;
--     insert into b select 2;
--     insert into b select 1;    -- 人为制造异常
--     insert into b select 3;
--     commit;
--     select 1;
-- end %%
-- 
-- delimiter ;

-- call sp_auto_rollback_demo();    显示-1    虽然知道发生了错误，但是作为开发者必须要知道到底发生了什么错误.
-- select * from b;      结果肯定为空 

