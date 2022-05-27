
IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Creating [dbo].[DF_tblBusinessRuleCondition_Skip]...';


GO
ALTER TABLE [dbo].[tblBusinessRuleCondition]
    ADD CONSTRAINT [DF_tblBusinessRuleCondition_Skip] DEFAULT ((0)) FOR [Skip];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_Info_Generic_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Generic_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255),
	@companyCodeList VarChar(255)
AS 
SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_GenericInvoices') IS NOT NULL DROP TABLE ##tmp_GenericInvoices
print 'Gather main data set ...'

DECLARE @xml XML
DECLARE @xmlCompany XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)
SET @xmlCompany = CAST('<X>' + REPLACE(@companyCodeList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdList;
print 'Company Code List: ' + @companyCodeList;

WITH SLADetailsCTE AS
(SELECT DF1.Descrip + ' to ' + DF2.Descrip + ': ' + se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '') as SLAReason, sla.CaseNbr
  FROM tblCaseSLARuleDetail as sla
LEFT OUTER JOIN tblSLAException as se on sla.SLAExceptionID = se.SLAExceptionID
LEFT OUTER JOIN tblSLARuleDetail as srd on sla.SLARuleDetailID = srd.SLARuleDetailID
LEFT OUTER JOIN tblTATCalculationMethod as tcm on srd.TATCalculationMethodID = tcm.TATCalculationMethodID
LEFT OUTER JOIN tblDataField as DF1 on tcm.StartDateFieldID = DF1.DataFieldID
LEFT OUTER JOIN tblDataField as DF2 on tcm.EndDateFieldID = DF2.DataFieldID
INNER JOIN tblCase as c on sla.CaseNbr = c.CaseNbr
INNER JOIN tblAcctHeader as ah on c.CaseNbr = ah.CaseNbr
INNER JOIN tblClient as cli on cli.ClientCode = ah.ClientCode
INNER JOIN tblCompany as com on com.CompanyCode = cli.CompanyCode
WHERE ((LEN(se.Descrip) > 0) OR (LEN(sla.Explanation) > 0))
  AND (AH.DocumentType = 'IN'
  AND AH.DocumentStatus = 'Final'
  AND AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate)  
GROUP BY (DF1.Descrip + ' to ' + DF2.Descrip + ': ' + se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '')), sla.CaseNbr
)
SELECT
  Inv.EWFacilityID,
  Inv.HeaderID,
  EWF.DBID as DBID,
  EWF.GPFacility + '-' + cast(Inv.DocumentNbr as varchar(15)) as InvoiceNo,
  Inv.DocumentDate as InvoiceDate,
  C.CaseNbr,
  C.ExtCaseNbr,
  isnull(PC.Name, 'Other') as ParentCompany,
  CO.CompanyCode as CompanyID,
  CO.IntName as CompanyInt,
  CO.ExtName as CompanyExt,
  COM.IntName as CaseCompanyInt,
  COM.ExtName as CaseCompanyExt,
  case when isnull(CLI.LastName, '') = '' then isnull(CLI.FirstName, '') else CLI.LastName+', '+isnull(CLI.FirstName, '') end as CaseClient,
  CO.State as CompanyState,
  EWCT.Name as CompanyType,
  CL.ClientCode as ClientID,
  case when isnull(CL.LastName, '') = '' then isnull(CL.FirstName, '') else CL.LastName+', '+isnull(CL.FirstName, '') end as Client,
  D.DoctorCode as DoctorID, 
  D.Zip as DoctorZip,
  CASE 
  WHEN c.PanelNbr IS NOT NULL THEN c.DoctorName 
  ELSE case when isnull(D.LastName, '') = '' then isnull(D.FirstName, '') else D.LastName+', '+isnull(D.FirstName, '') end
  END as Doctor, 
  C.DoctorReason,
  CT.Description as CaseType,
  BL.Name as BusinessLine,
  ST.Name as ServiceType,
  S.Description as Service,
  Inv.ClaimNbr as ClaimNo,
  C.SInternalCaseNbr as InternalCaseNbr,
  Inv.Examinee as Examinee,
  CASE ISNULL(C.EmployerID, 0)
    WHEN 0 THEN E.Employer
    ELSE EM.Name
  END AS Employer,
  E.DOB as "Examinee DOB",
  E.SSN as "Examinee SSN",
  O.ShortDesc as Office,
  EL.Location as ExamLocationName,
  EL.Addr1 as ExamLocationAddress1,
  EL.Addr2 as ExamLocationAddress2,
  EL.City as ExamLocationCity,
  EL.State as ExamLocationState,
  EL.Zip as ExamLocationZip,
  cast(case when isnull(M.FirstName, '') = '' then isnull(M.LastName, isnull(C.MarketerCode, '')) else M.FirstName+' '+isnull(M.LastName, '') end as varchar(30)) as Marketer,
  EWF.ShortName as EWFacility,
  EFGS.RegionGroupName as Region,
  EFGS.SubRegionGroupName as SubRegion,
  EFGS.BusUnitGroupName as BusUnit,
  EWF.GPFacility as GPFacility,
  Inv.Finalized as DateFinalized,
  Inv.UserIDFinalized as UserFinalized,
  Inv.BatchNbr as GPBatchNo,
  Inv.ExportDate as GPBatchDate,
  BB.Descrip as BulkBilling,
  DOC.Description as InvoiceDocument,
  APS.Name as ApptStatus,
  AHAS.Name as InvApptStatus,
  CB.ExtName as CanceledBy,
  CA.Reason as CancelReason,
  isnull(Inv.ClientRefNbr, '') as ClientRefNo,
  isnull(CA.SpecialtyCode, C.DoctorSpecialty) as DoctorSpecialty,
  C.DateOfInjury as InjuryDate,
  C.ForecastDate,
  C.Jurisdiction,
  EWIS.Name as InputSource,
  EWIS.Mapping1 as SedgwickSource,
  isnull(CA.DateReceived, C.DateReceived) as DateReceived,
  CA.DateAdded as ApptMadeDate,
  C.OrigApptTime as OrigAppt,
  ISNULL(inv.CaseApptID, c.CaseApptID) as CaseApptID,
  CA.ApptTime as [ApptDate],
  C.RptFinalizedDate,
  C.RptSentDate,    
  C.DateMedsRecd as DateMedsReceived,
  C.OCF25Date,
  c.TATAwaitingScheduling,  
  c.TATEnteredToAcknowledged,
  c.TATEnteredToMRRReceived,
  c.TATEnteredToScheduled,
  c.TATExamToClientNotified,
  c.TATExamToRptReceived,
  c.TATQACompleteToRptSent,
  c.TATReport, 
  c.TATRptReceivedToQAComplete,
  c.TATRptSentToInvoiced,
  c.TATScheduledToExam,
  c.TATServiceLifeCycle, 
  C.DateAdded as CaseDateAdded,
  Inv.CaseDocID,
  case
    when EWReferralType=0 then ''
    when EWReferralType=1 then 'Incoming'
    when EWReferralType=2 then 'Outgoing'
    else 'Unknown'
  end as MigratingClaim,
  isnull(MCFGS.BusUnitGroupName, '') as MigratingClaimBusUnit,
  C.PhotoRqd,
  C.PhotoRcvd,
  isnull(C.TransportationRequired, 0) as TransportationRequired,
  isnull(C.InterpreterRequired, 0) as InterpreterRequired,
  LANG.Description as Language,
  '' as CaseIssues,
  case C.NeedFurtherTreatment when 1 then 'Pos' else 'Neg' end as Outcome,
  case C.IsReExam when 1 then 'Yes' else 'No' end as IsReExam,
  isnull(FZ.Name, '') as FeeZone,
  (select count(tCA.CaseApptID) from tblCaseAppt as tCA where C.CaseNbr = tCA.CaseNbr and tCA.CaseApptID <= CA.CaseApptID and tCA.ApptStatusID <> 50) as ApptCount,
  (select count(tCA.CaseApptID) from tblCaseAppt as tCA where C.CaseNbr = tCA.CaseNbr and tCA.CaseApptID <= CA.CaseApptID and tCA.ApptStatusID = 101) as NSCount,
  cast(Round(Inv.TaxTotal*Inv.ExchangeRate, 2) as Money) as TaxTotal,
  Inv.DocumentTotalUS-cast(Round(Inv.TaxTotal*Inv.ExchangeRate, 2) as Money) as Revenue,
  Inv.DocumentTotalUS as InvoiceTotal,
  isnull(VO.Expense, 0) as Expense,
  VO.VoucherCount as Vouchers,
  VO.VoucherDateMin as VoucherDate1,
  EWF.GPFacility + '-' + cast(VO.VoucherNoMin as varchar(15)) as VoucherNo1,
  VO.VoucherDateMax as VoucherDate2,
  EWF.GPFacility + '-' + cast(VO.VoucherNoMax as varchar(15)) as VoucherNo2,
  (select count(LI.LineNbr) from tblAcctDetail as LI where LI.HeaderID = Inv.HeaderID) as LineItems,
 STUFF((SELECT '; ' + SLAReason FROM SLADetailsCTE
    WHERE SLADetailsCTE.CaseNbr = inv.CaseNbr
    FOR XML path(''), type, root).value('root[1]', 'varchar(max)'), 1, 2, '') as SLAReasons,
  CONVERT(DATETIME, NULL) as ClaimantConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as ClaimantConfirmationStatus,
  CONVERT(INT, NULL) as ClaimantCallAttempts,
  CONVERT(DATETIME, NULL) as AttyConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as AttyConfirmationStatus,
  CONVERT(INT, NULL) as AttyCallAttempts,  
  CONVERT(MONEY, NULL) AS   FeeDetailExam,
  CONVERT(INT,   NULL) AS   FeeDetailExamUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailBillReview,
  CONVERT(INT,   NULL) AS   FeeDetailBillRvwUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailPeer,
  CONVERT(INT,   NULL) AS   FeeDetailPeerUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailAdd,
  CONVERT(INT,   NULL) AS   FeeDetailAddUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailLegal,
  CONVERT(INT,   NULL) AS   FeeDetailLegalUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailProcServ,
  CONVERT(INT,   NULL) AS   FeeDetailProvServUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailDiag,
  CONVERT(INT,   NULL) AS   FeeDetailDiagUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailNurseServ,
  CONVERT(MONEY, NULL) AS   FeeDetailPhone,
  CONVERT(MONEY, NULL) AS   FeeDetailMSA,
  CONVERT(MONEY, NULL) AS   FeeDetailClinical,
  CONVERT(MONEY, NULL) AS   FeeDetailTech,
  CONVERT(MONEY, NULL) AS   FeeDetailMedicare,
  CONVERT(MONEY, NULL) AS   FeeDetailOPO,
  CONVERT(MONEY, NULL) AS   FeeDetailRehab,
  CONVERT(MONEY, NULL) AS   FeeDetailAddRev,
  CONVERT(INT,   NULL) AS   FeeDetailAddRevUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailTrans,
  CONVERT(INT,   NULL) AS   FeeDetailTransUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailMileage,
  CONVERT(INT,   NULL) AS   FeeDetailMileageUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailTranslate,
  CONVERT(INT,   NULL) AS   FeeDetailTranslateUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailAdminFee,
  CONVERT(INT,   NULL) AS   FeeDetailAdminFeeUnit,
  CONVERT(MONEY, NULL) AS   FeeDetailFacFee,
  CONVERT(MONEY, NULL) AS   FeeDetailOther,
  ISNULL(C.InsuringCompany, '') as InsuringCompany,
  ISNULL(C.Priority, 'Normal') AS CasePriority,
  CONVERT(DATE, C.AwaitingScheduling) as DateAwaitingScheduling,
  CO.ParentCompanyID,
  CONVERT(VARCHAR(32), NULL) AS ClaimUniqueId,
  CONVERT(VARCHAR(32), NULL) AS CMSClaimNumber,
  CONVERT(VARCHAR(8),  NULL) AS ShortVendorId,
  CONVERT(VARCHAR(12), NULL) AS ProcessingOfficeId,
  CONVERT(VARCHAR(32), NULL) AS ReferralUniqueId,
  CONVERT(VARCHAR(12), NULL) AS ClientCustomerId,
  CONVERT(VARCHAR(128),NULL) AS ClientCustomerName,
  C.ClaimNbrExt as ClaimNoExt,
  CONVERT(VARCHAR(32), NULL) as FeeQuoteAmount,
  CONVERT(VARCHAR(64), NULL) AS OutOfNetworkReason,
  CONVERT(VARCHAR(12), 'N/A') AS MedRecPages 
