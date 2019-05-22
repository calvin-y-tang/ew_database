

declare 
	@maxlen int,
	@ftype varchar(100)
;

select @ftype = d.name, @maxlen = c.max_length
from sys.objects a 
	inner join sys.schemas b on a.schema_id = b.schema_id 
	inner join sys.columns c on a.object_id = c.object_id
	inner join sys.types d on c.system_type_id = d.system_type_id
where a.type = 'U' and c.is_computed = 0
	and lower(a.name) = 'VAR_TABLENAME'
	and lower(c.name) = 'VAR_COLNAME'
	and d.name in ('char','nchar','nvarchar','varchar','text','ntext');

if @ftype in ('text','ntext')	
begin

	with 
	srcref as (
		select 
			VAR_KEYCOLNAME, 
			(case 
				when patindex('%\%', VAR_COLNAME) > 0 then 'VAR_REPLACEMENTVALUE' + substring(VAR_COLNAME, patindex('%\%', VAR_COLNAME), len(VAR_COLNAME))
				when patindex('%/%', VAR_COLNAME) > 0 then 'VAR_REPLACEMENTVALUE' + substring(VAR_COLNAME, patindex('%/%', VAR_COLNAME), len(VAR_COLNAME))
				else VAR_COLNAME
				end) as val 
		from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
		where VAR_COLNAME is not null 
			and ltrim(rtrim(VAR_COLNAME)) <> ''
			and VAR_COLNAME not like ('VAR_REPLACEMENTVALUE%')
	)
	update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
		set VAR_COLNAME = x.val
	from VAR_DBINSTANCE.dbo.VAR_TABLENAME y with (nolock) 
		join srcref x with (nolock) on y.VAR_KEYCOLNAME = x.VAR_KEYCOLNAME
	;

end
else
begin

	with 
	srcref as (
		select 
			VAR_KEYCOLNAME, 
			(case 
				when patindex('%\%', VAR_COLNAME) > 0 then substring('VAR_REPLACEMENTVALUE' + substring(VAR_COLNAME, patindex('%\%', VAR_COLNAME), len(VAR_COLNAME)), 1, @maxlen)
				when patindex('%/%', VAR_COLNAME) > 0 then substring('VAR_REPLACEMENTVALUE' + substring(VAR_COLNAME, patindex('%/%', VAR_COLNAME), len(VAR_COLNAME)), 1, @maxlen)
				else VAR_COLNAME
				end) as val
		from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
		where VAR_COLNAME is not null 
			and ltrim(rtrim(VAR_COLNAME)) <> ''
			and VAR_COLNAME not like ('VAR_REPLACEMENTVALUE%')
	)
	update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
		set VAR_COLNAME = x.val
	from VAR_DBINSTANCE.dbo.VAR_TABLENAME y with (nolock) 
		join srcref x with (nolock) on y.VAR_KEYCOLNAME = x.VAR_KEYCOLNAME
	;


end