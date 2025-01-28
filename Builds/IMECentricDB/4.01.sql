GO

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
PRINT N'Creating [dbo].[tblNonWorkDaysOffice]...';


GO
CREATE TABLE [dbo].[tblNonWorkDaysOffice] (
    [NonWorkDay]  DATETIME     NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (50) NULL,
    [Description] VARCHAR (25) NULL,
    CONSTRAINT [PK_tblNonWorkDaysOffice] PRIMARY KEY CLUSTERED ([NonWorkDay] ASC, [OfficeCode] ASC)
);


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
PRINT N'Creating [dbo].[tblNonWorkDaysOffice].[IX_tblNonWorkDaysOffice_Description]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblNonWorkDaysOffice_Description]
    ON [dbo].[tblNonWorkDaysOffice]([Description] ASC);


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
PRINT N'Altering [dbo].[proc_Info_Generic_MgtRpt_PatchData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Generic_MgtRpt_PatchData]
	@feeDetailOption Int
AS 

SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_GenericConfirmationsAtty') IS NOT NULL DROP TABLE ##tmp_GenericConfirmationsAtty
IF OBJECT_ID('tempdb..##tmp_GenericConfirmationsExaminee') IS NOT NULL DROP TABLE ##tmp_GenericConfirmationsExaminee

-- check if we need to add Exam Fee and Other Fee to result set
IF (@feeDetailOption = 1) 
BEGIN
  print 'Fee Detail Option 1 choosen ... linking in basic fee data'

  UPDATE GI SET 
	GI.FeeDetailExam = LI.FeeDetailExam, 
	GI.FeeDetailOther = LI.FeeDetailOther
  FROM ##tmp_GenericInvoices AS GI
	LEFT OUTER JOIN 	  
    (select tAD.HeaderID,
		sum(case when tEWFC.Mapping6 = 'Exam' then tAD.ExtAmountUS else 0 end) as FeeDetailExam,
		sum(case when tEWFC.Mapping6 = 'Other' or tEWFC.Mapping6 is null then tAD.ExtAmountUS else 0 end) as FeeDetailOther
		from tblAcctHeader as tAH
		inner join tblAcctDetail as tAD on tAH.HeaderID = tAD.HeaderID
		inner join tblCase as tC on tAH.CaseNbr = tC.CaseNbr
		left outer join tblFRCategory as tFRC on (tC.CaseType = tFRC.CaseType) and (tAD.ProdCode = tFRC.ProductCode)
		left outer join tblEWFlashCategory as tEWFC on tFRC.EWFlashCategoryID = tEWFC.EWFlashCategoryID
		group by tAD.HeaderID
	 ) LI on GI.HeaderID = LI.HeaderID
END

