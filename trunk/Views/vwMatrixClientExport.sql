CREATE VIEW vwMatrixClientExport
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
