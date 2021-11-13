CREATE VIEW vwReferralbyMonthDateReceivedDocs
AS
    SELECT  tblCase.casenbr ,
            tblCase.status ,
            tblCase.doctorlocation AS locationcode ,
            tblCase.marketercode ,
            tblCase.clientcode ,
            tblClient.companycode ,
            ISNULL(tblUser.LastName,'') + CASE WHEN ISNULL(tblUser.LastName,'')='' OR ISNULL(tblUser.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(tblUser.FirstName, '') AS marketer ,
            tblCase.DateReceived ,
            tblCompany.intname AS companyname ,
            tblClient.lastname + ', ' + tblClient.firstname AS clientname ,
            tblClient.lastname ,
            tblDoctor.lastname + ', ' + tblDoctor.firstname AS doctorname ,
            tblLocation.location ,
            YEAR(tblCase.DateReceived) AS year ,
            CASE WHEN MONTH(tblCase.DateReceived) = 1 THEN 1
                 ELSE 0
            END AS jan ,
            CASE WHEN MONTH(tblCase.DateReceived) = 2 THEN 1
                 ELSE 0
            END AS feb ,
            CASE WHEN MONTH(tblCase.DateReceived) = 3 THEN 1
                 ELSE 0
            END AS mar ,
            CASE WHEN MONTH(tblCase.DateReceived) = 4 THEN 1
                 ELSE 0
            END AS apr ,
            CASE WHEN MONTH(tblCase.DateReceived) = 5 THEN 1
                 ELSE 0
            END AS may ,
            CASE WHEN MONTH(tblCase.DateReceived) = 6 THEN 1
                 ELSE 0
            END AS jun ,
            CASE WHEN MONTH(tblCase.DateReceived) = 7 THEN 1
                 ELSE 0
            END AS jul ,
            CASE WHEN MONTH(tblCase.DateReceived) = 8 THEN 1
                 ELSE 0
            END AS aug ,
            CASE WHEN MONTH(tblCase.DateReceived) = 9 THEN 1
                 ELSE 0
            END AS sep ,
            CASE WHEN MONTH(tblCase.DateReceived) = 10 THEN 1
                 ELSE 0
            END AS oct ,
            CASE WHEN MONTH(tblCase.DateReceived) = 11 THEN 1
                 ELSE 0
            END AS nov ,
            CASE WHEN MONTH(tblCase.DateReceived) = 12 THEN 1
                 ELSE 0
            END AS dec ,
            1 AS total ,
            tblCaseType.description AS CasetypeDesc ,
            tblServices.description AS service ,
            tblServices.servicecode ,
            tblCase.casetype ,
            tblCase.officecode ,
            tblOffice.description AS officename ,
            tblCase.QARep AS QARepCode ,
            tblDoctor.doctorcode
    FROM    tblCase
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            LEFT OUTER JOIN tblUser ON tblCase.marketercode = tblUser.userid
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
    WHERE   ( tblCase.status <> 9 )
    UNION
    SELECT  tblCase.casenbr ,
            tblCase.status ,
            tblCase.doctorlocation AS locationcode ,
            tblCase.marketercode ,
            tblCase.clientcode ,
            tblClient.companycode ,
            tblUser.lastname + ', ' + tblUser.firstname AS marketer ,
            tblCase.DateReceived ,
            tblCompany.intname AS companyname ,
            tblClient.lastname + ', ' + tblClient.firstname AS clientname ,
            tblClient.lastname ,
            tblDoctor.lastname + ', ' + tblDoctor.firstname AS doctorname ,
            tblLocation.location ,
            YEAR(tblCase.DateReceived) AS year ,
            CASE WHEN MONTH(tblCase.DateReceived) = 1 THEN 1
                 ELSE 0
            END AS jan ,
            CASE WHEN MONTH(tblCase.DateReceived) = 2 THEN 1
                 ELSE 0
            END AS feb ,
            CASE WHEN MONTH(tblCase.DateReceived) = 3 THEN 1
                 ELSE 0
            END AS mar ,
            CASE WHEN MONTH(tblCase.DateReceived) = 4 THEN 1
                 ELSE 0
            END AS apr ,
            CASE WHEN MONTH(tblCase.DateReceived) = 5 THEN 1
                 ELSE 0
            END AS may ,
            CASE WHEN MONTH(tblCase.DateReceived) = 6 THEN 1
                 ELSE 0
            END AS jun ,
            CASE WHEN MONTH(tblCase.DateReceived) = 7 THEN 1
                 ELSE 0
            END AS jul ,
            CASE WHEN MONTH(tblCase.DateReceived) = 8 THEN 1
                 ELSE 0
            END AS aug ,
            CASE WHEN MONTH(tblCase.DateReceived) = 9 THEN 1
                 ELSE 0
            END AS sep ,
            CASE WHEN MONTH(tblCase.DateReceived) = 10 THEN 1
                 ELSE 0
            END AS oct ,
            CASE WHEN MONTH(tblCase.DateReceived) = 11 THEN 1
                 ELSE 0
            END AS nov ,
            CASE WHEN MONTH(tblCase.DateReceived) = 12 THEN 1
                 ELSE 0
            END AS dec ,
            1 AS total ,
            tblCaseType.description AS CasetypeDesc ,
            tblServices.description AS service ,
            tblServices.servicecode ,
            tblCase.casetype ,
            tblCase.officecode ,
            tblOffice.description AS officename ,
            tblCase.QARep AS QARepcode ,
            tblDoctor.doctorcode
    FROM    tblCase
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            INNER JOIN tblCasePanel ON tblCase.PanelNbr = tblCasePanel.panelnbr
            INNER JOIN tblDoctor ON tblCasePanel.doctorcode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblUser ON tblCase.marketercode = tblUser.userid
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
    WHERE   ( tblCase.status <> 9 )


