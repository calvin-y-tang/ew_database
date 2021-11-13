CREATE VIEW vwClientExportColumns
AS
    SELECT DISTINCT
        tblClient.LastName,
        tblClient.FirstName,
        tblCompany.ExtName AS Company,
        tblClient.Title,
        tblClient.Prefix,
        tblClient.Suffix,
        tblClient.Addr1 AS Address1,
        tblClient.Addr2 AS Address2,
        tblClient.City,
        tblClient.State,
        tblClient.Zip,
        tblClient.Phone1 AS Phone,
        tblClient.Phone1Ext AS extension,
        tblClient.Fax,
        tblClient.Email,
        tblClient.MarketerCode AS Marketer,
        tblCompany.IntName AS CompanyinternalName,
        tblClient.Status,
        tblClient.QARep,
        tblOffice.ShortDesc AS Office,
        tblClient.CompanyCode,
        tblClient.ClientCode,
        tblOffice.OfficeCode,
        tblClientType.Description AS ClientType,
        tblEWCompanyType.Name AS CompanyType,
        tblEWFacility.ShortName AS FacilityName
    FROM
        tblClient
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    LEFT OUTER JOIN tblEWFacility ON tblCompany.EWFacilityID=tblEWFacility.EWFacilityID
    LEFT OUTER JOIN tblEWCompanyType ON tblCompany.EWCompanyTypeID=tblEWCompanyType.EWCompanyTypeID
    LEFT OUTER JOIN tblCase ON tblClient.ClientCode=tblCase.ClientCode
    LEFT OUTER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    LEFT OUTER JOIN tblClientType ON tblClient.TypeCode=tblClientType.TypeCode
