CREATE VIEW vwClientExport
AS
    SELECT  vwClientExportColumns.LastName ,
            vwClientExportColumns.FirstName ,
            vwClientExportColumns.Company ,
            vwClientExportColumns.title ,
            vwClientExportColumns.Prefix ,
            vwClientExportColumns.suffix ,
            vwClientExportColumns.Address1 ,
            vwClientExportColumns.Address2 ,
            vwClientExportColumns.City ,
            vwClientExportColumns.State ,
            vwClientExportColumns.Zip ,
            vwClientExportColumns.Phone ,
            vwClientExportColumns.extension ,
            vwClientExportColumns.Fax ,
            vwClientExportColumns.Email ,
            vwClientExportColumns.Marketer ,
            vwClientExportColumns.CompanyinternalName ,
            vwClientExportColumns.Status ,
            vwClientExportColumns.QARep ,
            vwClientExportColumns.Office ,
            vwClientExportColumns.CompanyCode ,
            vwClientExportColumns.ClientCode ,
            vwClientExportColumns.OfficeCode ,
            vwClientExportColumns.ClientType ,
            vwClientExportColumns.CompanyType ,
            vwClientExportColumns.FacilityName ,
            tblCompany.notes AS companynotes ,
            tblClient.notes AS clientnotes
    FROM    vwClientExportColumns
            INNER JOIN tblCompany ON vwClientExportColumns.companycode = tblCompany.companycode
            INNER JOIN tblClient ON vwClientExportColumns.clientcode = tblClient.clientcode
