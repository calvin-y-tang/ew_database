-- Issue 7708 - delete previous values from tblSettings that are no longer used and create a new generic setting
DELETE FROM tblSetting WHERE Name = 'EnableMultEEAddrDocs'
GO
DELETE FROM tblSetting WHERE Name = 'MultEEAddrDocsOffices'
GO 
-- TODO: fill in a semi-colon delimited list of office codes that you want to enable new gen docs for
INSERT INTO tblSetting (Name, Value)
VALUES('UseNewGenDocFormOffices', ';;')
GO 

-- Issue 7804 Data patch for Market in GPInvoice table
UPDATE [IMECentricMaster].[dbo].[GPInvoice]
  SET 
    GPInvoice.Market = REPLACE([IMECentricEW].[dbo].fnReturnValueFromKeyInString(CD.Param, 'LibertyMarket'), '"', '')
  FROM [IMECentricEW].[dbo].tblCase
       INNER JOIN [IMECentricEW].[dbo].tblAcctHeader AS AH ON AH.CaseNbr = tblCase.CaseNbr
       INNER JOIN [IMECentricEW].[dbo].tblEWFacility AS EWfac ON EWfac.EWFacilityID = AH.EWFacilityID
       INNER JOIN [IMECentricEW].[dbo].tblCustomerData  AS CD ON CD.TableType = 'tblCase' AND CD.TableKey = tblCase.CaseNbr
  WHERE GPInvoice.DocumentNo = CAST(AH.DocumentNbr AS VARCHAR(15))
    AND GPInvoice.GPFacilityID = EWfac.GPFacility



-- Issue 7804 Data Patch for Marketer and CaseDocID
  UPDATE [IMECentricMaster].[dbo].[GPInvoice]
  SET
       CaseDocID = IIF(GPInvoice.CaseDocID IS NULL, AH.CaseDocID, GPInvoice.CaseDocID),
       Marketer = IIF(GPInvoice.Marketer IS NULL, C.MarketerCode, GPInvoice.Marketer)
  FROM
       [IMECentricEW].[dbo].tblCase AS C
       INNER JOIN [IMECentricEW].[dbo].tblAcctHeader AS AH ON AH.CaseNbr = C.CaseNbr
       INNER JOIN [IMECentricEW].[dbo].tblEWFacility AS EWfac ON EWfac.EWFacilityID = AH.EWFacilityID
  WHERE
       GPInvoice.DocumentNo = CAST(AH.DocumentNbr AS VARCHAR(15))
       AND GPInvoice.GPFacilityID = EWfac.GPFacility