-- check if we need to add all the fees to the result set
IF (@feeDetailOption = 2) 
BEGIN
  print 'Fee Detail Option 2 choosen ... linking in detailed fee data'

  UPDATE GI SET 	
	GI.FeeDetailExam		=		LI.FeeDetailExam,
	GI.FeeDetailExamUnit    =		LI.FeeDetailExamUnit,
	GI.FeeDetailBillReview	=		LI.FeeDetailBillReview,
	GI.FeeDetailBillRvwUnit =		LI.FeeDetailBillRvwUnit,
	GI.FeeDetailPeer		=		LI.FeeDetailPeer,
	GI.FeeDetailPeerUnit	=		LI.FeeDetailPeerUnit,
	GI.FeeDetailAdd			=		LI.FeeDetailAdd,
	GI.FeeDetailAddUnit		=		LI.FeeDetailAddUnit,
	GI.FeeDetailLegal		=		LI.FeeDetailLegal,
	GI.FeeDetailLegalUnit	=		LI.FeeDetailLegalUnit,
	GI.FeeDetailProcServ	=		LI.FeeDetailProcServ,
	GI.FeeDetailProvServUnit=		LI.FeeDetailProvServUnit,
	GI.FeeDetailDiag		=		LI.FeeDetailDiag,
	GI.FeeDetailDiagUnit	=		LI.FeeDetailDiagUnit,
	GI.FeeDetailNurseServ	=		LI.FeeDetailNurseServ,
	GI.FeeDetailPhone		=		LI.FeeDetailPhone,
	GI.FeeDetailMSA			=		LI.FeeDetailMSA,
	GI.FeeDetailClinical	=		LI.FeeDetailClinical,
	GI.FeeDetailTech		=		LI.FeeDetailTech,
	GI.FeeDetailMedicare	=		LI.FeeDetailMedicare,
	GI.FeeDetailOPO			=		LI.FeeDetailOPO,
	GI.FeeDetailRehab		=		LI.FeeDetailRehab,
	GI.FeeDetailAddRev		=		LI.FeeDetailAddRev,
	GI.FeeDetailAddRevUnit	=		LI.FeeDetailAddRevUnit,
	GI.FeeDetailTrans		=		LI.FeeDetailTrans,
	GI.FeeDetailTransUnit	=		LI.FeeDetailTransUnit,
	GI.FeeDetailMileage		=		LI.FeeDetailMileage,
	GI.FeeDetailMileageUnit	=		LI.FeeDetailMileageUnit,
	GI.FeeDetailTranslate	=		LI.FeeDetailTranslate,
	GI.FeeDetailTranslateUnit =		LI.FeeDetailTranslateUnit,
	GI.FeeDetailAdminFee	=		LI.FeeDetailAdminFee,
	GI.FeeDetailAdminFeeUnit=		LI.FeeDetailAdminFeeUnit,
	GI.FeeDetailFacFee		=		LI.FeeDetailFacFee,
	GI.FeeDetailOther       =		LI.FeeDetailOther
  FROM ##tmp_GenericInvoices AS GI
	LEFT OUTER JOIN 	  
    (select tAD.HeaderID,
		    sum(case when tEWFC.Mapping4 = 'Exam' then tAD.ExtAmountUS else 0 end) as FeeDetailExam,
			sum(case when tEWFC.Mapping4 = 'Exam' then tAD.Unit else 0 end) as FeeDetailExamUnit,
			sum(case when tEWFC.Mapping4 = 'BillReview' then tAD.ExtAmountUS else 0 end) as FeeDetailBillReview,
			sum(case when tEWFC.Mapping4 = 'BillReview' then tAD.Unit else 0 end) as FeeDetailBillRvwUnit,
			sum(case when tEWFC.Mapping4 = 'Peer' then tAD.ExtAmountUS else 0 end) as FeeDetailPeer,
			sum(case when tEWFC.Mapping4 = 'Peer' then tAD.Unit else 0 end) as FeeDetailPeerUnit,
			sum(case when tEWFC.Mapping4 = 'Add' then tAD.ExtAmountUS else 0 end) as FeeDetailAdd,
			sum(case when tEWFC.Mapping4 = 'Add' then tAD.Unit else 0 end) as FeeDetailAddUnit,
			sum(case when tEWFC.Mapping4 = 'Legal' then tAD.ExtAmountUS else 0 end) as FeeDetailLegal,
			sum(case when tEWFC.Mapping4 = 'Legal' then tAD.Unit else 0 end) as FeeDetailLegalUnit,			
			sum(case when tEWFC.Mapping4 = 'Proc Svr' then tAD.ExtAmountUS else 0 end) as FeeDetailProcServ,
			sum(case when tEWFC.Mapping4 = 'Proc Svr' then tAD.Unit else 0 end) as FeeDetailProvServUnit,
			sum(case when tEWFC.Mapping4 = 'Diag' then tAD.ExtAmountUS else 0 end) as FeeDetailDiag,
			sum(case when tEWFC.Mapping4 = 'Diag' then tAD.Unit else 0 end) as FeeDetailDiagUnit,
			sum(case when tEWFC.Mapping4 = 'Nurse Svc' then tAD.ExtAmountUS else 0 end) as FeeDetailNurseServ,
			sum(case when tEWFC.Mapping4 = 'Phone' then tAD.ExtAmountUS else 0 end) as FeeDetailPhone,
			sum(case when tEWFC.Mapping4 = 'MSA' then tAD.ExtAmountUS else 0 end) as FeeDetailMSA,
			sum(case when tEWFC.Mapping4 = 'Clinical' then tAD.ExtAmountUS else 0 end) as FeeDetailClinical,
			sum(case when tEWFC.Mapping4 = 'Tech' then tAD.ExtAmountUS else 0 end) as FeeDetailTech,
			sum(case when tEWFC.Mapping4 = 'Medicare' then tAD.ExtAmountUS else 0 end) as FeeDetailMedicare,
			sum(case when tEWFC.Mapping4 = 'OPO' then tAD.ExtAmountUS else 0 end) as FeeDetailOPO,
			sum(case when tEWFC.Mapping4 = 'Rehab' then tAD.ExtAmountUS else 0 end) as FeeDetailRehab,
			sum(case when tEWFC.Mapping4 = 'Add Rev' then tAD.ExtAmountUS else 0 end) as FeeDetailAddRev,
			sum(case when tEWFC.Mapping4 = 'Add Rev' then tAD.Unit else 0 end) as FeeDetailAddRevUnit,
			sum(case when tEWFC.Mapping4 = 'Trans' then tAD.ExtAmountUS else 0 end) as FeeDetailTrans,
			sum(case when tEWFC.Mapping4 = 'Trans' then tAD.Unit else 0 end) as FeeDetailTransUnit,
			sum(case when tEWFC.Mapping4 = 'Mileage' then tAD.ExtAmountUS else 0 end) as FeeDetailMileage,
			sum(case when tEWFC.Mapping4 = 'Mileage' then tAD.Unit else 0 end) as FeeDetailMileageUnit,
			sum(case when tEWFC.Mapping4 = 'Translate' then tAD.ExtAmountUS else 0 end) as FeeDetailTranslate,
			sum(case when tEWFC.Mapping4 = 'Translate' then tAD.Unit else 0 end) as FeeDetailTranslateUnit,
			sum(case when tEWFC.Mapping4 = 'AdminFee' then tAD.ExtAmountUS else 0 end) as FeeDetailAdminFee,
			sum(case when tEWFC.Mapping4 = 'AdminFee' then tAD.Unit else 0 end) as FeeDetailAdminFeeUnit,
			sum(case when tEWFC.Mapping4 = 'FacFee' then tAD.ExtAmountUS else 0 end) as FeeDetailFacFee,
			sum(case when tEWFC.Mapping4 = 'Other' or tEWFC.Mapping4 is null then tAD.ExtAmountUS else 0 end) as FeeDetailOther
		from tblAcctHeader as tAH
		inner join tblAcctDetail as tAD on tAH.HeaderID = tAD.HeaderID
		inner join tblCase as tC on tAH.CaseNbr = tC.CaseNbr
		left outer join tblFRCategory as tFRC on (tC.CaseType = tFRC.CaseType) and (tAD.ProdCode = tFRC.ProductCode)
		left outer join tblEWFlashCategory as tEWFC on tFRC.EWFlashCategoryID = tEWFC.EWFlashCategoryID
		group by tAD.HeaderID
		) LI on GI.HeaderID = LI.HeaderID
