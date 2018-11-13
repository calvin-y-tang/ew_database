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


