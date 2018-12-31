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

	print 'calculate all Turn-Around-Time Values'
	UPDATE ti SET ti.ReferralToScheduledBusDays = [dbo].[fnGetBusinessDays](ti.ReferralDate, ti.ScheduledDate, 1)
	  FROM ##tmp_TravelersInvoices as ti  

	UPDATE ti SET 
				ti.ReferralToMedRecsRecvdCalDays = DATEDIFF(DAY, ti.ReferralDate, ti.MedicalRecordsReceived),
				ti.ScheduledToApptCalDays = DATEDIFF(DAY, ti.ScheduledDate, ti.ApptDate),
				ti.ApptToReportSentCalDays = DATEDIFF(DAY, ti.ApptDate, ti.ReportSent),
				ti.ReferralReportReceviedCalDays = DATEDIFF(DAY, ti.ReferralDate, ti.ReportDateViewed)
	  FROM ##tmp_TravelersInvoices as ti  
	
	print 'remove scheduled date for NON-IME Services'
	UPDATE ##tmp_TravelersInvoices SET ScheduledDate = NULL WHERE ProductName <> 'IME'	  

	print 'update rescheduled date'
	UPDATE ti SET ti.RescheduledApptDate = (SELECT TOP 1 ca.DateAdded from tblCaseAppt as ca WHERE ca.CaseNbr = ti.CaseNbr ORDER BY ca.CaseApptID DESC)
	  FROM ##tmp_TravelersInvoices as ti  

    print 'Return results'
    SELECT *
      FROM ##tmp_TravelersInvoices
