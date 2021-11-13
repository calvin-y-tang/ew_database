-- **********************************************************************************************************
--
--   Description:
--        TIme to exercise some caution and create a backup of the databases that we have
--        been working with. This provides us with a snapshot of the database at the point
--        we completed our work and before we made them active in Prodcution.
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- BACKUP IMECentricMaster database
BACKUP DATABASE [IMECentricMaster]
 TO  DISK = N'D:\Backup\Woodbury\IMECentricMaster_After2.bak'
 WITH NOFORMAT, INIT,
 COPY_ONLY, SKIP, NOREWIND, NOUNLOAD,  STATS = 25
GO

-- BACKUP IMECentricRoseland database
BACKUP DATABASE [IMECentricRoseland]
 TO  DISK = N'D:\Backup\Woodbury\IMECentricRoseland_After2.bak'
 WITH NOFORMAT, INIT,
 COPY_ONLY, SKIP, NOREWIND, NOUNLOAD,  STATS = 25
GO

-- BACKUP IMECentricNewYork database
BACKUP DATABASE [IMECentricNewYork]
 TO  DISK = N'D:\Backup\Woodbury\IMECentricNewYork_After2.bak'
 WITH NOFORMAT, INIT,
 COPY_ONLY, SKIP, NOREWIND, NOUNLOAD,  STATS = 25
GO
