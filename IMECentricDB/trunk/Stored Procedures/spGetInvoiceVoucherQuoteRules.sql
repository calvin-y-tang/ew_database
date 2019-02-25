CREATE PROCEDURE [dbo].[spGetInvoiceVoucherQuoteRules]
(
    @caseNbr INT,
    @quoteType VARCHAR(10),
    @statusID INT,
    @acctQuoteID INT
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT IVQR.QuoteDocument 
	FROM tblInvoiceVoucherQuoteRule AS IVQR
		LEFT OUTER JOIN tblCase AS C ON C.CaseNbr = @CaseNbr
		INNER JOIN tblServices AS tS ON C.ServiceCode = tS.ServiceCode

	WHERE IVQR.CaseType = C.CaseType
	AND IVQR.Jurisdiction = C.Jurisdiction
	AND IVQR.CompanyCode = C.CompanyCode
	AND IVQR.EWServiceTypeID = ts.EWServiceTypeID
	ORDER BY InvoiceVoucherQuoteRuleID

END
GO
