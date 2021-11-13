 
CREATE VIEW vwCCExport
AS
    SELECT DISTINCT
            tblCCAddress.LastName ,
            tblCCAddress.FirstName ,
            tblCCAddress.Prefix ,
            tblCCAddress.Company ,
            tblCCAddress.Address1 ,
            tblCCAddress.Address2 ,
            tblCCAddress.City ,
            tblCCAddress.State ,
            tblCCAddress.Zip ,
            tblCCAddress.Phone ,
            tblCCAddress.Phoneextension AS extension ,
            tblCCAddress.Fax ,
            tblCCAddress.Email ,
            tblCCAddress.Status ,
            tblCCAddress.OfficeCode ,
            tblOffice.Description AS Office
    FROM    tblCCAddress
            LEFT OUTER JOIN tblOffice ON tblCCAddress.OfficeCode = tblOffice.OfficeCode