END

-- get the latest confirmation results for examinee and atty phone calls 
-- and put those results into a temp table
SELECT *
   INTO ##tmp_GenericConfirmationsExaminee
   FROM (
		SELECT 
				cl.CaseApptID,
				cl.ContactType,
				cl.ContactedDateTime,
				ISNULL(cr.Description, cs.Name) as ConfirmationStatus,
				SUM(cl.AttemptNbr) as CallAttempts,
				ROW_NUMBER() OVER (
					PARTITION BY (cl.CaseApptID)
					ORDER BY AttemptNbr DESC
			    ) AS ROW_NUM
		   FROM ##tmp_GenericInvoices as li
				INNER JOIN tblConfirmationList as cl on li.CaseApptID = cl.CaseApptID
				LEFT OUTER JOIN tblConfirmationStatus as cs on cl.ConfirmationStatusID = cs.ConfirmationStatusID
				LEFT OUTER JOIN tblConfirmationResult as cr on cl.ConfirmationResultID = cr.ConfirmationResultID 
			WHERE cl.ContactType IN ('Examinee') and cl.ContactMethod = 1
			GROUP BY cl.CaseApptID, cl.AttemptNbr, cl.ContactType, ISNULL(cr.Description, cs.Name), cl.ContactedDateTime
		) EXGROUPS
	WHERE EXGROUPS.[ROW_NUM]  = 1
	ORDER BY EXGROUPS.CaseApptID

