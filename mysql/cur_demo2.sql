# 探究游标较慢的原因,
# 和count操作对比
delimiter &&
create procedure cur_demo2()
begin
	declare done int default 0;
	declare _emp_no int;
	declare _dept_no varchar(10);
	declare ret int default 0;
	declare cur1 cursor for select emp_no,dept_no from dept_emp;
	declare continue handler for not found set done = 1;
	open cur1;
	read_loop:loop
	fetch cur1 into _emp_no,_dept_no;
	if done then
		leave read_loop;
	set ret = ret + 1;
	end if;
	end loop;
	close cur1;
end &&
delimiter ;
