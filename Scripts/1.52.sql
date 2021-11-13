
----------------------------------------------------------------
--Add new fields to capture system information when user logins
----------------------------------------------------------------


ALTER TABLE [tblUser]
  ADD [HorzRes] INTEGER
GO

ALTER TABLE [tblUser]
  ADD [VertRes] INTEGER
GO

ALTER TABLE [tblUser]
  ADD [ColorDepth] INTEGER
GO

ALTER TABLE [tblUser]
  ADD [FontSize] INTEGER
GO

ALTER TABLE [tblUser]
  ADD [MonitorCount] INTEGER
GO

ALTER TABLE [tblUser]
  ADD [TotalRAM] INTEGER
GO

ALTER TABLE [tblUser]
  ADD [AvailRAM] INTEGER
GO


---------------------------------------------------------------------
--Views for Referral by month using Date Received
---------------------------------------------------------------------

CREATE VIEW [dbo].[vwReferralbyMonthDateReceived]
AS
    SELECT  dbo.tblCase.casenbr ,
            dbo.tblCase.status ,
            dbo.tblCase.doctorlocation AS locationcode ,
            dbo.tblCase.marketercode ,
            dbo.tblCase.clientcode ,
            dbo.tblClient.companycode ,
            dbo.tblUser.lastname + ', ' + dbo.tblUser.firstname AS marketer ,
            dbo.tblCase.DateReceived ,
            dbo.tblCompany.intname AS companyname ,
            dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname ,
            dbo.tblClient.lastname ,
            dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS doctorname ,
            dbo.tblLocation.location ,
            YEAR(dbo.tblCase.DateReceived) AS year ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 1 THEN 1
                 ELSE 0
            END AS jan ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 2 THEN 1
                 ELSE 0
            END AS feb ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 3 THEN 1
                 ELSE 0
            END AS mar ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 4 THEN 1
                 ELSE 0
            END AS apr ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 5 THEN 1
                 ELSE 0
            END AS may ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 6 THEN 1
                 ELSE 0
            END AS jun ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 7 THEN 1
                 ELSE 0
            END AS jul ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 8 THEN 1
                 ELSE 0
            END AS aug ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 9 THEN 1
                 ELSE 0
            END AS sep ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 10 THEN 1
                 ELSE 0
            END AS oct ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 11 THEN 1
                 ELSE 0
            END AS nov ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 12 THEN 1
                 ELSE 0
            END AS dec ,
            1 AS total ,
            dbo.tblCaseType.description AS CasetypeDesc ,
            dbo.tblServices.description AS service ,
            dbo.tblServices.servicecode ,
            dbo.tblCase.casetype ,
            dbo.tblCase.officecode ,
            dbo.tblOffice.description AS officename ,
            dbo.tblCase.QARep AS QARepcode ,
            dbo.tblDoctor.doctorcode
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
            INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
            INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            INNER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode
            LEFT OUTER JOIN dbo.tblUser ON dbo.tblCase.marketercode = dbo.tblUser.userid
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
    WHERE   ( dbo.tblCase.status <> 9 )
GO