INTO ##tmp_GenericInvoices
FROM tblAcctHeader AS Inv
left outer join tblCase as C on Inv.CaseNbr = C.CaseNbr
left outer join tblEmployer as EM on C.EmployerID = EM.EmployerID
left outer join tblClient as CL on Inv.ClientCode = CL.ClientCode		-- invoice client (billing client)
left outer join tblCompany as CO on Inv.CompanyCode = CO.CompanyCode	-- invoice company (billing company)
left outer join tblClient as CLI on C.ClientCode = CLI.ClientCode		-- case client
left outer join tblCompany as COM on CLI.CompanyCode = COM.CompanyCode	-- case company
left outer join tblEWCompanyType as EWCT on CO.EWCompanyTypeID = EWCT.EWCompanyTypeID
left outer join tblDoctor as D on Inv.DrOpCode = D.DoctorCode
left outer join tblExaminee as E on C.ChartNbr = E.ChartNbr
left outer join tblCaseType as CT on C.CaseType = CT.Code
left outer join tblServices as S on C.ServiceCode = S.ServiceCode
left outer join tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
left outer join tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
left outer join tblOffice as O on C.OfficeCode = O.OfficeCode
left outer join tblEWFacility as EWF on Inv.EWFacilityID = EWF.EWFacilityID
left outer join tblEWFacilityGroupSummary as EFGS on Inv.EWFacilityID = EFGS.EWFacilityID
left outer join tblEWFacilityGroupSummary as MCFGS on C.EWReferralEWFacilityID = MCFGS.EWFacilityID
left outer join tblDocument as DOC on Inv.DocumentCode = DOC.Document
left outer join tblUser as M on C.MarketerCode = M.UserID
left outer join tblEWParentCompany as PC on CO.ParentCompanyID = PC.ParentCompanyID
left outer join tblEWBulkBilling as BB on CO.BulkBillingID = BB.BulkBillingID
left outer join tblCaseAppt as CA on isnull(Inv.CaseApptID, C.CaseApptID) = CA.CaseApptID
left outer join tblCaseAppt as AHCA on Inv.CaseApptID = AHCA.CaseApptID
left outer join tblApptStatus as AHAS on AHCA.ApptStatusID = AHAS.ApptStatusID
left outer join tblApptStatus as APS on isnull(Inv.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID
left outer join tblCanceledBy as CB on CA.CanceledByID = CB.CanceledByID
left outer join tblEWFeeZone as FZ on isnull(CA.EWFeeZoneID, C.EWFeeZoneID) = FZ.EWFeeZoneID
left outer join tblLanguage as LANG on C.LanguageID = LANG.LanguageID
left outer join tblEWInputSource as EWIS on C.InputSourceID = EWIS.InputSourceID
left outer join tblLocation as EL on CA.LocationCode = EL.LocationCode
left outer join
  (select
     RelatedInvHeaderID, 
     sum(DocumentTotalUS)-sum(cast(Round(TaxTotal*ExchangeRate, 2) as Money)) as Expense,
     count(DocumentNbr) as VoucherCount,
     min(DocumentDate) as VoucherDateMin,  
     min(DocumentNbr) as VoucherNoMin,
     max(DocumentDate) as VoucherDateMax,
     max(DocumentNbr) as VoucherNoMax
   from tblAcctHeader
   where DocumentType='VO' and DocumentStatus='Final' 
         and (DocumentDate >= @startDate and DocumentDate <= @endDate )
   group by RelatedInvHeaderID
  ) as VO on Inv.HeaderID = VO.RelatedInvHeaderID
WHERE (Inv.DocumentType='IN')
      AND (Inv.DocumentStatus='Final')
      AND (Inv.DocumentDate >= @startDate) and (Inv.DocumentDate <= @endDate)
      AND (inv.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      AND (((LEN(ISNULL(@companyCodeList, 0)) > 0 AND CO.ParentCompanyID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xmlCompany.nodes( 'X' ) AS [T]( [N] ))))
			OR (LEN(ISNULL(@companyCodeList, 0)) = 0 AND CO.ParentCompanyID > 0))

ORDER BY EWF.GPFacility, Inv.DocumentNbr

print 'Data retrieved'

SET NOCOUNT OFF
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_Info_Hartford_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS

--
-- Hartford Main Query 
-- 

SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_HartfordInvoices') IS NOT NULL DROP TABLE ##tmp_HartfordInvoices
print 'Gather main data set ...'

DECLARE @serviceVarianceValue INT = 19
DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdLIst

SELECT
	'ExamWorks' as Vendor,
    ewf.[DBID],
	ah.HeaderId,
	ah.SeqNo,
	ah.DocumentNbr,
	ewf.GPFacility + '-' + CAST(ah.DocumentNbr AS Varchar(16)) as "InvoiceNo",
	ah.DocumentDate as "InvoiceDate",
	S.[Description] as [Service],
    CT.[Description] as CaseType,
    c.CaseNbr,
	c.ExtCaseNbr,
	c.SLARuleID,
	co.IntName,
	EFGS.BusUnitGroupName as BusUnit,
	APS.Name as ApptStatus,
	ISNULL(cli.LastName, '') + ', ' + ISNULL(cli.FirstName, '') as "HIGRequestor",
	isnull(SPL.PrimarySpecialty, isnull(CA.SpecialtyCode, C.DoctorSpecialty)) as "Specialty",	
	SPL.SubSpecialty AS "SubSpecialty",	
	ISNULL(d.lastname, '') + ', ' + ISNULL(d.firstname, '') as "ProviderName",
	CONVERT(CHAR(14), EWBL.EWBusLineID) as "LOB",
	C.ClaimNbr as "ClaimNumber",
	E.LastName as "ClaimantLastName",
	E.FirstName as "ClaimantFirstName",
	ISNULL(AH.ServiceState, C.Jurisdiction) as "ServiceState",
	s.EWServiceTypeID as "ServiceTypeID",
	S.Description as "ServiceType",	
	EWBL.Name as "CoverageType",
	CONVERT(VARCHAR(32), 'NA') as "LitOrAppeal",
	C.DateOfInjury as "DOI",
	ISNULL(ca.datereceived, c.DateReceived) as "ReferralDate",
	ISNULL(ca.datereceived, c.DateReceived) as "DateReceived",
	ISNULL(ca.datereceived, c.DateReceived) as "DateScheduled",
	ISNULL(ca.ApptTime, c.ApptTime) as "ExamDate",
	ISNULL(c.RptSentDate, c.RptFinalizedDate) as "ReportDelivered",
	NULL as "TotalDays",
	IIF(ISNULL(C.TATServiceLifeCycle, '') <> '', C.TATServiceLifeCycle - @serviceVarianceValue, 0) as "ServiceVariance",
	CONVERT(CHAR(8), NULL) as "JurisTAT",
	CAST(ISNULL(NW.EWNetworkID, '0') AS CHAR(8)) as "InOutNetwork",
	ISNULL(LI.ExamFee, '') as "ExamFee",
	ISNULL(AH.DocumentTotal, '') as "InvoiceFee",
	CONVERT(VARCHAR(300), NULL) as PrimaryException,
	CONVERT(VARCHAR(32), NULL) as PrimaryDriver,
	CONVERT(VARCHAR(300), NULL) as SecondaryException,
	CONVERT(VARCHAR(32), NULL) as SecondaryDriver,
	CONVERT(VARCHAR(800), NULL) as Comments,
	c.DoctorReason,
	ISNULL(ca.ApptTime, c.ApptTime) as "DateRescheduled",
	ISNULL(ca.ApptTime, c.ApptTime) as "SchedulingComplete",
	C.TATAwaitingScheduling as "RescheduledSchedulingTAT",
	C.TATReport as "ReportDelvred",
	isnull([PeerReview],0) as DiagViewFee,
	isnull([AddReview], 0) as ExcessRecFee,
    isnull([Diag], 0) as DiagTestingFee,	
    -- note: if you add/remove categories from the "other" list below, make sure you update the other service description list in patch data
    (isnull([Interpret],0) + isnull([Trans],0) + isnull([BillReview],0) + isnull([Legal],0) + isnull([Processing],0) + isnull([Nurse],0)
	+ isnull(ft.[Phone],0) + isnull([MSA],0) + isnull([Clinical],0) + isnull([Tech],0) + isnull([Medicare],0) + isnull([OPO],0) 
	+ isnull([Rehab],0)	+ isnull([AdminFee],0) + isnull([FacFee],0) + isnull([Other],0)) as Other,
	0 AS [SurveillanceReviewFee],
	isnull([Mileage], 0) as [ClaimantMileagePrepay],
	0 as RushFee,
	ft.[No Show],
	ft.Other as OtherFee,
	CONVERT(VARCHAR(12), 'N/A') as MedRecPages, 
	case APS.ApptStatusID
		 when 101 then 'No Show'
	     when 102 then 'Unable to Examine'
		 when 51  then 'Late Cancel'
		 when 100 then 		 
			case EWS.EWServiceTypeID
			     when 1 then 
					case S.ShortDesc
						when 'FCE' then 'FCE'
					    else 'IME took place'
				 end
				 when 8 then 'Addendum Complete'
			     when 3 then 'MRR Complete'
			end	
		 else ''
	end as ReferralStatus,
	AHAS.Name as InvApptStatus,
	CONVERT(MONEY, NULL) as InitialQuoteAmount,
	CASE 
		WHEN (AH.DrOpType = 'DR') THEN AH.DrOpCode		
		ELSE NULL
	END as DoctorCode

INTO ##tmp_HartfordInvoices
FROM tblAcctHeader as AH
	inner join tblClient as cli on AH.ClientCode = cli.ClientCode
	inner join tblCase as C on AH.CaseNbr = C.CaseNbr	
	inner join tblOffice as O on C.OfficeCode = O.OfficeCode
	inner join tblServices as S on C.ServiceCode = S.ServiceCode
	left outer join tblEWNetwork as NW on C.EWNetworkID = NW.EWNetworkID
	left outer join tblEWServiceType as EWS on S.EWServiceTypeID = EWS.EWServiceTypeID
	left outer join tblCaseType as CT on C.CaseType = CT.Code
	left outer join tblEWBusLine as EWBL on CT.EWBusLineID = EWBL.EWBusLineID
	left outer join tblEWFacility as EWF on AH.EWFacilityID = EWF.EWFacilityID
	left outer join tblExaminee as E on C.ChartNbr = E.ChartNbr
	left outer join tblClient as CL on AH.ClientCode = CL.ClientCode
	left outer join tblCompany as CO on AH.CompanyCode = CO.CompanyCode
	left outer join tblEWParentCompany as EWPC on CO.ParentCompanyID = EWPC.ParentCompanyID
	left outer join tblEWFacilityGroupSummary as EFGS on AH.EWFacilityID = EFGS.EWFacilityID
	left outer join tblCaseAppt as AHCA on AH.CaseApptID = AHCA.CaseApptID
	left outer join tblApptStatus as AHAS on AHCA.ApptStatusID = AHAS.ApptStatusID
	left outer join tblCaseAppt as CA on ISNULL(AH.CaseApptID, C.CaseApptID) = CA.CaseApptID
	left outer join tblApptStatus as APS on ISNULL(AH.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID	
	left outer join tblDoctor as D on ISNULL(CA.DoctorCode, C.DoctorCode) = D.DoctorCode
	left outer join tblSpecialty as SPL on ISNULL(CA.SpecialtyCode, C.DoctorSpecialty) = SPL.SpecialtyCode		  
	left join
		  (select
			 tAD.HeaderID,
			 SUM(tAD.ExtAmountUS) as ExamFee
		   from tblAcctHeader as tAH
			   inner join tblAcctDetail as tAD on (tAH.HeaderID = tAD.HeaderID)
			   inner join tblCase as tC on tAH.CaseNbr = tC.CaseNbr
			   left outer join tblFRCategory as tFRC on tC.CaseType = tFRC.CaseType and tAD.ProdCode = tFRC.ProductCode
			   left outer join tblEWFlashCategory as tEWFC on tFRC.EWFlashCategoryID = tEWFC.EWFlashCategoryID
		   where tEWFC.Mapping3 = 'FeeAmount'
		   group by tAD.HeaderID
		  ) LI on AH.HeaderID = LI.HeaderID
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
	  [Mileage],
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

WHERE (AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate)
      AND (AH.DocumentType = 'IN')
      AND (AH.DocumentStatus = 'Final')
      AND (EWPC.ParentCompanyID = 30)
	  AND (AH.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      AND ((EWS.Mapping1 in ('IME', 'MRR', 'ADD')) or (S.ShortDesc = 'FCE'))      
ORDER BY EWF.GPFacility, AH.DocumentNbr

print 'Data retrieved'
set nocount off
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[spGetAllBusinessRules]...';


GO
ALTER PROCEDURE dbo.spGetAllBusinessRules
(
    @eventID INT,
    @clientCode INT,
    @billClientCode INT,
    @officeCode INT,
    @caseType INT,
    @serviceCode INT,
    @jurisdiction VARCHAR(5)
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT DISTINCT *, ROW_NUMBER() OVER (PARTITION BY BusinessRuleID ORDER BY BusinessRuleID, ProcessOrder ASC ) AS RuleOrder 
	INTO #tmp_GetAllBusinessRules
	FROM (
			SELECT BR.BusinessRuleID, BR.Category, BR.Name,	 
			 tmpBR.BusinessRuleConditionID,
			 tmpBR.Param1,
			 tmpBR.Param2,
			 tmpBR.Param3,
			 tmpBR.Param4,
			 tmpBR.Param5,
			 tmpBR.EntityType,
			 tmpBR.ProcessOrder,
			 tmpBR.Skip, 
			 tmpBR.Param6
			FROM
				 (SELECT 1 AS GroupID, BRC.*
					FROM tblBusinessRuleCondition AS BRC
						LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @billClientCode
						LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
					WHERE 1=1
						AND (BRC.BillingEntity IN (0,2))
						AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

					UNION

					SELECT 2 AS GroupID, BRC.*
					FROM tblBusinessRuleCondition AS BRC
						LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @clientCode
						LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
					WHERE 1=1
						AND (BRC.BillingEntity IN (1,2))
						AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

					UNION

					SELECT 3 AS GroupID, BRC.*
					FROM tblBusinessRuleCondition AS BRC
					WHERE 1=1
						AND (BRC.EntityType='SW')
				) AS tmpBR
						INNER JOIN tblBusinessRule AS BR ON BR.BusinessRuleID = tmpBR.BusinessRuleID
						LEFT OUTER JOIN tblCaseType AS CT ON CT.Code = @caseType
						LEFT OUTER JOIN tblServices AS S ON S.ServiceCode = @serviceCode
			WHERE BR.IsActive = 1
				and BR.EventID = @eventID
				AND (tmpBR.OfficeCode IS NULL OR tmpBR.OfficeCode = @officeCode)
				AND (tmpBR.EWBusLineID IS NULL OR tmpBR.EWBusLineID = CT.EWBusLineID)
				AND (tmpBR.EWServiceTypeID IS NULL OR tmpBR.EWServiceTypeID = S.EWServiceTypeID)
				AND (tmpBR.Jurisdiction Is Null Or tmpBR.Jurisdiction = @jurisdiction)
	) AS sortedBR	
	ORDER BY sortedBR.BusinessRuleID, sortedBR.ProcessOrder

	-- need to remove duplicate rules (same BusinessRuleConditionID)
	DELETE bizRules 
      FROM (SELECT BusinessRuleConditionID, 
               ROW_NUMBER() OVER (PARTITION BY BusinessRuleConditionID ORDER BY RuleOrder ASC) AS ROWNUM
              FROM #tmp_GetAllBusinessRules) AS bizRules
	 WHERE bizRules.RowNum > 1

    -- remove rules that have a condition that is set to skip
	DELETE 
      FROM #tmp_GetAllBusinessRules
      WHERE BusinessRuleID IN (SELECT BusinessRuleID
                                 FROM #tmp_GetAllBusinessRules
                                WHERE skip = 1)

	-- do not return rules that are set to be "skipped"
	SELECT BusinessRuleID, 
		   Category, 
		   Name,	 
		   BusinessRuleConditionID,
		   Param1,
		   Param2,
		   Param3,
		   Param4,
		   Param5,
		   EntityType,
		   ProcessOrder,
		   Skip, 
		   Param6 
	FROM #tmp_GetAllBusinessRules
	WHERE Skip = 0

END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO
PRINT N'Update complete.';


GO

-- Sprint 85

-- IMEC-12760 - set the PDFMerge method to use
--	***** this does not need to be executed on the DBs that we want to use IMECentricHelper to do the Merge
-- Do not run on First Choice
INSERT INTO tblSetting(Name, Value)
VALUES('MergePDFMethod', 'QuickPDF')
GO

-- IMEC-12752 - new business rule for calculating quote total
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (143, 'ComputeQuoteAmounts', 'Case', 'Calculate the Amount for a Quote', 1, 1060, 0, 'QuoteFeeRangeUnit', 'AdditionalFeesUnit', 'TTlAmtLimit', NULL, NULL, 0, NULL)
GO

INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (143, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, ';Fee;Hourly;Inch;Each;', ';fee;', NULL, NULL, NULL, 0, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 32, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 33, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 34, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 13, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 14, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 15, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 16, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 38, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 40, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, ';fee;', ';fee;', '5000.00', NULL, NULL, 0, NULL)
GO



