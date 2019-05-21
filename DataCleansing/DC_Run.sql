
--// Execution Instructions:
--// 1. Connect to desired database server and instance using SQL Server Management Studio (or equivalent)
--// 2. Open DC_Run.sql (this file) using SQL Server Management Studio
--// 3. Change / Modify variables and run configuration
--// 4. Execute entire script file using F5 (Execute)

--// change to the correct target database
use [IMECentricEW];

declare 
	@SCRIPT_PATH varchar(1000),
	@SCRIPT_FILE nvarchar(max),
	@DBInstance varchar(200),
	@SCRIPT_STR nvarchar(1000),
	
	@tablename varchar(500),
	@colname varchar(200),
	@keycolname varchar(200),
	@dcseq int,
	@rvalue varchar(500),
	@actionname varchar(500),
	@scriptfilename varchar(200),
	@scriptcode varchar(max),

	@SQL varchar(max)
;


--// Set the relative local path of the files on the database server where this is being executed from
set @SCRIPT_PATH = 'C:\\WSpace\\ExamWorksProjects\\Databases\\DataCleansing';


--// change to the correct target database
set @DBInstance = 'IMECentricEW';


declare 
	@DC_DebugShowExecPrintout		bit = 1,

	@DC_Remove						bit = 1,
	@DC_CheckCreateInit				bit = 1,
	
	@DC_ShowConfiguredData			bit = 1,

	@DC_RunTableTruncate			bit = 0,
	@DC_RunDataCleaning				bit = 0,

	@DC_DatabaseLogShrink			bit = 0
;


--// Uncomment below if xp_cmdshell and advance options is needed
--// ========== ========== ========== ========== ========== ========== ========== ==========
----// enable advance options 
--exec sp_configure 'show advanced options', 1;
--reconfigure;

----// enable xp_cmdshell feature
--exec sp_configure 'xp_cmdshell', 1;
--reconfigure;



--// remove all data clean tables
--// ========== ========== ========== ========== ========== ========== ========== ==========
if @DC_Remove = 1
begin
	set @SCRIPT_STR = N'select @SCRIPT_FILE = f.BulkColumn from openrowset(bulk ''' + @SCRIPT_PATH + '\\DC_Remove.sql'', single_clob) f';
	exec sp_executesql @SCRIPT_STR, N'@SCRIPT_FILE nvarchar(max) output', @SCRIPT_FILE output;
	set @SCRIPT_FILE = replace(@SCRIPT_FILE, 'VAR_DBINSTANCE', @DBInstance);
	if @DC_DebugShowExecPrintout = 1
	begin
		print @SCRIPT_FILE; --// for debugging
	end	
	exec (@SCRIPT_FILE);
end



--// check and create the tables for data clean if they don't exists
--// ========== ========== ========== ========== ========== ========== ========== ==========
if @DC_CheckCreateInit = 1
begin
	set @SCRIPT_STR = N'select @SCRIPT_FILE = f.BulkColumn from openrowset(bulk ''' + @SCRIPT_PATH + '\\DC_CheckCreateInit.sql'', single_clob) f';
	exec sp_executesql @SCRIPT_STR, N'@SCRIPT_FILE nvarchar(max) output', @SCRIPT_FILE output;
	set @SCRIPT_FILE = replace(@SCRIPT_FILE, 'VAR_DBINSTANCE', @DBInstance);
	if @DC_DebugShowExecPrintout = 1
	begin
		print @SCRIPT_FILE; --// for debugging
	end	
	exec (@SCRIPT_FILE);
end



--// show the configured table / column / and actions
--// ========== ========== ========== ========== ========== ========== ========== ==========
if @DC_ShowConfiguredData = 1
begin
	select 
		x.ID,
		x.TableName, 
		(case when x.KeyColName is not null then x.KeyColName else '' end) as KeyColName,
		(case when x.ColName is not null then x.ColName else '' end) as ColName, 		
		x.ClearTable, x.Seq as Sequence, x.replacevalue as ReplacementValue, 
		y.ActionName, y.ScriptFileName
	from DCTableFieldAction x with (nolock)
		left join DCAction y with (nolock) on x.actionid = y.actionid	
	where x.Clean = 1
	order by x.seq, x.tablename, x.colname
end



