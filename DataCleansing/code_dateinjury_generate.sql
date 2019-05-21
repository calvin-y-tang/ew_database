
declare @datestart date = dateadd(year, -10, getdate());
declare @dateend date = dateadd(month, -1, getdate());

with 
srcref as (
	select 
		VAR_KEYCOLNAME, 
		dateadd(day,abs(checksum(newid())) % ( 1 + datediff(day,@datestart,@dateend)),@datestart) as val 
	from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
)
update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
	set VAR_COLNAME = x.val
from VAR_DBINSTANCE.dbo.VAR_TABLENAME y with (nolock) 
	join srcref x with (nolock) on y.VAR_KEYCOLNAME = x.VAR_KEYCOLNAME
;
