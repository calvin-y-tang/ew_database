CREATE VIEW vwClient
AS
    SELECT DISTINCT
            tblClient.LastName + ', ' + tblClient.FirstName AS Client ,
            tblCompany.IntName ,
            tblClient.Status ,
            tblClient.Email ,
            tblClient.LastName ,
            tblClient.FirstName ,
            tblClient.Addr1 ,
            tblClient.Addr2 ,
            tblClient.City ,
            tblClient.State ,
            tblClient.Zip ,
            tblClient.Phone1 ,
            tblClient.Phone1Ext ,
            tblClient.Fax ,
            tblClient.CaseType ,
            tblClient.CompanyCode ,
            tblCompany.ExtName ,
            tblClient.ClientCode ,
            tblEWFacility.LegalName AS CompanyName ,
            tblCase.OfficeCode ,
            tblClient.Prefix
    FROM    tblClient
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCase ON tblClient.ClientCode = tblCase.ClientCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            INNER JOIN tblEWFacility ON tblOffice.EWFacilityID = tblEWFacility.EWFacilityID;
