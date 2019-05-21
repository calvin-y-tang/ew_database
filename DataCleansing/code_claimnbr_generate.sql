
with 
srcref as (
	select 
		VAR_KEYCOLNAME, 
		convert(varchar(4), (cast(rand(checksum(newid())) * 8998 as int) + 1000)) 			
			+ '-' + convert(varchar(4), (cast(rand(checksum(newid())) * 8998 as int) + 1000)) as val 
	from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
)
update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
	set VAR_COLNAME = x.val
from VAR_DBINSTANCE.dbo.VAR_TABLENAME y with (nolock) 
	join srcref x with (nolock) on y.VAR_KEYCOLNAME = x.VAR_KEYCOLNAME
;
