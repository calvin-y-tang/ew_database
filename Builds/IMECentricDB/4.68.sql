

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
PRINT N'Altering [dbo].[tblExternalCommunications]...';


GO
ALTER TABLE [dbo].[tblExternalCommunications]
    ADD [DevNote] VARCHAR (255) NULL;


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
PRINT N'Creating [dbo].[proc_Info_CaseHistoryReport]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_CaseHistoryReport]
(
	@ewFacilityIdList VarChar(255),
	@ParentCompanyIDList VarChar(3000),
	@DateFilter Int,
	@StartDateOption INT = 0,
	@EndDateOption INT = 0,
	@DateStartSpecific DATE,
	@DateEndSpecific DATE,
	@DateStartNmbrOf INT = 0,
	@DateEndNmbrOf INT = 0,
	@ParentCompanyOption INT = 0,
	@CaseStatusOption INT = 0,
	@IncludeCasesHaveNOTBeenInvoices Bit = 0,
	@NationalAcctsOnly BIT = 0,
	@IncludeAttny BIT = 0,
	@IncludeCaseIssues BIT = 0,
	@IncludeCaseProblems BIT = 0,
	@IncludeLastHistoryNote BIT = 0,
	@IncludeSLAMetrics BIT = 0,
	@IncludeICDCodes BIT = 0,
	@IncludeCaseDocMetrics Bit = 0
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @WHERE_ParentComp VARCHAR(1000)
	DECLARE @WHERE_CaseStatus VARCHAR(1000)
	DECLARE @WHERE_BusinessUnits VARCHAR(1000)
	DECLARE @SELECT VARCHAR(5000)
	DECLARE @startDate Date
	DECLARE @endDate Date
	DECLARE @xmlFacilityList XML
	DECLARE @delimiter CHAR(1) = ','
	SET @xmlFacilityList = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)
	DECLARE @xmlParentCompanyIDList XML
	SET @xmlParentCompanyIDList = CAST('<X>' + REPLACE(@ParentCompanyIDList, @delimiter, '</X><X>') + '</X>' AS XML)

	-- Start Dates
	SET @startDate = CASE @StartDateOption
	WHEN 0 THEN @DateStartSpecific    -- none ???
	WHEN 1 THEN GETDATE()   -- today
	WHEN 2 THEN GETDATE() - 1   -- yesterday
	WHEN 3 THEN GETDATE() + 1    -- tomorrow
	WHEN 4 THEN DATEADD(day,CASE WHEN DATEDIFF(day,0,GETDATE())%7 > 3 THEN 7-DATEDIFF(day,0,GETDATE())%7 ELSE 1 END,GETDATE())   -- next working day
	WHEN 5 THEN '1753-01-01'  -- start of time
	WHEN 6 THEN DATEADD(DAY, 1 - DATEPART(WEEKDAY, GETDATE()), GETDATE())   -- start of week
	WHEN 7 THEN DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)   -- start on month
	WHEN 8 THEN DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()), 0)   -- start of quarter
	WHEN 9 THEN DATEADD(year, DATEDIFF(year, 0, GETDATE()), 0)   -- start of year
	WHEN 10 THEN DATEADD(week, -1, DATEADD(DAY, 1-DATEPART(WEEKDAY, GETDATE()), DATEDIFF(day, 0, GETDATE())))   -- start of last week
	WHEN 11 THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)   -- start of last month
	WHEN 12 THEN DATEADD(QUARTER, DATEDIFF(QUARTER, 0, GETDATE()) - 1, 0)   -- start of last quarter
	WHEN 13 THEN DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) - 1, 0)   -- start of last year
	WHEN 14 THEN DATEADD(week, 1, DATEADD(DAY, 1-DATEPART(WEEKDAY, GETDATE()), DATEDIFF(day, 0, GETDATE())))   -- start of next week
	WHEN 15 THEN DATEADD(month, DATEDIFF(month, 0, GETDATE()) + 1, 0)   -- start of next month
	WHEN 16 THEN DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()) + 1, 0)   -- start of next quarter
	WHEN 17 THEN DATEADD(year, DATEDIFF(year, 0, GETDATE()) + 1, 0)   -- start of next year
	WHEN 18 THEN '9999-12-31'   -- end of time
	WHEN 19 THEN DATEADD(week, 1, DATEADD(DAY, 0-DATEPART(WEEKDAY, GETDATE()), DATEDIFF(day, 0, GETDATE())))   -- end of week
	WHEN 20 THEN EOMONTH(GETDATE())   -- end of month
	WHEN 21 THEN DATEADD(day, -1, DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()) + 1, 0))   -- end of quarter
	WHEN 22 THEN DATEADD(year, DATEDIFF(year, 0, GETDATE()) + 1, -1)   -- end of year
	WHEN 23 THEN DATEADD(week, 0, DATEADD(DAY, 0-DATEPART(WEEKDAY, GETDATE()), DATEDIFF(day, 0, GETDATE())))   -- end of last week
	WHEN 24 THEN EOMONTH(GETDATE(), -1)   -- end of last month
	WHEN 25 THEN DATEADD(day, -1, DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()), 0))   -- end of last quarter
	WHEN 26 THEN DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()), 0))   -- end of last year
	WHEN 27 THEN DATEADD(week, 2, DATEADD(DAY, 0-DATEPART(WEEKDAY, GETDATE()), DATEDIFF(day, 0, GETDATE())))   -- end of next week
	WHEN 28 THEN EOMONTH(GETDATE(), 1)   -- end of next month
	WHEN 29 THEN DATEADD (day, -1, DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()) + 2, 0))   -- end of next quarter
	WHEN 30 THEN DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) + 2, -1)   -- end of next year
	WHEN 31 THEN DATEADD(day, @DateStartNmbrOf, GETDATE())   -- days from today
	WHEN 32 THEN DATEADD(week, @DateStartNmbrOf, GETDATE())   -- weeks from today
	WHEN 33 THEN DATEADD(month, @DateStartNmbrOf, GETDATE())   -- months from today
	WHEN 34 THEN DATEADD(quarter, @DateStartNmbrOf, GETDATE())   -- quarters from today
	WHEN 35 THEN DATEADD(year, @DateStartNmbrOf, GETDATE())   -- years from today
	WHEN 36 THEN @DateStartSpecific   -- specific date
	WHEN 37 THEN GETDATE() END   -- to ???

	SET @endDate = CASE @EndDateOption
	WHEN 0 THEN @DateEndSpecific    -- none ???
	WHEN 1 THEN GETDATE()   -- today
	WHEN 2 THEN GETDATE() - 1   -- yesterday
	WHEN 3 THEN GETDATE() + 1    -- tomorrow
	WHEN 4 THEN DATEADD(day,CASE WHEN DATEDIFF(day,0,GETDATE())%7 > 3 THEN 7-DATEDIFF(day,0,GETDATE())%7 ELSE 1 END,GETDATE())   -- next working day
	WHEN 5 THEN '1753-01-01'  -- start of time
	WHEN 6 THEN DATEADD(DAY, 1 - DATEPART(WEEKDAY, GETDATE()), GETDATE())   -- start of week
	WHEN 7 THEN DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)   -- start on month
	WHEN 8 THEN DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()), 0)   -- start of quarter
	WHEN 9 THEN DATEADD(year, DATEDIFF(year, 0, GETDATE()), 0)   -- start of year
	WHEN 10 THEN DATEADD(week, -1, DATEADD(DAY, 1-DATEPART(WEEKDAY, GETDATE()), DATEDIFF(day, 0, GETDATE())))   -- start of last week
	WHEN 11 THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)   -- start of last month
	WHEN 12 THEN DATEADD(QUARTER, DATEDIFF(QUARTER, 0, GETDATE()) - 1, 0)   -- start of last quarter
	WHEN 13 THEN DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) - 1, 0)   -- start of last year
	WHEN 14 THEN DATEADD(week, 1, DATEADD(DAY, 1-DATEPART(WEEKDAY, GETDATE()), DATEDIFF(day, 0, GETDATE())))   -- start of next week
	WHEN 15 THEN DATEADD(month, DATEDIFF(month, 0, GETDATE()) + 1, 0)   -- start of next month
	WHEN 16 THEN DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()) + 1, 0)   -- start of next quarter
	WHEN 17 THEN DATEADD(year, DATEDIFF(year, 0, GETDATE()) + 1, 0)   -- start of next year
	WHEN 18 THEN '9999-12-31'   -- end of time
	WHEN 19 THEN DATEADD(week, 1, DATEADD(DAY, 0-DATEPART(WEEKDAY, GETDATE()), DATEDIFF(day, 0, GETDATE())))   -- end of week
	WHEN 20 THEN EOMONTH(GETDATE())   -- end of month
	WHEN 21 THEN DATEADD(day, -1, DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()) + 1, 0))   -- end of quarter
	WHEN 22 THEN DATEADD(year, DATEDIFF(year, 0, GETDATE()) + 1, -1)   -- end of year
	WHEN 23 THEN DATEADD(week, 0, DATEADD(DAY, 0-DATEPART(WEEKDAY, GETDATE()), DATEDIFF(day, 0, GETDATE())))   -- end of last week
	WHEN 24 THEN EOMONTH(GETDATE(), -1)   -- end of last month
	WHEN 25 THEN DATEADD(day, -1, DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()), 0))   -- end of last quarter
	WHEN 26 THEN DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()), 0))   -- end of last year
	WHEN 27 THEN DATEADD(week, 2, DATEADD(DAY, 0-DATEPART(WEEKDAY, GETDATE()), DATEDIFF(day, 0, GETDATE())))   -- end of next week
	WHEN 28 THEN EOMONTH(GETDATE(), 1)   -- end of next month
	WHEN 29 THEN DATEADD (day, -1, DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()) + 2, 0))   -- end of next quarter
	WHEN 30 THEN DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) + 2, -1)   -- end of next year
	WHEN 31 THEN DATEADD(day, @DateEndNmbrOf, GETDATE())   -- days from today
	WHEN 32 THEN DATEADD(week, @DateEndNmbrOf, GETDATE())   -- weeks from today
	WHEN 33 THEN DATEADD(month, @DateEndNmbrOf, GETDATE())   -- months from today
	WHEN 34 THEN DATEADD(quarter, @DateEndNmbrOf, GETDATE())   -- quarters from today
	WHEN 35 THEN DATEADD(year, @DateEndNmbrOf, GETDATE())   -- years from today
	WHEN 36 THEN @DateEndSpecific   -- specific date
	WHEN 37 THEN GETDATE() END   -- to ???

	print 'start date option: ' + Convert(varchar(50), @StartDateOption)
	print 'start date: ' + Convert(varchar(50), @startDate)
	print 'end date option: ' + Convert(varchar(50), @EndDateOption)
	print 'end date: ' + Convert(varchar(50), @endDate)

