-- set rowcount 10000;

-- while (1 = 1)
-- begin
-- 	begin transaction;

-- 	update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
--         set VAR_COLNAME = (case when convert(bit, 'VAR_REPLACEMENTVALUE') = 1 then convert(bit, 1) else convert(bit, 0) end)
-- 	where 
-- 		VAR_COLNAME is null 
-- 		or (VAR_COLNAME is not null and VAR_COLNAME <> convert(bit, 'VAR_REPLACEMENTVALUE'))
-- 	;

-- 	if @@rowcount = 0
-- 	begin
-- 		commit transaction;
-- 		break;
-- 	end

-- 	commit transaction;
-- end
-- set rowcount  0; 


with 
srcref as (
	select 
		VAR_KEYCOLNAME, 
		convert(bit, 'VAR_REPLACEMENTVALUE') as val 
	from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
)
update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
	set VAR_COLNAME = x.val
from VAR_DBINSTANCE.dbo.VAR_TABLENAME y with (nolock) 
	join srcref x with (nolock) on y.VAR_KEYCOLNAME = x.VAR_KEYCOLNAME
;
