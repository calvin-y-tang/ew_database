----------------------------------------------------------------------------
--Update form name to use Forecast instead of Commit
----------------------------------------------------------------------------

UPDATE tblQueueForms
 SET description=REPLACE(description,'Commit','Forecast')
 WHERE formname IN ('frmStatusCommit', 'frmStatusCommit2')
 
GO


----------------------------------------------------------------------------
--Add ApptBased to vwCaseTypeService
----------------------------------------------------------------------------

DROP VIEW [dbo].[vwcasetypeservice]
GO
CREATE VIEW [dbo].[vwcasetypeservice]
AS  SELECT  dbo.tblCaseTypeService.casetype,
            dbo.tblCaseTypeService.servicecode,
            dbo.tblCaseType.description AS casetypedesc,
            dbo.tblServices.description AS servicedesc,
            dbo.tblServiceOffice.officecode,
            dbo.tblServices.ServiceType,
            dbo.tblServices.ShowLegalTabOnCase,
            dbo.tblServices.ApptBased
    FROM    dbo.tblCaseTypeService
            INNER JOIN dbo.tblServices ON dbo.tblCaseTypeService.servicecode = dbo.tblServices.servicecode
            INNER JOIN dbo.tblCaseType ON dbo.tblCaseTypeService.casetype = dbo.tblCaseType.code
            INNER JOIN dbo.tblServiceOffice ON dbo.tblCaseTypeService.servicecode = dbo.tblServiceOffice.servicecode
                                               AND dbo.tblCaseTypeService.officecode = dbo.tblServiceOffice.officecode
    WHERE   ( dbo.tblCaseType.status = 'Active' )
            AND ( dbo.tblServices.status = 'Active' )

GO


----------------------------------------------------------------------------
--Add Website to tblEWFacility
----------------------------------------------------------------------------

ALTER TABLE [tblEWFacility]
  ADD [Website] VARCHAR(40)
GO


----------------------------------------------------------------------------
-- Added columns for old system keys to be used for data conversions
-- dml 12/03/10
----------------------------------------------------------------------------
if not exists (select * from syscolumns
  where id=object_id('tblCompany') and name='OldKey')
Alter TABLE [dbo].[tblCompany] add
	[OldKey] int NULL

go

if not exists (select * from syscolumns
  where id=object_id('tblLocation') and name='OldKey')
Alter TABLE [dbo].[tblLocation] add
	[OldKey] int NULL

go


update tblControl set DBVersion='1.31'
GO