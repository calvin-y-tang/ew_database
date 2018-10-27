IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CoverLetterQuestionLoadByType]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_CoverLetterQuestionLoadByType];
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_QuestionCoverLetter_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_QuestionCoverLetter_LoadByPrimaryKey];
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_QuestionCoverLetterHistoryDelete]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_QuestionCoverLetterHistoryDelete];
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_QuestionCoverLetterHistoryInsert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_QuestionCoverLetterHistoryInsert];
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_QuestionCoverLetterHistoryLoadByCaseAndIMECentricCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_QuestionCoverLetterHistoryLoadByCaseAndIMECentricCode];
GO


ALTER TABLE [tblDoctor]
  ADD [GPIDMethod] INTEGER
GO

ALTER TABLE [tblDoctor]
  ADD [GPVendorID] VARCHAR(15)
GO


UPDATE tblLabelFile
   SET labelfile = REVERSE(LEFT(REVERSE(LabelFile), CHARINDEX('\', REVERSE(LabelFile), 1) - 1))
WHERE LabelFile IS NOT NULL
   AND CHARINDEX('\', LabelFile) > 0
GO


UPDATE tblCaseHistory SET Eventdesc='Appt Unscheduled'
 WHERE Type IN ('LateCancel', 'ACCT', 'Reschedule') AND Eventdesc ='Appt Rescheduled'
GO

UPDATE tblCaseHistory SET Type='Unschedule'
 WHERE Type='Reschedule'
GO


ALTER VIEW vwMatrixClientExport
AS
SELECT DISTINCT  ClaimNbr, ClientName, ChartNbr, Specialtydesc, ExamineeName, ApptDate,
                          (SELECT     TOP 1 eventDate
                            FROM          tblCasehistory
                            WHERE      tblCasehistory.CaseNbr = vwdocument.CaseNbr AND type = 'FinalRpt'
                            ORDER BY eventDate DESC) AS ReportDate,
                          (SELECT     TOP 1 eventDate
                            FROM          tblCasehistory
                            WHERE      tblCasehistory.CaseNbr = vwdocument.CaseNbr AND type = 'Scheduled'
                            ORDER BY eventDate DESC) AS ScheduledDate,
                          (SELECT     TOP 1 eventDate
                            FROM          tblCasehistory
                            WHERE      tblCasehistory.CaseNbr = vwdocument.CaseNbr AND type = 'Cancel'
                            ORDER BY eventDate DESC) AS CancelDate,
                          (SELECT     TOP 1 eventDate
                            FROM          tblCasehistory
                            WHERE      tblCasehistory.CaseNbr = vwdocument.CaseNbr AND type = 'Unschedule'
                            ORDER BY eventDate DESC) AS ReScheduledDate, Servicedesc, Datecalledin AS DateAdded, ClientLastName, ClientFirstName, medsrecd, 
                      ExamineeLastName, ExamineeFirstName, CompanyCode, CaseNbr
FROM vwDocument
GO

ALTER VIEW vwMatrixTDExport
AS
SELECT    CaseNbr, ClaimNbr, ClientName, ChartNbr, Specialtydesc, ExamineeCity, ExamineeState, ExamineeName, DOI, DoctorLastName, DoctorCity, ApptDate, 
                      notes,
                          (SELECT     SUM(documenttotal) AS Expr1
                            FROM          TblAcctHeader
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (documenttype = 'IN') AND (documentStatus = 'Final')
                            GROUP BY CaseNbr) AS InvoiceTotal,
                          (SELECT     SUM(documenttotal) AS Expr1
                            FROM          TblAcctHeader AS TblAcctHeader_2
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (documenttype = 'VO') AND (documentStatus = 'Final')
                            GROUP BY CaseNbr) AS Vouchertotal,
                          (SELECT     SUM(taxamount1) AS Expr1
                            FROM          TblAcctHeader AS TblAcctHeader_1
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (documenttype = 'IN') AND (documentStatus = 'Final')
                            GROUP BY CaseNbr) AS GST,
                          (SELECT     TOP (1) eventDate
                            FROM          tblCaseHistory
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (type = 'FinalRpt')
                            ORDER BY eventDate DESC) AS ReportDate,
                          (SELECT     TOP (1) eventDate
                            FROM          tblCaseHistory AS tblCaseHistory_3
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (type = 'Scheduled')
                            ORDER BY eventDate DESC) AS ScheduledDate,
                          (SELECT     TOP (1) eventDate
                            FROM          tblCaseHistory AS tblCaseHistory_2
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (type = 'Cancel')
                            ORDER BY eventDate DESC) AS CancelDate,
                          (SELECT     TOP (1) eventDate
                            FROM          tblCaseHistory AS tblCaseHistory_1
                            WHERE      (CaseNbr = vwdocument.CaseNbr) AND (type = 'Unschedule')
                            ORDER BY eventDate DESC) AS ReScheduledDate, OCF25Date AS DateofNotice, Servicedesc, Datecalledin AS DateAdded, CompanyCode, ClientLastName, 
                      ClientFirstName, medsrecd, ISNULL(CaseUSDvarchar1, 'Not Assigned') AS PrincipleInsurer, CaseUSDDate2 AS ClaimantContactDate, CompanyUSDvarchar1, 
                      AssessmentToAddress, Company, calledinby, Location, CaseUSDvarchar1 AS Brand
FROM vwDocument
GO

UPDATE tblControl SET DBVersion='2.43'
GO
