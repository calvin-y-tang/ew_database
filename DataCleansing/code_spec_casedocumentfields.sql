
set rowcount 100000;

while (1 = 1)
begin
	begin transaction;

	with 
	srcref as (
		select 
			VAR_KEYCOLNAME, 
			'Sample File' as [Description],
			'SampleFile.txt' as sFileName
		from VAR_DBINSTANCE.dbo.VAR_TABLENAME with (nolock)
		where 
			([Description] is not null and [Description] <> 'Sample File')
			or (sFileName is not null and sFileName <> 'SampleFile.txt')
	)
	update VAR_DBINSTANCE.dbo.VAR_TABLENAME 
		set 
			[Description] = x.[Description],
			sFileName = x.sFileName
	from VAR_DBINSTANCE.dbo.VAR_TABLENAME y with (nolock) 
		join srcref x with (nolock) on y.VAR_KEYCOLNAME = x.VAR_KEYCOLNAME
	;

	if @@rowcount = 0
	begin
		commit transaction;
		break;
	end

	commit transaction;
end
set rowcount  0; 