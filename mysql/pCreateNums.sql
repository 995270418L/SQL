#创建数字辅助表
/*
 drop procedure if exists pCreateNums;
 create procedure pCreateNums(cnt int unsigned)
 begin
	declare s int unsigned default 1;
	truncate table nums;
	while s <= cnt do
		insert into nums select s;
		set s = s + 1;
	end while;
end;
*/

#上面的效率太低(100000 需要12.83s)
drop procedure if exists pCreateNums;
create procedure pCreateNums(cnt int unsigned)
begin
	declare s int unsigned default 1;
	truncate table nums;
	insert into nums select s;
	while s <= cnt do
		insert into nums select a+s from nums;
		set s = s*2;
	end while;
end;
#修改后时间为(100000 0.67s)
