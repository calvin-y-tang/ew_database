
with 
srcref as (
	select 
		VAR_KEYCOLNAME, 
		lower((left(replace(convert(varchar(255), newid()), '-', ''), (floor(rand()*(8-4)+4)))) + '@' + left(replace(convert(varchar(255), newid()), '-', ''), (floor(rand()*(12-6)+6))) + '.com') as val 
	from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
)
update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
	set VAR_COLNAME = x.val
from VAR_DBINSTANCE.dbo.VAR_TABLENAME y with (nolock) 
	join srcref x with (nolock) on y.VAR_KEYCOLNAME = x.VAR_KEYCOLNAME
;
