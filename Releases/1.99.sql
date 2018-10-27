ALTER TABLE tblUserActivity
 ADD AppVersion VARCHAR(15)
GO


UPDATE tblControl SET DBVersion='1.99'
GO