CREATE VIEW [dbo].[vwReferralbyMonthDateReceivedDocs]
AS
    SELECT  dbo.tblCase.casenbr ,
            dbo.tblCase.status ,
            dbo.tblCase.doctorlocation AS locationcode ,
            dbo.tblCase.marketercode ,
            dbo.tblCase.clientcode ,
            dbo.tblClient.companycode ,
            dbo.tblUser.lastname + ', ' + dbo.tblUser.firstname AS marketer ,
            dbo.tblCase.DateReceived ,
            dbo.tblCompany.intname AS companyname ,
            dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname ,
            dbo.tblClient.lastname ,
            dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS doctorname ,
            dbo.tblLocation.location ,
            YEAR(dbo.tblCase.DateReceived) AS year ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 1 THEN 1
                 ELSE 0
            END AS jan ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 2 THEN 1
                 ELSE 0
            END AS feb ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 3 THEN 1
                 ELSE 0
            END AS mar ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 4 THEN 1
                 ELSE 0
            END AS apr ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 5 THEN 1
                 ELSE 0
            END AS may ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 6 THEN 1
                 ELSE 0
            END AS jun ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 7 THEN 1
                 ELSE 0
            END AS jul ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 8 THEN 1
                 ELSE 0
            END AS aug ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 9 THEN 1
                 ELSE 0
            END AS sep ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 10 THEN 1
                 ELSE 0
            END AS oct ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 11 THEN 1
                 ELSE 0
            END AS nov ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 12 THEN 1
                 ELSE 0
            END AS dec ,
            1 AS total ,
            dbo.tblCaseType.description AS CasetypeDesc ,
            dbo.tblServices.description AS service ,
            dbo.tblServices.servicecode ,
            dbo.tblCase.casetype ,
            dbo.tblCase.officecode ,
            dbo.tblOffice.description AS officename ,
            dbo.tblCase.QARep AS QARepCode ,
            dbo.tblDoctor.doctorcode
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
            INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
            INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            INNER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode
            LEFT OUTER JOIN dbo.tblUser ON dbo.tblCase.marketercode = dbo.tblUser.userid
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
    WHERE   ( dbo.tblCase.status <> 9 )
    UNION
    SELECT  dbo.tblCase.casenbr ,
            dbo.tblCase.status ,
            dbo.tblCase.doctorlocation AS locationcode ,
            dbo.tblCase.marketercode ,
            dbo.tblCase.clientcode ,
            dbo.tblClient.companycode ,
            dbo.tblUser.lastname + ', ' + dbo.tblUser.firstname AS marketer ,
            dbo.tblCase.DateReceived ,
            dbo.tblCompany.intname AS companyname ,
            dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname ,
            dbo.tblClient.lastname ,
            dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS doctorname ,
            dbo.tblLocation.location ,
            YEAR(dbo.tblCase.DateReceived) AS year ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 1 THEN 1
                 ELSE 0
            END AS jan ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 2 THEN 1
                 ELSE 0
            END AS feb ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 3 THEN 1
                 ELSE 0
            END AS mar ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 4 THEN 1
                 ELSE 0
            END AS apr ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 5 THEN 1
                 ELSE 0
            END AS may ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 6 THEN 1
                 ELSE 0
            END AS jun ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 7 THEN 1
                 ELSE 0
            END AS jul ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 8 THEN 1
                 ELSE 0
            END AS aug ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 9 THEN 1
                 ELSE 0
            END AS sep ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 10 THEN 1
                 ELSE 0
            END AS oct ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 11 THEN 1
                 ELSE 0
            END AS nov ,
            CASE WHEN MONTH(dbo.tblCase.DateReceived) = 12 THEN 1
                 ELSE 0
            END AS dec ,
            1 AS total ,
            dbo.tblCaseType.description AS CasetypeDesc ,
            dbo.tblServices.description AS service ,
            dbo.tblServices.servicecode ,
            dbo.tblCase.casetype ,
            dbo.tblCase.officecode ,
            dbo.tblOffice.description AS officename ,
            dbo.tblCase.QARep AS QARepcode ,
            dbo.tblDoctor.doctorcode
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
            INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
            INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            INNER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode
            INNER JOIN dbo.tblCasePanel ON dbo.tblCase.PanelNbr = dbo.tblCasePanel.panelnbr
            INNER JOIN dbo.tblDoctor ON dbo.tblCasePanel.doctorcode = dbo.tblDoctor.doctorcode
            LEFT OUTER JOIN dbo.tblUser ON dbo.tblCase.marketercode = dbo.tblUser.userid
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
    WHERE   ( dbo.tblCase.status <> 9 )

GO


UPDATE tblControl SET DBVersion='1.52'
GO
