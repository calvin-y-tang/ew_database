
with 
srcref as (
	select 
		VAR_KEYCOLNAME, 
		lower(stuff(VAR_COLNAME, 1, charindex('@', VAR_COLNAME)-1, left(replace(cast(newid() as varchar(36)), '-', ''), (floor(rand()*(12-6)+6))))) as val 
	from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
    where VAR_COLNAME is not null 
        and ltrim(rtrim(VAR_COLNAME)) <> ''
)
update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
	set VAR_COLNAME = x.val
from VAR_DBINSTANCE.dbo.VAR_TABLENAME y with (nolock) 
	join srcref x with (nolock) on y.VAR_KEYCOLNAME = x.VAR_KEYCOLNAME
;
