CREATE PROCEDURE [dbo].[proc_Info_Travelers_MgtRpt_PatchData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS

  print 'update results with exam and other fee amounts'
  UPDATE TI SET 
		TI.ExamCost = LI.FeeDetailExam, 
		TI.OtherCosts = LI.FeeDetailOther
  FROM ##tmp_TravelersInvoices AS TI
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
	 ) LI on TI.HeaderID = LI.HeaderID

	print 'Retrieve the most recent Report Date Viewed from the portal for each case ...'
	UPDATE ti SET ti.ReportDateViewed = docs.DateViewed
	  FROM ##tmp_TravelersInvoices as ti
		INNER JOIN (
		SELECT *
			FROM (SELECT ROW_NUMBER() OVER (PARTITION BY cd.CaseNbr ORDER BY cd.SeqNo DESC) as ROWNUM, cd.CaseNbr, cd.SeqNo, pow.DateViewed
					FROM tblCaseDocuments as cd
						LEFT OUTER JOIN tblPublishOnWeb as pow on cd.SeqNo = pow.TableKey and pow.TableType = 'tblCaseDocuments'
					WHERE (cd.CaseNbr IN (Select pr.CaseNbr FROM ##tmp_TravelersInvoices as pr))
					AND (cd.Type = 'Report') 
					) as tbl
			WHERE tbl.ROWNUM = 1) AS docs ON ti.CaseNbr = docs.CaseNbr	 

	print 'update TAT values'
	UPDATE ti SET ti.ReferralToScheduledBusDays = [dbo].[fnGetBusinessDays](ti.ReferralDate, ti.ScheduledDate, 1)
	  FROM ##tmp_TravelersInvoices as ti

    print 'calc date of referral to receipt of report'
	UPDATE ##tmp_TravelersInvoices  SET ReferralReportReceviedCalDays = (SELECT (DATEDIFF(dd, ReferralDate, ReportDateViewed) + 1)
			-(DATEDIFF(wk, ReferralDate, ReportDateViewed) * 2)
			-(CASE WHEN DATENAME(dw, ReferralDate) = 'Sunday' THEN 1 ELSE 0 END)
			-(CASE WHEN DATENAME(dw, ReportDateViewed) = 'Saturday' THEN 1 ELSE 0 END) - 1) 
			-(SELECT Count(*) FROM tblNonWorkDays
				WHERE NonWorkDay between ReferralDate and ReportDateViewed)
     WHERE (ReportDateViewed IS NOT NULL)


	print 'calc date of the referral to records received by vendor'
	UPDATE ##tmp_TravelersInvoices  SET ReferralToMedRecsRecvdCalDays = (SELECT (DATEDIFF(dd, ReferralDate, MedicalRecordsReceived) + 1)
			-(DATEDIFF(wk, ReferralDate, MedicalRecordsReceived) * 2)
			-(CASE WHEN DATENAME(dw, ReferralDate) = 'Sunday' THEN 1 ELSE 0 END)
			-(CASE WHEN DATENAME(dw, MedicalRecordsReceived) = 'Saturday' THEN 1 ELSE 0 END) - 1) 
			-(SELECT Count(*) FROM tblNonWorkDays
				WHERE NonWorkDay between ReferralDate and MedicalRecordsReceived)
      WHERE (MedicalRecordsReceived IS NOT NULL)

	print 'remove scheduled date for NON-IME Services'
	UPDATE ##tmp_TravelersInvoices SET ScheduledDate = NULL WHERE ProductName <> 'IME'	  

    print 'Return results'
    SELECT *
      FROM ##tmp_TravelersInvoices
