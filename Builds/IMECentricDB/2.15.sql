
INSERT INTO [tbllanguage] ([Description])
 select 'Armenian'
 where not exists (select description from tblLanguage where description='Armenian')
GO

ALTER TABLE tblEWFlashCategory
 ADD Mapping4 VARCHAR(10)
ALTER TABLE tblEWFlashCategory
 ADD Mapping5 VARCHAR(10)
ALTER TABLE tblEWFlashCategory
 ADD Mapping6 VARCHAR(10)
GO

ALTER TABLE tblIMEData ADD IncludeSubCaseOnMaster bit NOT NULL DEFAULT 0
GO

DROP VIEW vwOfficeIMEData
GO
CREATE VIEW vwOfficeIMEData
AS
    SELECT  tblOffice.OfficeCode ,
            tblIMEData.*
    FROM    tblOffice
            INNER JOIN tblIMEData ON tblOffice.IMECode = tblIMEData.IMEcode

GO

UPDATE tblControl SET DBVersion='2.15'
GO
