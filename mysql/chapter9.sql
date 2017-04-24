-- 索引的使用，高选择性，低结果
-- create table buy_log(
-- 	userid int unsigned not null,
--     buy_date date
-- )engine=InnoDB;
-- 
-- insert into buy_log values(1,'2009-01-01');
-- insert into buy_log values(2,'2009-01-01');
-- insert into buy_log values(3,'2009-01-01');
-- insert into buy_log values(1,'2009-02-01');
-- insert into buy_log values(3,'2009-02-01');
-- insert into buy_log values(1,'2009-03-01');
-- insert into buy_log values(1,'2009-04-01');

-- alter table buy_log add key (userid);
-- alter table buy_log add key (userid,buy_date);              -- 创建两个索引,命令执行的时候优化器会自动执行;

-- explain select * from buy_log where userid=2;        -- 这里使用的是第一个key
-- select * from buy_log a where a.userid=1 order by a.buy_date desc limit 3;

-- 三种索引的底层数据结构 B+树索引 每个索引的实现都是在引擎层实现的和引擎的选择有关 
-- InnoDB B+树索引 分为聚集索引(主键 存放表中的所有记录)和辅助索引(存放指向具体记录的指针)  书签查找: 通过辅助索引找到记录后再通过聚集索引找到记录的方式称为书签查找
-- MyISAM B+树索引 默认大小为1kb 没有聚集索引，存放的是数据在MYD文件中的位置
-- 只有访问表中很少部分数据的时候使用B+树才有效率 即高选择性
-- OLTP 应用使用B+索引是正确的，对于OLAP 应用使用B+索引 最好是联合索引，单个字段添加索引已经没必要了
