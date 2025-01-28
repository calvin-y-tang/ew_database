
DROP VIEW [vwCaseTypeOffice]
GO

CREATE VIEW [dbo].[vwCaseTypeOffice]
AS
    SELECT  dbo.tblCaseTypeOffice.CaseType ,
            dbo.tblCaseType.Description ,
            dbo.tblCaseTypeOffice.OfficeCode ,
            dbo.tblCaseType.Code ,
            dbo.tblCaseType.DateAdded ,
            dbo.tblCaseType.UserIDAdded ,
            dbo.tblCaseType.DateEdited ,
            dbo.tblCaseType.UserIDEdited ,
            dbo.tblCaseType.InstructionFilename ,
            dbo.tblCaseType.Status
    FROM    dbo.tblcaseTypeOffice
            INNER JOIN dbo.tblCaseType ON dbo.tblCaseTypeOffice.CaseType = dbo.tblCaseType.Code


GO

DROP VIEW [vwcasetypeservice]
GO

CREATE VIEW [dbo].[vwCaseTypeService]
AS
    SELECT  dbo.tblCaseTypeService.CaseType ,
            dbo.tblCaseTypeService.ServiceCode ,
            dbo.tblCaseType.Description AS CaseTypeDesc ,
            dbo.tblServices.Description AS ServiceDesc ,
            dbo.tblServiceOffice.OfficeCode ,
            dbo.tblServices.ServiceType ,
            dbo.tblServices.ShowLegalTabOnCase ,
            dbo.tblServices.ApptBased
    FROM    dbo.tblCaseTypeService
            INNER JOIN dbo.tblServices ON dbo.tblCaseTypeService.ServiceCode = dbo.tblServices.ServiceCode
            INNER JOIN dbo.tblCaseType ON dbo.tblCaseTypeService.CaseType = dbo.tblCaseType.Code
            INNER JOIN dbo.tblServiceOffice ON dbo.tblCaseTypeService.ServiceCode = dbo.tblServiceOffice.ServiceCode
                                               AND dbo.tblCaseTypeService.OfficeCode = dbo.tblServiceOffice.OfficeCode
    WHERE   ( dbo.tblCaseType.Status = 'Active' )
            AND ( dbo.tblServices.Status = 'Active' )


GO

---------------------------------------
--Rename Service Address to the base address rather than service type specific
---------------------------------------
EXEC sp_rename '[tblControl].[NAPSyncServiceAddress]', 'EWServiceAddress', 'COLUMN'
GO

EXEC sp_rename '[tblControl].[NAPSyncServiceBinding]', 'EWServiceBinding', 'COLUMN'
GO



UPDATE tblControl SET DBVersion='1.57'
GO
