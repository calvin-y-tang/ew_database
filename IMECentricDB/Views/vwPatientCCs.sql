 
CREATE VIEW vwPatientCCs
AS
    SELECT  tblExamineecc.ChartNbr ,
            tblExamineecc.ccCode ,
            tblCCAddress.Prefix ,
            tblCCAddress.LastName + ', ' + tblCCAddress.FirstName AS contact ,
            tblCCAddress.Address1 ,
            tblCCAddress.Address2 ,
            tblCCAddress.City ,
            tblCCAddress.State ,
            tblCCAddress.Phone ,
            tblCCAddress.Zip ,
            tblCCAddress.Phoneextension ,
            tblCCAddress.Fax ,
            tblCCAddress.Email ,
            tblCCAddress.UserIDAdded ,
            tblCCAddress.DateAdded ,
            tblCCAddress.UserIDEdited ,
            tblCCAddress.DateEdited ,
            tblCCAddress.Status
    FROM    tblExamineecc
            INNER JOIN tblCCAddress ON tblExamineecc.ccCode = tblCCAddress.ccCode
    WHERE   ( tblCCAddress.Status = 'Active' )
