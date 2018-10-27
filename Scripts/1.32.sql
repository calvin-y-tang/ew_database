
----------------------------------------------------------------------------
-- Increased the size of tblcasehistory.otherinfo
-- dml 12/14/10
----------------------------------------------------------------------------

ALTER TABLE [tblCasehistory]
  ALTER COLUMN [OtherInfo] VARCHAR(3000) 
GO


----------------------------------------------------------------------------
--Change Intra-Company Referral facility mapping to use Company instead of Client
----------------------------------------------------------------------------

ALTER TABLE [tblEWFacilityLocal]
  ADD [CompanyCode] INTEGER
GO

UPDATE tblEWFacilityLocal SET CompanyCode=(SELECT CompanyCode FROM tblClient AS c WHERE c.clientcode=tblEWFacilityLocal.ClientCode)

GO


update tblControl set DBVersion='1.32'
GO