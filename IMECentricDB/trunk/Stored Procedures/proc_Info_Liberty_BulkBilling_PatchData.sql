CREATE PROCEDURE [dbo].[proc_Info_Liberty_BulkBilling_PatchData]
AS
SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_LibertyConfirmationsAtty') IS NOT NULL DROP TABLE ##tmp_LibertyConfirmationsAtty
IF OBJECT_ID('tempdb..##tmp_LibertyConfirmationsExaminee') IS NOT NULL DROP TABLE ##tmp_LibertyConfirmationsExaminee

-- get the latest confirmation results for examinee and atty phone calls 
-- and put those results into a temp table
SELECT *
   INTO ##tmp_LibertyConfirmationsExaminee
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
		   FROM ##tmp_LibertyInvoices as li
				INNER JOIN tblConfirmationList as cl on li.CaseApptID = cl.CaseApptID
				LEFT OUTER JOIN tblConfirmationStatus as cs on cl.ConfirmationStatusID = cs.ConfirmationStatusID
				LEFT OUTER JOIN tblConfirmationResult as cr on cl.ConfirmationResultID = cr.ConfirmationResultID 
			WHERE cl.ContactType IN ('Examinee') and cl.ContactMethod = 1
			GROUP BY cl.CaseApptID, cl.AttemptNbr, cl.ContactType, ISNULL(cr.Description, cs.Name), cl.ContactedDateTime
		) GROUPS
	WHERE GROUPS.[ROW_NUM]  = 1
	ORDER BY GROUPS.CaseApptID


   SELECT *
   INTO ##tmp_LibertyConfirmationsAtty
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
		   FROM ##tmp_LibertyInvoices as li
				INNER JOIN tblConfirmationList as cl on li.CaseApptID = cl.CaseApptID
				LEFT OUTER JOIN tblConfirmationStatus as cs on cl.ConfirmationStatusID = cs.ConfirmationStatusID
				LEFT OUTER JOIN tblConfirmationResult as cr on cl.ConfirmationResultID = cr.ConfirmationResultID 
			WHERE cl.ContactType IN ('Attorney') and cl.ContactMethod = 1
			GROUP BY cl.CaseApptID, cl.AttemptNbr, cl.ContactType, ISNULL(cr.Description, cs.Name), cl.ContactedDateTime
		) GROUPS
	WHERE GROUPS.[ROW_NUM]  = 1
	ORDER BY GROUPS.CaseApptID

-- update the main table with the confirmation results for the atty
UPDATE ui SET ui.AttyConfirmationDateTime = lc.ContactedDateTime, ui.AttyConfirmationStatus = lc.ConfirmationStatus, ui.AttyCallAttempts = lc.CallAttempts
  FROM ##tmp_LibertyInvoices as ui
	inner join ##tmp_LibertyConfirmationsAtty as lc ON ui.CaseApptID = lc.CaseApptID
  WHERE lc.ContactType = 'Attorney'

-- update the main table with the confirmation results for the claimant
UPDATE ui SET ui.ClaimantConfirmationDateTime = lc.ContactedDateTime, ui.ClaimantConfirmationStatus = lc.ConfirmationStatus, ui.ClaimantCallAttempts = lc.CallAttempts
  FROM ##tmp_LibertyInvoices as ui
	inner join ##tmp_LibertyConfirmationsExaminee as lc ON ui.CaseApptID = lc.CaseApptID
  WHERE lc.ContactType = 'Examinee'


-- gather up CPT codes  
print 'load CPT Code list'
SELECT ad.HeaderId, ad.CPTCode 
	INTO #tmp_CPTCodeList
	FROM ##tmp_LibertyInvoices as li
		inner join tblAcctDetail as ad on li.HeaderID = ad.HeaderID
	WHERE (ad.CPTCode IS NOT NULL) AND (LEN(RTRIM(LTRIM(ad.CPTCode))) > 0) 

UPDATE ui SET ui.CTPCodes = STUFF((SELECT '; ' + CPTCode FROM #tmp_CPTCodeList as cl
		WHERE cl.HeaderID = ui.HeaderID      
    FOR XML path(''), type, root).value('root[1]', 'varchar(max)'), 1, 2, '')  
FROM ##tmp_LibertyInvoices as ui

-- load other desc values into tmp table
print 'load other description values to tmp table ...'
SELECT C.CaseNbr, ISNULL(AD.LongDesc, AD.SuppInfo) as LongDesc
    INTO #tmp_OtherDesc
    FROM ##tmp_LibertyInvoices as li
		inner join tblCase as C on li.CaseNbr = C.CaseNbr
		inner join tblAcctDetail as AD on li.HeaderID = AD.HeaderID
		inner join tblProduct as P on P.ProdCode = AD.ProdCode
		inner join tblFRCategory as FRC on C.CaseType = FRC.CaseType and AD.ProdCode = FRC.ProductCode
		inner join tblEWFlashCategory as EWFC on FRC.EWFlashCategoryID = EWFC.EWFlashCategoryID   
     AND ISNULL(EWFC.Mapping5, 'Other') IN ('Interpret', 'Trans', 'BillReview', 'Legal', 
			'Processing', 'Nurse', 'Phone', 'MSA', 'Clinical', 'Tech', 'Medicare', 'OPO', 'Rehab', 'AddReview',
			'AdminFee', 'FacFee', 'Other')

print 'update main dataset with other desc values'
UPDATE ui SET ui.OtherServiceDescription =   stuff((select '; ' + LongDesc from #tmp_OtherDesc as od where od.CaseNbr = ui.CaseNbr
         for XML path(''), type, root).value('root[1]', 'varchar(max)'), 1, 2, '')
  FROM ##tmp_LibertyInvoices as ui

-- return the main table
SELECT * 
  FROM ##tmp_LibertyInvoices
ORDER BY InvoiceNo