select
  EWF.DBID as DBID,
  cast('Database' as varchar(15)) as DB,
  C.CaseNbr,
  C.ExtCaseNbr,
  CA.CaseApptID,
  O.ShortDesc as Office,
  EWF.EWFacilityID,
  EWF.ShortName as EWFacility,
  EFGS.RegionGroupName as Region,
  EFGS.SubRegionGroupName as SubRegion,
  EFGS.BusUnitGroupName as BusUnit,
  C.ChartNbr as ExamineeID,
  case when isnull(E.LastName, '') = '' then isnull(E.FirstName, '') else E.LastName+', '+isnull(E.FirstName, '') end as Examinee,
  ISNULL(CONVERT(VARCHAR(15), DECRYPTBYKEYAUTOCERT(CERT_ID('IMEC_CLE_Certificate'), NULL, E.DOB_Encrypted)), E.DOB) as ExamineeDOB, 
  E.Sex as ExamineeSex,
  ISNULL(CONVERT(VARCHAR(15), DECRYPTBYKEYAUTOCERT(CERT_ID('IMEC_CLE_Certificate'), NULL, E.SSN_Encrypted)), E.SSN) as ExamineeSSN, 
  E.Phone1 as ExamineePhone1,
  E.City as ExamineeCity,
  E.State as ExamineeState, 
  STA.StateName as ExamineeFullStateName, 
  isnull(PC.Name, 'Other') as ParentCompany,
  CO.CompanyCode as CompanyID,
  CO.IntName as CompanyInt,
  CO.ExtName as CompanyExt,
  CO.City as CompanyCity, 
  CO.State as CompanyState, 
  CO.Zip as CompanyZip, 
  CO.ParentCompanyID, 
  EWCT.Name as CompanyType,
  C.ClientCode as ClientID,
  case when isnull(CL.LastName, '') = '' then isnull(CL.FirstName, '') else CL.LastName+', '+isnull(CL.FirstName, '') end as Client,
  CL.Phone1 as ClientPhone,
  CL.Phone1Ext as ClientPhoneExt,
  Cl.Email as ClientEmail,
  case when C.BillClientCode is null then BPC.Name else isnull(BPC.Name, 'Other') end as BillParentCompany,
  BCO.CompanyCode as BillCompanyID,
  BCO.IntName as BillCompanyInt,
  BCO.ExtName as BillCompanyExt,
  C.BillClientCode as BillClientID,
  case when isnull(BCL.LastName, '') = '' then isnull(BCL.FirstName, '') else BCL.LastName+', '+isnull(BCL.FirstName, '') end as BillClient,
 BCL.Email as BillClientEmail,
  D.DoctorCode as DoctorID,
  D.EWDoctorID,
  case when isnull(D.LastName, '') = '' then isnull(D.FirstName, '') else D.LastName+', '+isnull(D.FirstName, '') end as Doctor,
  C.DoctorReason,
  E.TreatingPhysician,
  Q.StatusDesc as Status,
  C.OrigApptTime as OrigAppt,
  isnull(CA.ApptTime, C.ApptTime) as Appt,
  isnull(EWFC.Category, 'Other') as FlashCategory,
  CT.Description as CaseType,
  BL.Name as BusinessLine,
  ST.Name as ServiceType,
  S.Description as Service,
  C.ClaimNbr as ClaimNo,
  C.ClaimNbrExt as ClaimNoExt,
  C.SInternalCaseNbr as InternalCaseNbr,
  ISNULL(EMP.ParentEmployer, '') as ParentEmployer,
  CASE ISNULL(C.EmployerID, 0) 
  WHEN 0 THEN E.Employer       
  ELSE EM.Name                 
  END AS Employer,             
  C.Priority,
  isnull(CA.SpecialtyCode, C.DoctorSpecialty) as DoctorSpecialty,
  C.sReqSpecialty as ReqSpecialty,
  C.RequestedDoc as ReqDoctor,
  cast(case when isnull(M.FirstName, '') = '' then isnull(M.LastName, isnull(C.MarketerCode, '')) else M.FirstName+' '+isnull(M.LastName, '') end as varchar(30)) as Marketer,
  C.SchedulerCode as Scheduler,
  C.CalledInBy as CalledInBy,
  IIF(LEN(C.QARep) = 0, NULL, C.QARep) as QARep,
  C.DateAdded,
  isnull(CA.DateReceived, C.DateReceived) as DateReceived,
  C.DateOfInjury as InjuryDate,
  C.ForecastDate,
  C.HearingDate,
  C.DateMedsRecd as MedsRcvdDate,
  isnull(CA.DateAdded, C.ApptMadeDate) as ApptMadeDate,
  C.AwaitingScheduling,
  C.TransReceived as TransRcvdDate,
  C.RptFinalizedDate,
  C.RptSentDate,
  C.DateCompleted,
  C.OCF25Date,
  C.ExternalDueDate as ExternalDueDate,
  C.InternalDueDate as InternalDueDate,
  isnull(CA.LastStatusChg, C.LastStatusChg) as LastStatusChange,
  0 as TATInQueue,
  C.TATAwaitingScheduling,
  C.TATEnteredToAcknowledged,
  C.TATEnteredToMRRReceived,
  C.TATEnteredToScheduled,
  C.TATExamToClientNotified,
  C.TATExamToRptReceived,
  C.TATQACompleteToRptSent,
  C.TATReport,
  C.TATRptReceivedToQAComplete,
  C.TATRptSentToInvoiced,
  C.TATScheduledToExam,
  C.TATServiceLifeCycle,
  C.TATDateLossToApptDate, 
  C.TATInitialApptDateToApptDate, 
  C.TATDateReceivedToInitialApptDate, 
  0 as TATOCF25ToOrigAppt,
  C.RptStatus,
  APS.Name as ApptStatus,
  CB.ExtName as CanceledBy,
  ISNULL(CA.Reason, C.CanceledReason) as CancelReason,
  ISNULL(C.CanceledByUserID, '') as CanceledByUserID,  
  C.CertifiedMail as CertMail,
  C.CertMailNbr as CertMailNo,
  C.CertMailNbr2 as CertMailNo2,
  C.Jurisdiction,
  case
    when C.MasterSubCase = 'M' then 'Master' 
    when C.MasterSubCase = 'S' then 'Sub' 
  end as MasterSub,
  MC.ExtCaseNbr as MasterExtCaseNbr,
  C.PublishOnWeb as WebPortal,
  case
    when C.EWReferralType=0 then ''
    when C.EWReferralType=1 then 'Incoming'
    when C.EWReferralType=2 then 'Outgoing'
    else 'Unknown'
  end as MigratingClaim,
  isnull(MCFGS.BusUnitGroupName, '') as MigratingClaimBusUnit,
  cast(null as datetime) as NPDateAssigned,
  cast(null as datetime) as NPDateAccepted,
  C.InvoiceAmt as Revenue,
  C.VoucherAmt as Expense,
  C.InvoiceAmt-C.VoucherAmt as Margin,
  C.InputSourceID as InputSource,
  isnull(L.Location, '') as LocationName,
  isnull(L.Addr1, '') as LocationAddress1,
  isnull(L.Addr2, '') as LocationAddress2,
  isnull(L.City, '') as LocationCity,
  isnull(L.State, '') as LocationState,
  isnull(L.Zip, '') as LocationZip,
  isnull(L.County, '') as LocationCounty,
  C.PhotoRqd,
  C.PhotoRcvd,
  isnull(C.TransportationRequired, 0) as TransportationRequired,
  isnull(C.InterpreterRequired, 0) as InterpreterRequired,
  LANG.Description as Language,
  C.PlaintiffDefense as LegalType,
  '' as CaseIssues,
 '' as CaseProblems, 
  D.CredentialingStatus,
  D.CredentialingSource,
  D.CredentialingNotes,
  D.CredentialingUpdated,
  D.EWDoctor,
  D.DateLastUsed as CredLastUsed,
  D.PracticingDoctor,
  D.Status as DoctorStatus,
  D.NPINbr as DoctorNPI,
  D.WCNbr,
  D.LicenseNbr, 
  case C.NeedFurtherTreatment when 1 then 'Pos' else 'Neg' end as Outcome,
  case C.IsReExam when 1 then 'Yes' else 'No' end as IsReExam,
  isnull(FZ.Name, '') as FeeZone,
  (select count(tCA.CaseApptID) from tblCaseAppt as tCA where C.CaseNbr = tCA.CaseNbr and tCA.CaseApptID <= CA.CaseApptID and tCA.ApptStatusID <> 50) as ApptCount,
  (select count(tCA.CaseApptID) from tblCaseAppt as tCA where C.CaseNbr = tCA.CaseNbr and tCA.CaseApptID <= CA.CaseApptID and tCA.ApptStatusID = 101) as NSCount,
  C.DateEdited,
  C.UserIDEdited as UserEdited,
  ISNULL(C.InsuringCompany, '') as InsuringCompany,
  C.MMIReachedStatus, 
  C.MMITreatmentWeeks, 
  C.TypeMedsRecd, 
  CASE 
    WHEN CO.ParentCompanyID = 60 THEN COD.Value  
    ELSE '' 
  END as ReferralSource, 
  C.PreAuthorization, 
  C.WorkCompCaseType,  
  C.RptInitialDraftDate, 
  TotalEnvelopes AS [Neopost Reports], 
  CONVERT(MONEY, AQ.ApprovedAmt) as [QuoteApprovedAmt], 
  AQ.ApprovedByClientName, 
  AQ.ApprovedQuote, 
  C.InvFeeQuoteTotalAmt, 
  C.InvFeeApprovalTotalAmt, 
  C.RptQADraftDate, 
  C.TATQADraftToQAComplete, 
  C.WCBNbr, 
  C.CustomerSystemID, 
  C.DateCanceled, 
  CA.DateShowNoShowLetterSent, 
  MS.Description as MedStatus, 
  D.EmailAddr as DoctorEmail, 
  dbo.[fnGetBusinessDays](C.DateEdited, GETDATE(),1) as DaysSinceLastEdited, 
  dbo.[fnGetBusinessDays](C.LastStatusChg, GETDATE(),1) as DaysInCurrentStatus, 
  ISNULL(C.AddlClaimNbrs, '') as AddlClaimNbrs, 
  ISNULL(C.DateReceived, '') as CaseDateReceived, 
  C.DoctorRptDueDate as [Doc Rpt Due Date], 
  C.DateMedsSentToDr,
  CH.Eventdesc + ' - ' +  CH.OtherInfo AS CaseHistoryOverride,
  CH.EventDate AS CaseHistoryOverrideDate,
  CH.UserID AS CaseHistoryOverrideUser
