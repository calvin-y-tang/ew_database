 
CREATE VIEW vwCaseCC
AS
    SELECT  tblCase.CaseNbr ,
            tblCCAddress.Prefix ,
            tblCCAddress.LastName ,
            tblCCAddress.FirstName ,
            CASE WHEN tblCCAddress.LastName IS NULL THEN ''
                 ELSE ISNULL(tblCCAddress.Prefix, '') + ' '
                      + ISNULL(tblCCAddress.FirstName, '') + ' '
                      + ISNULL(tblCCAddress.LastName, '')
            END AS contact ,
            tblCCAddress.Company ,
            tblCCAddress.Address1 ,
            tblCCAddress.Address2 ,
            tblCCAddress.City ,
            UPPER(tblCCAddress.State) AS State ,
            tblCCAddress.Zip ,
            tblCCAddress.Fax ,
            tblCCAddress.Email ,
            tblCase.ChartNbr ,
            tblCCAddress.Status ,
            tblCCAddress.ccCode ,
            tblCCAddress.City + ', ' + UPPER(tblCCAddress.State) + '  ' + tblCCAddress.Zip AS CityStateZip,
			tblCase.OfficeCode
    FROM    tblCase
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblExamineecc ON tblCase.ChartNbr = tblExamineecc.ChartNbr
            INNER JOIN tblCCAddress ON tblExamineecc.ccCode = tblCCAddress.ccCode
    WHERE   ( tblCCAddress.Status = 'Active' )
