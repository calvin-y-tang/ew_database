BACKUP DATABASE EWDataRepository
 TO  DISK = N'D:\SQLData\Backup\EWDataRepository_Copy.bak'
 WITH
 NOFORMAT, INIT, COPY_ONLY, SKIP, NOREWIND, NOUNLOAD,
 STATS = 25
GO

BACKUP DATABASE IMECentricMaster
 TO  DISK = N'D:\SQLData\Backup\IMECentricMaster_Copy.bak'
 WITH
 NOFORMAT, INIT, COPY_ONLY, SKIP, NOREWIND, NOUNLOAD,
 STATS = 25
GO

BACKUP DATABASE GP
 TO  DISK = N'D:\SQLData\Backup\GP_Copy.bak'
 WITH
 NOFORMAT, INIT, COPY_ONLY, SKIP, NOREWIND, NOUNLOAD,
 STATS = 25
GO



--Restore in Windows
USE Master
GO
RESTORE DATABASE IMECentricMaster
 FROM  DISK = N'D:\SQLData\Backup\IMECentricMaster_Copy.bak'
 WITH  FILE = 1,
 MOVE N'IMECentricMaster' TO N'D:\SQLData\IMECentricMaster.mdf',
 MOVE N'IMECentricMaster_log' TO N'D:\SQLData\IMECentricMaster_log.ldf',
 NOUNLOAD,  REPLACE,  STATS = 25
GO
RESTORE DATABASE EWDataRepository
 FROM  DISK = N'D:\SQLData\Backup\EWDataRepository_Copy.bak'
 WITH  FILE = 1,
 MOVE N'EWDataRepository' TO N'D:\SQLData\EWDataRepository.mdf',
 MOVE N'EWDataRepository_log' TO N'D:\SQLData\EWDataRepository_log.ldf',
 NOUNLOAD,  REPLACE,  STATS = 25
GO


--Restore in WSL
--Data Location in the host machine:
--\\wsl.localhost\docker-desktop\mnt\docker-desktop-disk\data\docker\volumes\EW_SQLData\_data
USE Master
GO
RESTORE DATABASE IMECentricMaster
 FROM  DISK = N'/var/opt/mssql/backup/IMECentricMaster_Copy.bak'
 WITH  FILE = 1,
 MOVE N'IMECentricMaster' TO N'/var/opt/mssql/data/IMECentricMaster.mdf',
 MOVE N'IMECentricMaster_log' TO N'/var/opt/mssql/data/IMECentricMaster_log.ldf',
 NOUNLOAD,  REPLACE,  STATS = 25
GO
RESTORE DATABASE EWDataRepository
 FROM  DISK = N'/var/opt/mssql/backup/EWDataRepository_Copy.bak'
 WITH  FILE = 1,
 MOVE N'EWDataRepository' TO N'/var/opt/mssql/data/EWDataRepository.mdf',
 MOVE N'EWDataRepository_log' TO N'/var/opt/mssql/data/EWDataRepository_log.ldf',
 NOUNLOAD,  REPLACE,  STATS = 25
GO
