
INSERT INTO 
     tblMessageToken(Name, Description)
     VALUES('@ExamineeAddr1@', '')
GO
INSERT INTO 
     tblMessageToken(Name, Description)
     VALUES('@ExamineeAddr2@', '')
GO
INSERT INTO 
     tblMessageToken(Name, Description)
     VALUES('@ExamineeAddr3@', '')
GO
INSERT INTO 
     tblMessageToken(Name, Description)
     VALUES('@ExamineeDOB@', '')
GO
INSERT INTO 
     tblMessageToken(Name, Description)
     VALUES('@DOI@', '')

GO

UPDATE tblControl SET DBVersion='2.29'
GO
