use genbg;

delimiter &&
drop procedure if exists pro1;
create procedure pro1()
begin
declare i int;
set i = 7;
while i < 27 do
	insert into sys_role_office value('7',convert(i,char(64)));
set i = i + 1;
end while;
end &&
delimiter ;

call pro1();
