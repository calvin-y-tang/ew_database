CREATE PROCEDURE [dbo].[proc_Info_Progressive_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS
DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Executing main query ...';

WITH OtherDetailCTE AS (
  SELECT C.CaseNbr, AD.LongDesc
    FROM tblCase as C
		inner join tblAcctHeader as AH on C.CaseNbr = AH.CaseNbr and AH.DocumentStatus = 'Final' and AH.DocumentType = 'IN'
		inner join tblAcctDetail as AD on AH.HeaderID = AD.HeaderID
		inner join tblProduct as P on P.ProdCode = AD.ProdCode
		inner join tblFRCategory as FRC on C.CaseType = FRC.CaseType and AD.ProdCode = FRC.ProductCode
		inner join tblEWFlashCategory as EWFC on FRC.EWFlashCategoryID = EWFC.EWFlashCategoryID
   WHERE ISNULL(EWFC.Mapping5, 'Other') = 'Other'
)
SELECT 
  EWF.DBID,
  EWF.EWFacilityID,
  EWF.ShortName as EWFacility,
  EFGS.RegionGroupName as Region,
  EFGS.SubRegionGroupName as SubRegion,
  EFGS.BusUnitGroupName as BusUnit,
  C.Jurisdiction,
  EWF.GPFacility + '-' + cast(AH.DocumentNbr as varchar(15)) as InvoiceNbr,
  convert(datetime, AH.DocumentDate, 101) as InvoiceDate,
  C.CaseNbr,
  C.ExtCaseNbr,
  CO.IntName as Company,
  cast('' as varchar(1)) as Contracted,
  cast('' as varchar(1)) as InNetwork,
  L.City as ExamCity,
  L.State as ExamState,
  BL.Name AS BusinessLine,
  C.ClaimNbr as ClaimNumber,
  C.ClaimNbrExt as "FeatureNumber",
  E.FirstName as ExamineeFirstName,
  E.LastName as ExamineeLastName,
  case 
    when S.ShortDesc = 'EMCR' then 'EMC Peer Review' 
    when S.Description like '%clarification%' then 'Clarification'
    when S.EWServiceTypeID in (2,3,4,5) then 'Peer Review'
    when S.EWServiceTypeID in (8,9) then 'Addendum'
    else ST.Name
  end as ServiceType,
  S.Description as Service,
  case
    when AH.ApptStatusID is null then isnull(CA.SpecialtyCode, C.DoctorSpecialty)
    else AHCA.SpecialtyCode
  end as DoctorSpecialty,
  C.DateOfInjury as InjuryDate,
  case
    when AH.ApptStatusID is not null then AHAS.Name
    when C.[Status] = 9 then 'Canceled'
    when C.RptSentDate is not null then 'Report Sent'
    when isnull(CA.ApptTime, C.ApptTime) is not null then 'Appt Letter Sent'
    else 'Pending'
  end as [Status],
  case when C.[Status] in (8, 9) then 'Closed' else 'Open' end as OpenClosedStatus,
  case
    when AH.ApptStatusID is null then isnull(CA.DateReceived, C.DateReceived)
    else AHCA.DateReceived
  end as DateReceived,
  case
    when AH.ApptStatusID is null then convert(datetime, isnull(CA.ApptTime, C.ApptTime), 101)
    else convert(datetime, AHCA.ApptTime, 101)
  end as ExamDate,
  case
    when AH.ApptStatusID is null then isnull(C.RptSentDate, AH.Finalized)
    else cast(null as datetime)
  end as RptSentDate,
 C.TATAwaitingScheduling,
 C.TATCalculationGroupID,
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
 convert(varchar(12), null) as "InjuryToExam",
 convert(varchar(12), null) as "InjuryToReportSent",
 convert(varchar(8), null) as "Hours",
  case S.EWServiceTypeID
    when 2 then C.DateMedsRecd
    when 3 then C.DateMedsRecd
    when 4 then C.DateMedsRecd
    when 5 then C.DateMedsRecd
  end as DateMedsReceived,
  case when C.DefenseAttorneyCode is null and C.PlaintiffAttorneyCode is null then 'No' else 'Yes' end as Attorney,
  case
    when AH.ApptStatusID is null then D.FirstName
    else AHD.FirstName
  end as DoctorFirstName,
  case
    when AH.ApptStatusID is null then D.LastName
    else AHD.LastName
  end as DoctorLastName,
  case 
	when cb.ExtName = 'Attorney' then 'Attorney'
	when (cb.ExtName = 'Examinee' or ca.ApptStatusID = 102) then 'Patient'
	when cb.ExtName = 'Client' then 'Adjuster'
	when cb.ExtName = 'Doctor' then 'Doctor'	
  end as "CanceledBy",
  
  case when AH.DocumentNbr is null then 'No' else 'Yes' end as Invoiced,
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
  [PhoneConf],
  [MSA],
  [Clinical],
  [Tech],
  [Medicare],
  [OPO],
  [Rehab],
  [AddReview],
  [AdminFee],
  [FacFee],
  [Other],
  stuff((select '; '+LongDesc from OtherDetailCTE
         where OtherDetailCTE.CaseNbr=C.CaseNbr
         for XML path(''), type, root).value('root[1]', 'varchar(max)'), 1, 2, '') as OtherDetail,
  AH.DocumentTotal,
  CL.FirstName as ClientFirstName,
  CL.LastName as ClientLastName,
  Q.StatusDesc as QueueStatus,
  CAS.Name as ApptStatus,
  AHAS.Name as InvApptStatus,
  CONVERT(VARCHAR(4096), NULL) AS SLAExceptions,
  AH.HeaderID,
  CONVERT(DATETIME, NULL) AS "FirstNoShow",
  CONVERT(DATETIME, NULL) AS "SecondNoShow",
  CONVERT(DATETIME, NULL) AS "ThirdNoShow",
  CONVERT(DATETIME, NULL) AS "ReportRetrievalDate"
INTO ##tmpProgessiveMgtRpt
FROM tblCase as C
left outer join tblAcctHeader as AH on C.CaseNbr = AH.CaseNbr and AH.DocumentStatus = 'Final' and AH.DocumentType = 'IN'
left outer join
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
      [PhoneConf],
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
	left outer join tblExaminee as E on C.ChartNbr = E.ChartNbr
	left outer join tblClient as CL on C.ClientCode = CL.ClientCode
	left outer join tblCompany as CO on CL.CompanyCode = CO.CompanyCode
	left outer join tblCaseAppt as CA on C.CaseApptID = CA.CaseApptID
	left outer join tblApptStatus as CAS on isnull(CA.ApptStatusID, C.ApptStatusID) = CAS.ApptStatusID
	left outer join tblLocation as L on isnull(CA.LocationCode, C.DoctorLocation) = L.LocationCode
	left outer join tblDoctor as D on isnull(CA.DoctorCode, C.DoctorCode) = D.DoctorCode
	left outer join tblCaseAppt as AHCA on AH.CaseApptID = AHCA.CaseApptID
	left outer join tblApptStatus as AHAS on AHCA.ApptStatusID = AHAS.ApptStatusID
	left outer join tblDoctor as AHD on AHCA.DoctorCode = AHD.DoctorCode
	left outer join tblServices as S on C.ServiceCode = S.ServiceCode
	left outer join tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
	left outer join tblCaseType as CT on C.CaseType = CT.Code
	left outer join tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
	left outer join tblOffice as O on C.OfficeCode = O.OfficeCode
	left outer join tblEWFacility as EWF on O.EWFacilityID = EWF.EWFacilityID
	left outer join tblEWFacilityGroupSummary as EFGS on O.EWFacilityID = EFGS.EWFacilityID
	left outer join tblQueues as Q on C.Status = Q.StatusCode
	left outer join tblCanceledBy as cb on isnull(ca.CanceledByID, c.CanceledByID) = cb.CanceledByID
WHERE (C.DateAdded >= @startDate and C.DateAdded <= @endDate)
      and (CO.ParentCompanyID = 39)
      and (O.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      and (not (C.[Status] = 9 and AH.HeaderID is null))
      and (not (C.[Status] = 8 and AH.HeaderID is null and D.DoctorCode is null))
      and (not (S.EWServiceTypeID in (6, 999)))
ORDER BY EFGS.BusUnitSeqNo, C.Jurisdiction, S.Description, C.DateAdded, C.CaseNbr,
         CASE
           WHEN AH.ApptStatusID is null then convert(datetime, isnull(CA.ApptTime, C.ApptTime), 101)
           ELSE convert(datetime, AHCA.ApptTime, 101)
         END
