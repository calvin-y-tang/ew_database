
with 
srcref as (
	select 
		VAR_KEYCOLNAME, 
		convert(int, 'VAR_REPLACEMENTVALUE') as val 
	from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
	where VAR_COLNAME is not null and VAR_COLNAME <> convert(int, 'VAR_REPLACEMENTVALUE')
)
update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
	set VAR_COLNAME = x.val
from VAR_DBINSTANCE.dbo.VAR_TABLENAME y with (nolock) 
	join srcref x with (nolock) on y.VAR_KEYCOLNAME = x.VAR_KEYCOLNAME
;