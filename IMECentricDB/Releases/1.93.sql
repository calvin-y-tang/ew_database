
INSERT INTO [tbllanguage] ([Description])
 select 'Karen'
 where not exists (select description from tblLanguage where description='Karen')
GO

ALTER TABLE tblCompany
 ADD GeneralFileUploadFolderID INT
GO

ALTER TABLE tblEWCompany
 ADD GeneralFileUploadFolderID INT
GO


UPDATE tblControl SET DBVersion='1.93'
GO
