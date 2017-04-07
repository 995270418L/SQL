create procedure pGetWorksDay (s datetime,e datetime)
begin
	select floor(days/7)*5 + days%7 
		- case when 6 between wd and wd+days%7-1 then 1 else 0 end
		- case when 7 between wd and wd+days%7-1 then 1 else 0 end
from
	(select datediff(e,s)+1 as days, weekday(s)+1 as wd) as a;
end;
