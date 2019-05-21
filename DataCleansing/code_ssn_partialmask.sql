
with 
srcref as (
	select 
		VAR_KEYCOLNAME, 
		(case when len(VAR_COLNAME) = 11 and VAR_COLNAME like '___-__-____' then '***-**-' + right(VAR_COLNAME, 4) else null end) as val 
	from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
	where VAR_COLNAME is not null 
        and ltrim(rtrim(VAR_COLNAME)) <> ''
        and VAR_COLNAME not like '***-**-%'
)
update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
	set VAR_COLNAME = x.val
from VAR_DBINSTANCE.dbo.VAR_TABLENAME y with (nolock) 
	join srcref x with (nolock) on y.VAR_KEYCOLNAME = x.VAR_KEYCOLNAME
;