from tblCase as C
inner join tblExaminee as E on C.ChartNbr = E.ChartNbr
inner join tblClient as CL on C.ClientCode = CL.ClientCode
inner join tblCaseHistory as CH on C.CaseNbr = CH.CaseNbr
inner join tblCaseHistoryOverrides as CHO on CH.ID = CHO.CaseHistoryID
left outer join tblCompany as CO on CL.CompanyCode = CO.CompanyCode
left outer join tblCase as MC on C.MasterCaseNbr = MC.CaseNbr
left outer join tblEmployer as EM on C.EmployerID = EM.EmployerID
left outer join tblEWParentEmployer as EMP on EM.EWParentEmployerID = EMP.EWParentEmployerID
left outer join tblEWParentCompany as PC on CO.ParentCompanyID = PC.ParentCompanyID
left outer join tblClient as BCL on C.BillClientCode = BCL.ClientCode
left outer join tblCompany as BCO on BCL.CompanyCode = BCO.CompanyCode
left outer join tblEWParentCompany as BPC on BCO.ParentCompanyID = BPC.ParentCompanyID
left outer join tblEWCompanyType as EWCT on CO.EWCompanyTypeID = EWCT.EWCompanyTypeID
left outer join tblCaseAppt as CA on C.CaseNbr = CA.CaseNbr
left outer join tblApptStatus as APS on isnull(CA.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID
left outer join tblCanceledBy as CB on ISNULL(CA.CanceledByID, C.CanceledByID) = CB.CanceledByID
left outer join tblEWFeeZone as FZ on isnull(CA.EWFeeZoneID, C.EWFeeZoneID) = FZ.EWFeeZoneID
left outer join tblDoctor as D on isnull(CA.DoctorCode, C.DoctorCode) = D.DoctorCode
left outer join tblCaseType as CT on C.CaseType = CT.Code
left outer join tblServices as S on C.ServiceCode = S.ServiceCode
left outer join tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
left outer join tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
left outer join (select min(tP.ProdCode) as ProdCode, tP.Description as ProdDesc, tPO.OfficeCode
                 from tblProduct as tP
                 inner join tblProductOffice as tPO on tP.ProdCode = tPO.ProdCode
                 group by tP.Description, tPO.OfficeCode
                ) as PO on C.OfficeCode = PO.OfficeCode and S.Description = PO.ProdDesc
left outer join tblFRCategory as FRC on C.CaseType = FRC.CaseType and PO.ProdCode = FRC.ProductCode
left outer join tblEWFlashCategory as EWFC on FRC.EWFlashCategoryID = EWFC.EWFlashCategoryID
left outer join tblOffice as O on C.OfficeCode = O.OfficeCode
left outer join tblState as STA on E.State = STA.StateCode 
 left outer join tblRecordStatus as MS on c.RecCode = MS.RecCode 
left join (
     SELECT CE.CaseNbr, COUNT(CE.EnvelopeID) as TotalEnvelopes 
       FROM tblCaseEnvelope CE 
       WHERE CE.EnvelopeID Like '%R%' 
       GROUP BY CE.CaseNbr 
) AS Env ON C.CaseNbr = Env.CaseNbr 
left outer join ( 
  select CaseNbr,  
         DoctorCode, 
		      ApprovedAmt,  
		      ApprovedByClientName, 
		      IIF(DateClientApproved IS NULL, 'No', 'Yes') as ApprovedQuote,
		      row_number() over (partition by casenbr, doctorcode order by AcctQuoteID desc) as RowNum   
	 from tblAcctQuote 
	 where QuoteType = 'IN' 
	) as AQ on ((C.CaseNbr = AQ.CaseNbr) and (C.DoctorCode = AQ.DoctorCode) and (AQ.RowNum = 1))  
left outer join tblEWFacility as EWF on O.EWFacilityID = EWF.EWFacilityID
left outer join tblEWFacilityGroupSummary as EFGS on O.EWFacilityID = EFGS.EWFacilityID
left outer join tblQueues as Q on C.Status = Q.StatusCode
left outer join tblEWFacilityGroupSummary as MCFGS on C.EWReferralEWFacilityID = MCFGS.EWFacilityID
left outer join tblUser as M on C.MarketerCode = M.UserID
left outer join tblLocation as L on isnull(CA.LocationCode, C.DoctorLocation) = L.LocationCode
left outer join tblLanguage as LANG on C.LanguageID = LANG.LanguageID
left outer join tblCodes as COD on C.ReferralMethod = COD.CodeID 
WHERE (EWF.EWFacilityID IN (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xmlFacilityList.nodes( 'X' ) AS [T]( [N] )))
AND 
  (   (@ParentCompanyOption = 0 AND PC.ParentCompanyID IN (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xmlParentCompanyIDList.nodes( 'X' ) AS [T]( [N] )))
   OR (@ParentCompanyOption = 1 AND BPC.ParentCompanyID IN (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xmlParentCompanyIDList.nodes( 'X' ) AS [T]( [N] )))
   OR (@ParentCompanyOption = 2 AND PC.ParentCompanyID IN (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xmlParentCompanyIDList.nodes( 'X' ) AS [T]( [N] ))
         AND BPC.ParentCompanyID IN (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xmlParentCompanyIDList.nodes( 'X' ) AS [T]( [N] ))))
AND
  (   (@CaseStatusOption = 4 AND C.Status IN (8))
   OR (@CaseStatusOption = 5 AND C.Status IN (9))
   OR (@CaseStatusOption = 0 AND C.Status NOT IN (8, 9))
   OR (@CaseStatusOption = 1 AND 1=1)
   OR (@CaseStatusOption = 2 AND C.Status NOT IN (9))
   OR (@CaseStatusOption = 3 AND C.Status NOT IN (8)))

AND 
  (   (@DateFilter = 0 AND 1=1)
   OR (@DateFilter = 1 AND (C.DateReceived >= @startDate) AND (C.DateReceived < @endDate))
   OR (@DateFilter = 2 AND (isnull(CA.ApptTime, C.ApptTime) >= @startDate) AND (isnull(CA.ApptTime, C.ApptTime) < @endDate))
   OR (@DateFilter = 3 AND (C.ForecastDate >= @startDate) AND (C.ForecastDate < @endDate))
   OR (@DateFilter = 4 AND (C.RptFinalizedDate >= @startDate) AND (C.RptFinalizedDate < @endDate))
   OR (@DateFilter = 5 AND (C.DateCompleted >= @startDate) AND (C.DateCompleted < @endDate))
   OR (@DateFilter = 6 AND (C.DateOfInjury >= @startDate) AND (C.DateOfInjury < @endDate))
   OR (@DateFilter = 7 AND (C.DateAdded >= @startDate) AND (C.DateAdded < @endDate))
   OR (@DateFilter = 8 AND (C.ApptMadeDate >= @startDate) AND (C.ApptMadeDate < @endDate)))

ORDER BY
CASE 
  WHEN @DateFilter = 0 THEN 1
  WHEN @DateFilter = 1 THEN C.DateReceived
  WHEN @DateFilter = 2 THEN CA.ApptTime
  WHEN @DateFilter = 3 THEN C.ForecastDate
  WHEN @DateFilter = 4 THEN C.RptFinalizedDate
  WHEN @DateFilter = 5 THEN C.DateCompleted
  WHEN @DateFilter = 6 THEN C.DateOfInjury
  WHEN @DateFilter = 7 THEN C.DateAdded
  WHEN @DateFilter = 8 THEN C.ApptMadeDate
END


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
-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 144


