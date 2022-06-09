CREATE PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_QueryData]
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


