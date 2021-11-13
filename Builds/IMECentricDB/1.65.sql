


-------------------------------
--Additional Company index 
-------------------------------

CREATE NONCLUSTERED INDEX [IdxtblCompany_BY_City] ON [dbo].[tblCompany] ([City])
GO
CREATE NONCLUSTERED INDEX [IX_tblCompany_EWCompanyID] ON [dbo].[tblCompany] ([EWCompanyID])
GO
CREATE NONCLUSTERED INDEX [IdxtblCompany_BY_IntName] ON [dbo].[tblCompany] ([IntName])
GO

-------------------------------
--Added Canadian Custom Program
-------------------------------

insert into tbluserfunction(functioncode, functiondesc) values('CACustom', 'Custom - Canadian Program')
go


/****** Object:  View [dbo].[vwMatrixTDExport]    Script Date: 02/16/2012 10:19:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwMatrixTDExport]
AS
SELECT     TOP (100) PERCENT casenbr, claimnbr, clientname, chartnbr, specialtydesc, examineecity, examineestate, examineename, DOI, doctorlastname, doctorcity, ApptDate, 
                      notes,
                          (SELECT     SUM(documenttotal) AS Expr1
                            FROM          dbo.TblAcctHeader
                            WHERE      (casenbr = dbo.vwdocument.casenbr) AND (documenttype = 'IN') AND (documentstatus = 'Final')
                            GROUP BY casenbr) AS InvoiceTotal,
                          (SELECT     SUM(documenttotal) AS Expr1
                            FROM          dbo.TblAcctHeader AS TblAcctHeader_2
                            WHERE      (casenbr = dbo.vwdocument.casenbr) AND (documenttype = 'VO') AND (documentstatus = 'Final')
                            GROUP BY casenbr) AS Vouchertotal,
                          (SELECT     SUM(taxamount1) AS Expr1
                            FROM          dbo.TblAcctHeader AS TblAcctHeader_1
                            WHERE      (casenbr = dbo.vwdocument.casenbr) AND (documenttype = 'IN') AND (documentstatus = 'Final')
                            GROUP BY casenbr) AS GST,
                          (SELECT     TOP (1) eventdate
                            FROM          dbo.tblCaseHistory
                            WHERE      (casenbr = dbo.vwdocument.casenbr) AND (type = 'FinalRpt')
                            ORDER BY eventdate DESC) AS ReportDate,
                          (SELECT     TOP (1) eventdate
                            FROM          dbo.tblCaseHistory AS tblCaseHistory_3
                            WHERE      (casenbr = dbo.vwdocument.casenbr) AND (type = 'Scheduled')
                            ORDER BY eventdate DESC) AS ScheduledDate,
                          (SELECT     TOP (1) eventdate
                            FROM          dbo.tblCaseHistory AS tblCaseHistory_2
                            WHERE      (casenbr = dbo.vwdocument.casenbr) AND (type = 'Cancel')
                            ORDER BY eventdate DESC) AS CancelDate,
                          (SELECT     TOP (1) eventdate
                            FROM          dbo.tblCaseHistory AS tblCaseHistory_1
                            WHERE      (casenbr = dbo.vwdocument.casenbr) AND (type = 'Reschedule')
                            ORDER BY eventdate DESC) AS RescheduledDate, OCF25Date AS DateofNotice, servicedesc, datecalledin AS dateadded, companycode, clientlastname, 
                      clientfirstname, medsrecd, ISNULL(caseusdvarchar1, 'Not Assigned') AS PrincipleInsurer, caseusddate2 AS ClaimantContactDate, companyusdvarchar1, 
                      AssessmentToAddress, company, calledinby, location, caseusdvarchar1 AS Brand
FROM         dbo.vwdocument
ORDER BY dateadded

GO

/****** Object:  View [dbo].[vwMatrixClientExport]    Script Date: 02/16/2012 10:25:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwMatrixClientExport]
AS
SELECT DISTINCT TOP 100 PERCENT claimnbr, clientname, chartnbr, specialtydesc, examineename, ApptDate,
                          (SELECT     TOP 1 eventdate
                            FROM          tblcasehistory
                            WHERE      tblcasehistory.casenbr = vwdocument.casenbr AND type = 'FinalRpt'
                            ORDER BY eventdate DESC) AS ReportDate,
                          (SELECT     TOP 1 eventdate
                            FROM          tblcasehistory
                            WHERE      tblcasehistory.casenbr = vwdocument.casenbr AND type = 'Scheduled'
                            ORDER BY eventdate DESC) AS ScheduledDate,
                          (SELECT     TOP 1 eventdate
                            FROM          tblcasehistory
                            WHERE      tblcasehistory.casenbr = vwdocument.casenbr AND type = 'Cancel'
                            ORDER BY eventdate DESC) AS CancelDate,
                          (SELECT     TOP 1 eventdate
                            FROM          tblcasehistory
                            WHERE      tblcasehistory.casenbr = vwdocument.casenbr AND type = 'Reschedule'
                            ORDER BY eventdate DESC) AS RescheduledDate, servicedesc, datecalledin AS dateadded, clientlastname, clientfirstname, medsrecd, 
                      examineelastname, examineefirstname, companycode, casenbr
FROM         dbo.vwdocument
ORDER BY datecalledin

GO


ALTER TABLE [tblEWParentCompany]
  ADD [CompanyFilter] VARCHAR(80)
GO


UPDATE tblControl SET DBVersion='1.65'
GO
