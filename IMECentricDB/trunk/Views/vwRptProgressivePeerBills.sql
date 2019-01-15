CREATE VIEW vwRptProgressivePeerBills
AS
SELECT
 CPB.CaseNbr,
 CPB.DateBillReceived AS DateSentToClient,
 C.InvoiceAmt,
 CPB.ProviderName,
 CPB.ProviderZip,
 -- provider region
 CPB.ServiceDate,
 CPB.ServiceEndDate,
 CPB.ServiceRendered,
 CPB.BillAmount,
 CPB.BillAmountApproved,
 CPB.BillAmountDenied,
 CPB.BillNumber,
 ProviderAttorney = 
  CASE
	WHEN REPLACE([dbo].fnReturnValueFromKeyInString(Param, 'ProviderAttorney'), '"', '') = 'Yes' THEN 'Y'
	ELSE 'N'
  END,  

 CL.CompanyCode,
 dbo.fnDateValue(CPB.DateBillReceived) AS FilterDate

 FROM tblCasePeerBill AS CPB
 INNER JOIN tblCase AS C ON CPB.CaseNbr = C.CaseNbr
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 LEFT OUTER JOIN tblCustomerData AS CD ON CD.TableKey = CPB.CaseNbr AND CD.TableType = 'tblCase' AND CD.CustomerName = 'Progressive PeerReview'
 WHERE 1=1