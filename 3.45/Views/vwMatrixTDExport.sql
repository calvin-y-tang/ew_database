
CREATE VIEW vwMatrixTDExport
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
