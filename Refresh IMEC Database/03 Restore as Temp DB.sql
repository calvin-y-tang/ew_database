/*
We will use tmpIMEC database name when we prepare the database
Once we are done, we will detach and attach it with the final name
*/
USE master
GO
RESTORE DATABASE [tmpIMEC]
 FROM  DISK = N'G:\Backup\IMECentricEW_Copy.bak'
 WITH  FILE = 1,
 MOVE N'IMETrackSQL_dat' TO N'D:\SQLData\tmpIMEC.mdf',
 MOVE N'IMETrackSQL_log' TO N'E:\SQLLog\tmpIMEC.ldf',
 NOUNLOAD,  REPLACE,  STATS = 25
GO


