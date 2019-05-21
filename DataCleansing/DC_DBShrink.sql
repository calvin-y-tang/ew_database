use [VAR_DBINSTANCE];

--// shrinking the database
DBCC SHRINKFILE (N'IMETrackSQL_dat' , 1);
DBCC SHRINKFILE (N'IMETrackSQL_log' , 1);


-- --// list the database name and the file names
-- select 
-- 	a.name, 
-- 	b.name from 
-- sys.databases a
--     inner join sys.master_files b
--     on a.database_id = b.database_id
-- where
--     a.name not in ( 'master', 'model', 'msdb', 'tempdb' )