ALTER TABLE tblControl
 ADD DistributeRptBCC VARCHAR(70)
GO 

UPDATE tblCaseHistory SET Locked=1 WHERE Type='FinalRpt'
GO

UPDATE tblControl SET DBVersion='2.02'
GO
