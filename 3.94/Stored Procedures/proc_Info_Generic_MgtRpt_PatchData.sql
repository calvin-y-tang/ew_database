CREATE PROCEDURE [dbo].[proc_Info_Generic_MgtRpt_PatchData]
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
	GI.FeeDetailBillReview	=		LI.FeeDetailBillReview,
	GI.FeeDetailPeer		=		LI.FeeDetailPeer,
	GI.FeeDetailAdd			=		LI.FeeDetailAdd,
	GI.FeeDetailLegal		=		LI.FeeDetailLegal,
	GI.FeeDetailProcServ	=		LI.FeeDetailProcServ,
	GI.FeeDetailDiag		=		LI.FeeDetailDiag,
	GI.FeeDetailNurseServ	=		LI.FeeDetailNurseServ,
	GI.FeeDetailPhone		=		LI.FeeDetailPhone,
	GI.FeeDetailMSA			=		LI.FeeDetailMSA,
	GI.FeeDetailClinical	=		LI.FeeDetailClinical,
	GI.FeeDetailTech		=		LI.FeeDetailTech,
	GI.FeeDetailMedicare	=		LI.FeeDetailMedicare,
	GI.FeeDetailOPO			=		LI.FeeDetailOPO,
	GI.FeeDetailRehab		=		LI.FeeDetailRehab,
	GI.FeeDetailAddRev		=		LI.FeeDetailAddRev,
	GI.FeeDetailTrans		=		LI.FeeDetailTrans,
	GI.FeeDetailMileage		=		LI.FeeDetailMileage,
	GI.FeeDetailTranslate	=		LI.FeeDetailTranslate,
	GI.FeeDetailAdminFee	=		LI.FeeDetailAdminFee,
	GI.FeeDetailFacFee		=		LI.FeeDetailFacFee,
	GI.FeeDetailOther       =		LI.FeeDetailOther
  FROM ##tmp_GenericInvoices AS GI
	LEFT OUTER JOIN 	  
    (select tAD.HeaderID,
		    sum(case when tEWFC.Mapping4 = 'Exam' then tAD.ExtAmountUS else 0 end) as FeeDetailExam,
			sum(case when tEWFC.Mapping4 = 'BillReview' then tAD.ExtAmountUS else 0 end) as FeeDetailBillReview,
			sum(case when tEWFC.Mapping4 = 'Peer' then tAD.ExtAmountUS else 0 end) as FeeDetailPeer,
			sum(case when tEWFC.Mapping4 = 'Add' then tAD.ExtAmountUS else 0 end) as FeeDetailAdd,
			sum(case when tEWFC.Mapping4 = 'Legal' then tAD.ExtAmountUS else 0 end) as FeeDetailLegal,
			sum(case when tEWFC.Mapping4 = 'Proc Svr' then tAD.ExtAmountUS else 0 end) as FeeDetailProcServ,
			sum(case when tEWFC.Mapping4 = 'Diag' then tAD.ExtAmountUS else 0 end) as FeeDetailDiag,
			sum(case when tEWFC.Mapping4 = 'Nurse Svc' then tAD.ExtAmountUS else 0 end) as FeeDetailNurseServ,
			sum(case when tEWFC.Mapping4 = 'Phone' then tAD.ExtAmountUS else 0 end) as FeeDetailPhone,
			sum(case when tEWFC.Mapping4 = 'MSA' then tAD.ExtAmountUS else 0 end) as FeeDetailMSA,
			sum(case when tEWFC.Mapping4 = 'Clinical' then tAD.ExtAmountUS else 0 end) as FeeDetailClinical,
			sum(case when tEWFC.Mapping4 = 'Tech' then tAD.ExtAmountUS else 0 end) as FeeDetailTech,
			sum(case when tEWFC.Mapping4 = 'Medicare' then tAD.ExtAmountUS else 0 end) as FeeDetailMedicare,
			sum(case when tEWFC.Mapping4 = 'OPO' then tAD.ExtAmountUS else 0 end) as FeeDetailOPO,
			sum(case when tEWFC.Mapping4 = 'Rehab' then tAD.ExtAmountUS else 0 end) as FeeDetailRehab,
			sum(case when tEWFC.Mapping4 = 'Add Rev' then tAD.ExtAmountUS else 0 end) as FeeDetailAddRev,
			sum(case when tEWFC.Mapping4 = 'Trans' then tAD.ExtAmountUS else 0 end) as FeeDetailTrans,
			sum(case when tEWFC.Mapping4 = 'Mileage' then tAD.ExtAmountUS else 0 end) as FeeDetailMileage,
			sum(case when tEWFC.Mapping4 = 'Translate' then tAD.ExtAmountUS else 0 end) as FeeDetailTranslate,
			sum(case when tEWFC.Mapping4 = 'AdminFee' then tAD.ExtAmountUS else 0 end) as FeeDetailAdminFee,
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
 UPDATE ginv SET 
		ginv.ClaimUniqueId		= dbo.fnGetParamValue(CD.[Param], 'ClaimUniqueId'),
		ginv.CMSClaimNumber		= dbo.fnGetParamValue(CD.[Param], 'CMSClaimNumber'),
		ginv.ShortVendorId		= dbo.fnGetParamValue(CD.[Param], 'ShortVendorId'),
		ginv.ProcessingOfficeId = dbo.fnGetParamValue(CD.[Param], 'OfficeNumber'),
		ginv.ReferralUniqueId	= dbo.fnGetParamValue(CD.[Param], 'ReferralUniqueId')
   FROM ##tmp_GenericInvoices as ginv
	    INNER JOIN tblCustomerData as CD on CD.TableType = 'tblCase' AND CD.TableKey = ginv.CaseNbr AND CD.CustomerName = 'Sedgwick CMS'
   WHERE ginv.ParentCompanyID = 44

-- return the main table
print 'return final query results'
SELECT * 
  FROM ##tmp_GenericInvoices
ORDER BY InvoiceNo

SET NOCOUNT OFF