--// run the table truncate
--// ========== ========== ========== ========== ========== ========== ========== ==========
if @DC_RunTableTruncate = 1
begin

	declare dc_clearcur cursor
	for
		select distinct tablename, seq 
		from DCTableFieldAction with (nolock) 
		where clean = 1 and cleartable = 1
		order by seq, tablename;

	open dc_clearcur;

	fetch next from dc_clearcur into @tablename, @dcseq;

	while @@fetch_status = 0
	begin

		if object_id(@tablename) is not null
		begin
		
			if exists (
				select t.name 
				from sys.schemas as s
					join sys.tables as t on s.schema_id = t.schema_id
				where exists (select 1 from sys.identity_columns where object_id = t.object_id)
					and t.name = @tablename
			)
			begin
				set @sql = 'truncate table ' + @DBInstance + '.dbo.' + @tablename + '; dbcc checkident(''' + @DBInstance + '.dbo.' + @tablename + ''', reseed, 1);';
				if @DC_DebugShowExecPrintout = 1
				begin
					print @sql; --// for debugging
				end			
				exec (@sql);
			end
			else
			begin
				set @sql = 'truncate table ' + @DBInstance + '.dbo.' + @tablename + ';';
				if @DC_DebugShowExecPrintout = 1
				begin
					print @sql; --// for debugging
				end	
				exec (@sql);
			end

		end

		fetch next from dc_clearcur into @tablename, @dcseq;

	end

	close dc_clearcur;
	deallocate dc_clearcur;

end



--// perform main data clean loop
--// ========== ========== ========== ========== ========== ========== ========== ==========
if @DC_RunDataCleaning = 1
begin

	declare dc_cur cursor
	for
		select x.tablename, x.colname, x.keycolname, x.seq, x.replacevalue, y.actionname, y.scriptfilename, y.code 
		from DCTableFieldAction x with (nolock) 
			left join DCAction y with (nolock) on x.actionid = y.actionid
		where x.clean = 1 and x.actionid is not null and (y.scriptfilename is not null or y.code is not null)
		order by x.seq, x.tablename, x.colname;

	open dc_cur;

	fetch next from dc_cur into @tablename, @colname, @keycolname, @dcseq, @rvalue, @actionname, @scriptfilename, @scriptcode;

	while @@fetch_status = 0
	begin
	
		-- print 'Table: ' + @tablename + ' -- Field: ' + @colname + ' ---- seq: ' + convert(varchar(20), @dcseq) + ' - ' + @actionname + ' - ' + @scriptfilename; --// for debugging

		set @SCRIPT_STR = N'select @SCRIPT_FILE = f.BulkColumn from openrowset(bulk ''' + @SCRIPT_PATH + '\\' + @scriptfilename + '.sql'', single_clob) f';
		exec sp_executesql @SCRIPT_STR, N'@SCRIPT_FILE nvarchar(max) output', @SCRIPT_FILE output;

		set @SCRIPT_FILE = replace(@SCRIPT_FILE, 'VAR_DBINSTANCE', @DBInstance);
		
		set @SCRIPT_FILE = replace(@SCRIPT_FILE, 'VAR_TABLENAME', @tablename);

		if @keycolname is not null		
		set @SCRIPT_FILE = replace(@SCRIPT_FILE, 'VAR_KEYCOLNAME', @keycolname);
		
		if @colname is not null		
		set @SCRIPT_FILE = replace(@SCRIPT_FILE, 'VAR_COLNAME', @colname);
		
		if @rvalue is not null
		set @SCRIPT_FILE = replace(@SCRIPT_FILE, 'VAR_REPLACEMENTVALUE', (case when @rvalue is not null then @rvalue else 'null' end));

		if @DC_DebugShowExecPrintout = 1
		begin
			print @SCRIPT_FILE; --// for debugging
		end

		exec (@SCRIPT_FILE);
	
		fetch next from dc_cur into @tablename, @colname, @keycolname, @dcseq, @rvalue, @actionname, @scriptfilename, @scriptcode;

	end

	close dc_cur;
	deallocate dc_cur;

end



--// shring the database files
--// ========== ========== ========== ========== ========== ========== ========== ==========
if @DC_DatabaseLogShrink = 1
begin
	set @SCRIPT_STR = N'select @SCRIPT_FILE = f.BulkColumn from openrowset(bulk ''' + @SCRIPT_PATH + '\\DC_DBShrink.sql'', single_clob) f';
	exec sp_executesql @SCRIPT_STR, N'@SCRIPT_FILE nvarchar(max) output', @SCRIPT_FILE output;
	set @SCRIPT_FILE = replace(@SCRIPT_FILE, 'VAR_DBINSTANCE', @DBInstance);
	exec (@SCRIPT_FILE);
end






