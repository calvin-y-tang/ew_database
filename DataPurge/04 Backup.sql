-- **********************************************************************************************************
--
--   Description:
--        TIme to exercise some caution and create a backup of the database that we are
--        going to be working on. If there is a disaster we want to have something that we
--        can restore to do a clean start with.
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- BACKUP IMECentricMaster database
BACKUP DATABASE [IMECentricMaster]
 TO  DISK = N'D:\Backup\Woodbury\IMECentricMaster_Before.bak'
 WITH NOFORMAT, INIT,
 COPY_ONLY, SKIP, NOREWIND, NOUNLOAD,  STATS = 25
GO

-- BACK IMECentricRoseland database
BACKUP DATABASE [IMECentricRoseland]
 TO  DISK = N'D:\Backup\Woodbury\IMECentricRoseland_Before.bak'
 WITH NOFORMAT, INIT,
 COPY_ONLY, SKIP, NOREWIND, NOUNLOAD,  STATS = 25
GO
