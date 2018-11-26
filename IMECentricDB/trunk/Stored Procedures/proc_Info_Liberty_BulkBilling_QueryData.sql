CREATE PROCEDURE [dbo].[proc_Info_Liberty_BulkBilling_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS

--
-- Liberty Bulk Billing Main Query 
-- 

SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_LibertyInvoices') IS NOT NULL DROP TABLE ##tmp_LibertyInvoices
print 'Gather main data set ...'

DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdList;

WITH AcctDetailsCTE AS 
(select ad.HeaderId, ad.CPTCode 
	from tblAcctDetail as ad 
	where (ad.CPTCode IS NOT NULL) 
	  and (LEN(RTRIM(LTRIM(ad.CPTCode))) > 0) 
) 
SELECT
  EWF.DBID as DBID,
  cast('Database' as varchar(15)) as DB,
  AH.HeaderID,
  AH.EWFacilityID,
  AH.CaseDocID,
  EWF.GPFacility + '-' + cast(AH.DocumentNbr as VarChar(15)) as InvoiceNo,
  cast(AH.DocumentNbr as varchar(15)) as DocumentNo,
  AH.DocumentDate as InvoiceDate,
  cast(C.CaseNbr as varchar(15)) as CaseNbr,
  cast(C.ExtCaseNbr as varchar(15)) as ExtCaseNbr,
  CO.CompanyCode as CompanyID,
  CO.IntName as CompanyInt,
  CO.ExtName as CompanyExt,
  ISNULL(CLI.FirstName, '') + ' ' + ISNULL(CLI.LastName, '') as ClientName,
  AH.ClaimNbr as ClaimNumber,
  C.DateAdded,
  C.RptSentDate as ReportSentDate,
  C.DateReceived,
  C.Jurisdiction,
  isnull(E.FirstName, '') + ' ' + isnull(E.LastName, '') as "ClaimantName",
  CA.ApptTime as AppointmentDate,
  case when isnull(D.LastName, '') = '' then isnull(D.FirstName, '') else D.LastName +', ' + isnull(D.FirstName, '') end as ProviderName,
  isnull(CA.SpecialtyCode, C.DoctorSpecialty) as DoctorSpecialty,
  AH.DocumentTotalUS as "Charge",
  CD.Param as "CustomerDataParam",
  CD2.Param as "InvCustomerDataParam", 
  CONVERT(VARCHAR(64), NULL) as "iCaseNbr",
  CONVERT(VARCHAR(64), NULL) as "iCaseCompanyMarket",
  CONVERT(VARCHAR(16), NULL) as "iCaseDateSubmitted",
  CONVERT(VARCHAR(64), NULL) as "iCaseClaimID",
  CONVERT(VARCHAR(64), NULL) as "iCaseOfficeNumber",
  CONVERT(VARCHAR(64), NULL) AS "iCaseClaimType",
  CONVERT(VARCHAR(64), NULL) AS "iCaseReportUploadDate",
  CONVERT(VARCHAR(64), NULL) AS "iCaseIMERequestAs",
  CONVERT(VARCHAR(64), NULL) AS "iCaseServiceType",
  CONVERT(BIT, NULL) as "NotiCaseReferral", 
  STUFF((SELECT '; ' + CPTCode FROM AcctDetailsCTE 
    WHERE AcctDetailsCTE.HeaderID = AH.HeaderID      
    FOR XML path(''), type, root).value('root[1]', 'varchar(max)'), 1, 2, '') as CPTCodes, 
  CONVERT(INT, NULL) AS "Count", 
  CONVERT(VARCHAR(10), NULL) AS "Time",
  CONVERT(DATETIME, NULL) as ClaimantConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as ClaimantConfirmationStatus,
  CONVERT(INT, NULL) as ClaimantCallAttempts,
  CONVERT(DATETIME, NULL) as AttyConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as AttyConfirmationStatus,
  CONVERT(INT, NULL) as AttyCallAttempts

FROM tblAcctHeader as AH
	INNER JOIN tblCase as C on AH.CaseNbr = C.CaseNbr
	INNER JOIN tblClient as CLI on AH.ClientCode = CLI.ClientCode
	INNER JOIN tblCompany as CO on CLI.CompanyCode = CO.CompanyCode
	LEFT OUTER JOIN tblDoctor as D on AH.DrOpCode = D.DoctorCode
	LEFT OUTER JOIN tblExaminee as E on C.ChartNbr = E.ChartNbr
	LEFT OUTER JOIN tblCaseType as CT on C.CaseType = CT.Code
	LEFT OUTER JOIN tblServices as S on C.ServiceCode = S.ServiceCode
	LEFT OUTER JOIN tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
	LEFT OUTER JOIN tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
	LEFT OUTER JOIN tblOffice as O on C.OfficeCode = O.OfficeCode
	LEFT OUTER JOIN tblEWFacility as EWF on AH.EWFacilityID = EWF.EWFacilityID
    LEFT OUTER JOIN tblCaseAppt as CA on isnull(AH.CaseApptID, C.CaseApptID) = CA.CaseApptID
	LEFT OUTER JOIN tblCustomerData as CD on (C.CaseNbr = CD.TableKey AND CD.TableType = 'tblCase' AND CD.CustomerName = 'Liberty Mutual')
	LEFT OUTER JOIN tblCustomerData as CD2 on (AH.HeaderID = CD2.TableKey AND CD2.TableType = 'tblAcctHeader' AND CD2.CustomerName = 'Liberty Mutual')
where AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate
      AND AH.DocumentType = 'IN' 
      AND AH.DocumentStatus = 'Final' 
      AND CO.BulkBillingID = 1 
      AND (AH.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
ORDER BY InvoiceNo

print 'Data retrieved'
set nocount off
