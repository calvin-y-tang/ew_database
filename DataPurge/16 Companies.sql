-- **********************************************************************************************************
--
--   Description:
--        process Company data tables. Verify that items marked for deletion are OK to delete, if not then
--        revise their delete status
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- look for company items that we need to keep
     UPDATE tmpDelete
        SET OkToDelete=0
     --SELECT COUNT(*) FROM tmpDelete
      WHERE Type='Company'
        AND (
                  ID IN (SELECT DISTINCT CompanyCode FROM tblCompany WHERE EWCompanyID IS NOT NULL)
               --OR ID IN (SELECT DISTINCT CompanyCode FROM tblClient INNER JOIN tblCase ON tblCase.ClientCode = tblClient.ClientCode)
               --OR ID IN (SELECT DISTINCT CompanyCode FROM tblClient INNER JOIN tblCase ON tblCase.BillClientCode = tblClient.ClientCode)
               OR ID IN (SELECT DISTINCT CompanyCode FROM tblClient)
               OR ID IN (SELECT DISTINCT CompanyCode FROM tblAcctHeader)
            )

-- clean up the company data tables
     DELETE
       FROM tblCompanyDefDocument
      WHERE CompanyCode IN (SELECT ID FROM getID('Company'))

     DELETE
       FROM tblCompanyCoverLetter
      WHERE CompanyCode IN (SELECT ID FROM getID('Company'))

     DELETE
       FROM tblCompanyNetwork
      WHERE CompanyCode IN (SELECT ID FROM getID('Company'))

     DELETE
       FROM tblFRModifier
      WHERE CompanyCode IN (SELECT ID FROM getID('Company'))

     DELETE
       FROM tblCompany
      WHERE CompanyCode IN (SELECT ID FROM getID('Company'))

     DELETE
       FROM tblDrDoNotUse
      WHERE Type='CO' AND Code NOT IN (SELECT CompanyCode FROM tblCompany)
