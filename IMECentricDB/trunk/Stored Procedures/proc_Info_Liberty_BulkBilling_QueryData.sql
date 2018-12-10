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
  ISNULL(AH.CaseApptID, C.CaseApptID) as CaseApptID,
  EWF.GPFacility + '-' + cast(AH.DocumentNbr as VarChar(15)) as InvoiceNo,
  EWF.FedTaxID,
  isnull(EWF.RemitAddress, EWF.Address) as "VendorMailingAddress",
  cast(AH.DocumentNbr as varchar(15)) as DocumentNo,
  AH.DocumentDate as InvoiceDate,
  cast(C.CaseNbr as varchar(15)) as CaseNbr,
  cast(C.ExtCaseNbr as varchar(15)) as ExtCaseNbr,
  CO.CompanyCode as CompanyID,
  CO.IntName as CompanyInt,
  CO.ExtName as CompanyExt,
  EWF.FacilityName "VendorName",
  ISNULL(CLI.FirstName, '') + ' ' + ISNULL(CLI.LastName, '') as ClientName,
  AH.ClaimNbr as ClaimNumber,
  C.DateAdded,
  C.RptSentDate as ReportSentDate,
  C.DateReceived,
  C.Jurisdiction,
  isnull(E.FirstName, '') + ' ' + isnull(E.LastName, '') as "ClaimantName",
  E.State as "ClaimantState",    
  CA.ApptTime as AppointmentDate,
  apts.Name as AppointmentStatus,
  case when isnull(D.LastName, '') = '' then isnull(D.FirstName, '') else D.LastName +', ' + isnull(D.FirstName, '') end as ProviderName,
  isnull(d.LastName, '') as ProviderLastName,
  isnull(d.FirstName, '') as ProviderFirstName,
  C.SReqSpecialty as RequestedSpecialty,
  isnull(CA.SpecialtyCode, C.DoctorSpecialty) as DoctorSpecialty,
  AH.DocumentTotalUS as "Charge",
  CD.Param as "CustomerDataParam",
  CD2.Param as "InvCustomerDataParam", 
  CONVERT(VARCHAR(64), NULL) as "iCaseReferralType",
  CONVERT(VARCHAR(64), NULL) as "iCaseICMServiceType",
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
  CONVERT(INT, NULL) as AttyCallAttempts,
  CONVERT(VARCHAR(12), NULL) AS ExpenseCode,
  BL.Name as "LineOfBusiness",
  (isnull([FeeAmount],0) + isnull([No Show],0) + isnull([Late Canceled],0) + isnull([PeerReview],0) + isnull([Addendum], 0)) as ExamFee,
  isnull([Diag], 0) as RadiololgyFee,
  (isnull([Interpret],0) + isnull([Trans],0) + isnull([BillReview],0) + isnull([Legal],0) + isnull([Processing],0) + isnull([Nurse],0)
	+ isnull(ft.[Phone],0) + isnull([MSA],0) + isnull([Clinical],0) + isnull([Tech],0) + isnull([Medicare],0) + isnull([OPO],0) 
	+ isnull([Rehab],0)	+ isnull([AddReview],0) + isnull([AdminFee],0) + isnull([FacFee],0) + isnull([Other],0)) as Other
INTO ##tmp_LibertyInvoices
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
	LEFT OUTER JOIN tblApptStatus as apts on CA.ApptStatusID = apts.ApptStatusID
	LEFT OUTER JOIN tblCustomerData as CD on (C.CaseNbr = CD.TableKey AND CD.TableType = 'tblCase' AND CD.CustomerName = 'Liberty Mutual')
	LEFT OUTER JOIN tblCustomerData as CD2 on (AH.HeaderID = CD2.TableKey AND CD2.TableType = 'tblAcctHeader' AND CD2.CustomerName = 'Liberty Mutual')
	LEFT OUTER JOIN
(
  select Pvt.*
  from (
    select
      AD.HeaderID,
      isnull(case when EWFC.Mapping5 = 'FeeAmount' and AH.ApptStatusID in (51,102) then 'Late Canceled'
                  when EWFC.Mapping5 = 'FeeAmount' and AH.ApptStatusID = 101 then 'No Show'
                  else EWFC.Mapping5 end, 'Other') as FeeColumn,
      AD.ExtendedAmount	
    from tblCase as C
    inner join tblAcctHeader as AH on C.CaseNbr = AH.CaseNbr and AH.DocumentStatus = 'Final' and AH.DocumentType = 'IN'
    inner join tblAcctDetail as AD on AH.HeaderID = AD.HeaderID
    inner join tblProduct as P on P.ProdCode = AD.ProdCode
    inner join tblCaseType as CT on C.CaseType = CT.Code
    inner join tblFRCategory as FRC on C.CaseType = FRC.CaseType and AD.ProdCode = FRC.ProductCode
    inner join tblEWFlashCategory as EWFC on FRC.EWFlashCategoryID = EWFC.EWFlashCategoryID
    left outer join tblApptStatus as A on A.ApptStatusID = AH.ApptStatusID
  ) as tmp
  pivot
  (
    sum(ExtendedAmount) --aggregrate function that give the value for the columns from FeeColumn
    for FeeColumn in (  --list out the values in FeeColumn that need to be a column
      [FeeAmount],
      [No Show],
      [Late Canceled],
      [Interpret],
      [Trans],
      [Diag],
      [BillReview],
      [PeerReview],
      [Addendum],
      [Legal],
      [Processing],
      [Nurse],
      [Phone],
      [MSA],
      [Clinical],
      [Tech],
      [Medicare],
      [OPO],
      [Rehab],
      [AddReview],
      [AdminFee],
      [FacFee],
      [Other])
  ) as Pvt
) as FT on FT.HeaderID = AH.HeaderID
where AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate
      AND AH.DocumentType = 'IN' 
      AND AH.DocumentStatus = 'Final' 
      AND CO.BulkBillingID = 1 
      AND (AH.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
ORDER BY InvoiceNo

print 'Data retrieved'
set nocount off
