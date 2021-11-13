
-- 01/08/2015 - JAP - Issue 2176. Create new SP to source the AttorneyCases form.
CREATE PROCEDURE [dbo].[spAttorneyCases]
     @AttorneyCode AS INTEGER
AS
     SELECT 
          CaseNbr, 
		  ExtCaseNbr,
          SUBSTRING(AttyTypes, 1, LEN(AttyTypes) - 1) AS AttorneyTypes,
          ExamineeName,
          ApptDate, 
          Description,
          ClientCode,
          ClientName,
          CompanyCode,
          IntName,
          Location, 
          DoctorCode, 
          StatusDesc, 
          DoctorName, 
          PlaintiffAttorneyCode, 
          DefenseAttorneyCode, 
          DefParaLegal, 
	  ShortDesc 
     FROM 
          (SELECT 
               dbo.tblCase.casenbr,  
			   dbo.tblCase.ExtCaseNbr,
               dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineeName, 
               dbo.tblCase.ApptDate, 
               dbo.tblCaseType.description, 
               dbo.tblCase.clientcode, 
               dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, 
               dbo.tblClient.companycode, 
               dbo.tblCompany.intname, 
               dbo.tblLocation.location, 
               dbo.tblDoctor.doctorcode, 
               dbo.tblQueues.statusdesc, 
               dbo.tblCase.DoctorName,
               -- @AttorneyCode AS AttrnyCode,
               dbo.tblCase.PlaintiffAttorneyCode, 
               dbo.tblCase.DefenseAttorneyCode, 
               dbo.tblCase.DefParaLegal, 
               CASE 
                    WHEN dbo.tblCase.PlaintiffAttorneyCode IS NOT NULL AND dbo.tblCase.PlaintiffAttorneyCode = @AttorneyCode
                    THEN 'PA,' 
                    ELSE '' 
               END 
               +
               CASE 
                    WHEN dbo.tblCase.DefenseAttorneyCode IS NOT NULL AND dbo.tblCase.DefenseAttorneyCode = @AttorneyCode 
                    THEN 'DA,' 
                    ELSE '' 
               END 
               +
               CASE 
                    WHEN dbo.tblCase.DefParaLegal IS NOT NULL AND dbo.tblCase.DefParaLegal = @AttorneyCode
                    THEN 'DP,' 
                    ELSE '' 
               END  
               +
               CASE 
                    WHEN dbo.tblExamineeCC.ccCode IS NOT NULL AND dbo.tblExamineeCC.ccCode = @AttorneyCode
                    THEN 'CC,' 
                    ELSE '' 
               END AS AttyTypes, 
	       dbo.tbloffice.ShortDesc 
          FROM 
               dbo.tblCase 
                    INNER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
                    INNER JOIN dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode
                    INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
                    INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
                    LEFT OUTER JOIN dbo.tblExamineeCC ON dbo.tblCase.chartnbr = dbo.tblExamineeCC.chartnbr AND dbo.tblExamineeCC.ccCode = @AttorneyCode
                    LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode 
                    LEFT OUTER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
                    LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode 
	            LEFT OUTER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode 
          WHERE 
               dbo.tblCase.PlaintiffAttorneyCode = @AttorneyCode 
            OR dbo.tblCase.DefenseAttorneyCode = @AttorneyCode
            OR dbo.tblCase.DefParaLegal = @AttorneyCode
			OR dbo.tblExamineeCC.ccCode = @AttorneyCode
          ) AS CaseListForAttorney
