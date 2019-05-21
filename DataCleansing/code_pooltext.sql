
with 
pd as (
	select 
		top 5000 
		pdata.VAR_COLNAME, row_number() over (order by newid()) as rn
	from (
		select distinct VAR_COLNAME 
		from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock) 
		where coalesce(VAR_COLNAME,'') <> '' 
			and len(VAR_COLNAME) > 8
	) pdata
)
,
srcref as (
	select 
		VAR_KEYCOLNAME,
		cast(rand(checksum(newid())) * 5000 as int) + 1 as rn
	from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
	where coalesce(VAR_COLNAME,'') <> '' 
)

update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
	set VAR_COLNAME = z.VAR_COLNAME
from VAR_DBINSTANCE.dbo.VAR_TABLENAME x with (nolock)
	left join srcref y with (nolock) on x.VAR_KEYCOLNAME = y.VAR_KEYCOLNAME
	left join pd z with (nolock) on y.rn = z.rn
;