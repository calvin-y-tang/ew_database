
ALTER TABLE tblControl
 ADD GPDBID INT
GO


ALTER TABLE tblIMEData
 ADD DirIMECentricHelper VARCHAR(70)
GO

UPDATE tblControl SET GPDBID=1
 WHERE (SELECT CountryID FROM tblIMEData)=1
UPDATE tblControl SET GPDBID=2
 WHERE (SELECT CountryID FROM tblIMEData)=2
GO

ALTER TABLE [tblCompany]
  ADD [NPProviderSearch] BIT DEFAULT 0 NOT NULL
GO

ALTER TABLE [tblEWCompany]
  ADD [NPProviderSearch] BIT DEFAULT 0 NOT NULL
GO

ALTER TABLE [tblDoctor]
  ADD [NPPublishOnWeb] BIT DEFAULT 1 NOT NULL
GO


ALTER TABLE [dbo].[tblEWBulkBilling] ADD [EDICustomParam] [varchar](1024) NULL
GO
ALTER TABLE [dbo].[tblEWBulkBilling] ADD [EDIShowClaimLookup] [bit] NULL DEFAULT ((0))
GO

UPDATE tblAcctHeader SET EDIStatus = 'Skipped' WHERE [DocumentType] = 'IN' AND DocumentNbr IN
(SELECT ah.DocumentNbr
	FROM tblAcctingTrans at
		INNER JOIN tblAcctHeader ah on at.DocumentNbr = ah.DocumentNbr
		INNER JOIN tblCase ca on ah.CaseNbr = ca.CaseNbr
		INNER JOIN tblCompany com on ah.CompanyCode = com.CompanyCode		
	WHERE (at.StatusCode = 18) 
	    AND (at.[Type] = 'IN')
		AND (LEN(RTRIM(LTRIM(ISNULL(ah.EDIStatus, '')))) = 0 )
		AND (ca.InputSourceID <> 7)
	    AND (com.ParentCompanyID = 44))
GO



UPDATE tblControl SET DBVersion='2.46'
GO