SELECT *
   INTO ##tmp_GenericConfirmationsAtty
   FROM (
		SELECT 
				cl.CaseApptID,
				cl.ContactType,
				cl.ContactedDateTime,
				ISNULL(cr.Description, cs.Name) as ConfirmationStatus,
				SUM(cl.AttemptNbr) as CallAttempts,
				ROW_NUMBER() OVER (
					PARTITION BY (cl.CaseApptID)
					ORDER BY AttemptNbr DESC
			    ) AS ROW_NUM
		   FROM ##tmp_GenericInvoices as li
				INNER JOIN tblConfirmationList as cl on li.CaseApptID = cl.CaseApptID
				LEFT OUTER JOIN tblConfirmationStatus as cs on cl.ConfirmationStatusID = cs.ConfirmationStatusID
				LEFT OUTER JOIN tblConfirmationResult as cr on cl.ConfirmationResultID = cr.ConfirmationResultID 
			WHERE cl.ContactType IN ('Attorney') and cl.ContactMethod = 1
			GROUP BY cl.CaseApptID, cl.AttemptNbr, cl.ContactType, ISNULL(cr.Description, cs.Name), cl.ContactedDateTime
		) ATYGROUPS
	WHERE ATYGROUPS.[ROW_NUM]  = 1
	ORDER BY ATYGROUPS.CaseApptID

-- update the main table with the confirmation results for the atty
UPDATE ui SET ui.AttyConfirmationDateTime = lc.ContactedDateTime, ui.AttyConfirmationStatus = lc.ConfirmationStatus, ui.AttyCallAttempts = lc.CallAttempts
  FROM ##tmp_GenericInvoices as ui
	inner join ##tmp_GenericConfirmationsAtty as lc ON ui.CaseApptID = lc.CaseApptID
  WHERE lc.ContactType = 'Attorney'

-- update the main table with the confirmation results for the claimant
UPDATE ui SET ui.ClaimantConfirmationDateTime = lc.ContactedDateTime, ui.ClaimantConfirmationStatus = lc.ConfirmationStatus, ui.ClaimantCallAttempts = lc.CallAttempts
  FROM ##tmp_GenericInvoices as ui
	inner join ##tmp_GenericConfirmationsExaminee as lc ON ui.CaseApptID = lc.CaseApptID
  WHERE lc.ContactType = 'Examinee'

-- update the main table with the most recent quote information
print 'Get Most recent FeeQuote for Case'
UPDATE gi SET gi.FeeQuoteAmount = CASE (ISNULL(gi.InvApptStatus, gi.ApptStatus))
									WHEN 'Late Canceled' THEN tbl.LateCancelAmt
									WHEN 'Canceled' THEN tbl.NoShowAmt
									WHEN 'No Show' THEN tbl.NoShowAmt
									WHEN 'Show' THEN 
										CASE
											WHEN tbl.ApprovedAmt IS NOT NULL THEN tbl.ApprovedAmt
											ELSE ISNULL(tbl.FeeAmtTo, tbl.FeeAmtFrom)
										END
									END,
	          gi.OutOfNetworkReason = tbl.OutOfNetworkReason
  FROM ##tmp_GenericInvoices  as gi
	INNER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY AQ.CaseNbr ORDER BY AQ.AcctQuoteID DESC) as ROWNUM,
					AQ.CaseNbr,
					CONVERT(VARCHAR(12), AQ.LateCancelAmt)	AS LateCancelAmt,
					CONVERT(VARCHAR(12), AQ.NoShowAmt)		AS NoShowAmt,		
					CONVERT(VARCHAR(12), AQ.FeeAmtFrom)		AS FeeAmtFrom,
					CONVERT(VARCHAR(12), AQ.FeeAmtTo)		AS FeeAmtTo,
					CONVERT(VARCHAR(12), AQ.ApprovedAmt)	AS ApprovedAmt,
					ISNULL(NR.Description, '')              AS OutOfNetworkReason
	              FROM tblAcctQuote as AQ 
					LEFT OUTER JOIN tblOutOfNetworkReason as NR on AQ.OutOfNetworkReasonID = NR.OutOfNetworkReasonID
			      WHERE AQ.QuoteType = 'IN') as tbl ON tbl.CaseNbr = gi.CaseNbr
				  WHERE tbl.ROWNUM = 1

