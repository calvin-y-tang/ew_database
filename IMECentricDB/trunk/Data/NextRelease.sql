-- Issue 7809 - Include URL to documents in email 
-- ******* REMINDER TO POPULATE new tblWebCompany columns URL & WebActionLink
-- ******* REMINDER TO POPULATE new tblControl column DefaultWebCompanyID

-- Issue 7346 - Liberty Mutual Invoice Business Rule
-- ******* REMINDER TO CREATE New business rule and rule condition (based on RuleID 5 in DEV3\IMECentricEW
-- ******* REMINDER THAT WE WILL NEED TO HAVE A NEW tblDocument entry for this new invoice format
--		   and that the tblDocument.document value of the entry needs to be Param1 of business rule condition.

-- Issue 7804 Data patch for Market in GPInvoice table
UPDATE [IMECentricMaster].[dbo].[GPInvoice]
  SET 
    GPInvoice.Market = REPLACE(fnReturnValueFromKeyInString(CD.Param, 'LibertyMarket'), '"', '')
  FROM tblCase
       INNER JOIN tblAcctHeader AS AH ON AH.CaseNbr = tblCase.CaseNbr
       INNER JOIN tblEWFacility AS EWfac ON EWfac.EWFacilityID = AH.EWFacilityID
       INNER JOIN tblCustomerData  AS CD ON CD.TableType = 'tblCase' AND CD.TableKey = tblCase.CaseNbr
  WHERE GPInvoice.DocumentNo = CAST(AH.DocumentNbr AS VARCHAR(15))
    AND GPInvoice.GPFacilityID = EWfac.GPFacility
GO

-- Issue 7804 Data Patch for Marketer and CaseDocID
  UPDATE [IMECentricMaster].[dbo].[GPInvoice]
  SET
       CaseDocID = IIF(GPInvoice.CaseDocID IS NULL, AH.CaseDocID, GPInvoice.CaseDocID),
       Marketer = IIF(GPInvoice.Marketer IS NULL, C.MarketerCode, GPInvoice.Marketer)
  FROM
       tblCase AS C
       INNER JOIN tblAcctHeader AS AH ON AH.CaseNbr = C.CaseNbr
       INNER JOIN tblEWFacility AS EWfac ON EWfac.EWFacilityID = AH.EWFacilityID
  WHERE
       GPInvoice.DocumentNo = CAST(AH.DocumentNbr AS VARCHAR(15))
       AND GPInvoice.GPFacilityID = EWfac.GPFacility
GO

---Issue 7809 Progressive - Add link in email for report
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@ViewDocumentURL@','') 
GO

