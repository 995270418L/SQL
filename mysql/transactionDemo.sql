drop procedure if exists transfer_proc;
delimiter $$
create procedure transfer_proc(in from_account int,in to_account int, in money int)
begin
	declare continue handler for 1690
begin
	rollback;
end;
	start transaction;
	update account set balance = balance - money where account_no = from_account;
	update account set balance = balance + money where account_no = to_account;
	commit;
end $$
delimiter ;