-- custom Sedgwick handling for customer data values
print 'Custom Sedgwick Handling for Customer data values'
 UPDATE ginv SET 
		ginv.ClaimUniqueId		= dbo.fnGetParamValue(CD.[Param], 'ClaimUniqueId'),
		ginv.CMSClaimNumber		= dbo.fnGetParamValue(CD.[Param], 'CMSClaimNumber'),
		ginv.ShortVendorId		= dbo.fnGetParamValue(CD.[Param], 'ShortVendorId'),
		ginv.ProcessingOfficeId = dbo.fnGetParamValue(CD.[Param], 'OfficeNumber'),
		ginv.ReferralUniqueId	= dbo.fnGetParamValue(CD.[Param], 'ReferralUniqueId')
   FROM ##tmp_GenericInvoices as ginv
	    INNER JOIN tblCustomerData as CD on CD.TableType = 'tblCase' AND CD.TableKey = ginv.CaseNbr AND CD.CustomerName = 'Sedgwick CMS'
   WHERE ginv.ParentCompanyID = 44

-- get medrec page counts
print 'Get Medical Page Counts'
UPDATE geninv SET MedRecPages = IIF(ISNULL(tblCD.Pages, '') = '', 'N/A', CONVERT(VARCHAR(12), tblCD.Pages))
   FROM ##tmp_GenericInvoices as geninv
		INNER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY CD.CaseNbr ORDER BY CD.SeqNo DESC) as ROWNUM,
					CD.CaseNbr,
					CD.Pages
					FROM tblCaseDocuments as CD
					WHERE CD.Description like '%MedIndex%') as tblCD ON tblCD.CaseNbr = geninv.CaseNbr
		WHERE tblCD.ROWNUM = 1

-- return the main table
print 'return final query results'
SELECT * 
  FROM ##tmp_GenericInvoices
ORDER BY InvoiceNo

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
	(SELECT se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '') as SLAReason, sla.CaseNbr 
	   FROM tblCaseSLARuleDetail as sla 
			 LEFT OUTER JOIN tblSLAException as se on sla.SLAExceptionID = se.SLAExceptionID 
			 INNER JOIN tblCase as c on sla.CaseNbr = c.CaseNbr 
			 INNER JOIN tblAcctHeader as ah on c.CaseNbr = ah.CaseNbr 
			 INNER JOIN tblClient as cli on cli.ClientCode = ah.ClientCode 
			 INNER JOIN tblCompany as com on com.CompanyCode = cli.CompanyCode 
	 WHERE ((LEN(se.Descrip) > 0) OR (LEN(sla.Explanation) > 0)) 
  		  AND (AH.DocumentType = 'IN' 
		  AND AH.DocumentStatus = 'Final' 
		  AND AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate) 
	 GROUP BY (se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '')), sla.CaseNbr ) 
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

-- IMEC-12442 add Conflict of interest business rule and security token
INSERT INTO tblUserFunction 
VALUES('ConflictOfInterestOverride', 'Appointments - Conflict of Interest Override', GetDate())
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (163, 'ApptConflictOfInterest', 'Case', 'Scheduling a case check for a conflict of interest', 1, 1101, 1, 'IncludeServiceTypeID', 'SubFormToDisplay', NULL, NULL, 'Override Sec Token', 0, NULL)
GO
-- ONLY FOR INECentricEW Database
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 23, NULL, NULL, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 24, NULL, NULL, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL),
       (163, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 25, NULL, NULL, NULL, '1,2,3,4,5,10', 'subfrmConflictOfInterest', NULL, NULL, 'ConflictOfInterestOverride', 0, NULL)
GO
