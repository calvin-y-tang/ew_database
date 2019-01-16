CREATE VIEW [dbo].[vwRptProgressivePeerBills]
AS
SELECT
	CPB.CaseNbr,
	CPB.DateBillReceived AS DateSentToClient,
	C.InvoiceAmt,
	CPB.ProviderName,
	CPB.ProviderZip,
	-- TODO: need to know where to pull provider region from
	CPB.ServiceDate,
	CPB.ServiceEndDate,
	CPB.ServiceRendered,
	CPB.BillAmount,
	CPB.BillAmountApproved,
	CPB.BillAmountDenied,
	CPB.BillNumber,
	
	CASE
		WHEN dbo.fnGetParamValue(Param, 'ProviderAttorney') = 'Yes' THEN 'Y'
		ELSE 'N'
	END AS ProviderAttorney,  

	CL.CompanyCode,
	-- TODO: Need to verify that this is the correct date to use (it is in turn used to build WHERE CLAUSE)
	dbo.fnDateValue(CPB.DateBillReceived) AS FilterDate

 FROM 
	tblCasePeerBill AS CPB
		 INNER JOIN tblCase AS C ON CPB.CaseNbr = C.CaseNbr
		 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
		 LEFT OUTER JOIN tblCustomerData AS CD ON CD.TableKey = CPB.CaseNbr AND CD.TableType = 'tblCase' AND CD.CustomerName = 'Progressive PeerReview'
 WHERE 
	1=1