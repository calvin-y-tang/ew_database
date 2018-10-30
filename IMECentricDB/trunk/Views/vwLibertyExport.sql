CREATE VIEW vwLibertyExport
AS
    SELECT  tblCase.DateReceived ,
            tblCase.ClaimNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblClient.LastName + '. ' + tblClient.FirstName AS ClientName ,
            tblCase.Jurisdiction ,
            tblAcctHeader.ApptDate ,
            tblDoctor.LastName + ', ' + tblDoctor.FirstName AS Doctorname ,
            tblSpecialty.Description AS Specialty ,
            tblAcctHeader.DocumentTotal AS Charge ,
            tblAcctHeader.DocumentNbr ,
            tblAcctHeader.DocumentType ,
            tblCompany.ExtName AS Company ,
            tblCase.SInternalCaseNbr AS InternalCaseNbr ,
            ( SELECT TOP ( 1 )
                        CPTCode
              FROM      tblAcctDetail
              WHERE     ( HeaderID = tblAcctHeader.HeaderID )
              ORDER BY  LineNbr
            ) AS CPTCode ,
            ( SELECT TOP ( 1 )
                        Modifier
              FROM      tblAcctDetail AS TblAcctDetail_1
              WHERE     ( HeaderID = tblAcctHeader.HeaderID )
              ORDER BY  LineNbr
            ) AS CPTModifier ,
            ( SELECT TOP ( 1 )
                        EventDate
              FROM      tblCaseHistory
              WHERE     ( CaseNbr = tblCase.CaseNbr )
              ORDER BY  EventDate DESC
            ) AS DateFinalized ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.DocumentStatus ,
            tblAcctHeader.CaseNbr ,
            tblCase.ServiceCode ,
            tblServices.Description AS Service ,
            tblCaseType.ShortDesc AS CaseType ,
            tblClient.USDVarchar2 AS Market ,
            tblCase.USDVarChar1 AS RequestedAs ,
            tblCase.USDInt1 AS ReferralNbr ,
            tblEWFacility.LegalName AS EWFacilityLegalName,
            tblEWFacility.Address AS EWFacilityAddress,
            tblEWFacility.City AS EWFacilityCity,
            tblEWFacility.State AS EWFacilityState,
            tblEWFacility.Zip AS EWFacilityZip,
            tblCase.OfficeCode
    FROM    tblCase
            INNER JOIN tblAcctHeader ON tblCase.CaseNbr = tblAcctHeader.CaseNbr
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblEWFacility ON tblEWFacility.EWFacilityID = tblAcctHeader.EWFacilityID
            LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty = tblSpecialty.SpecialtyCode
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
    WHERE   ( tblAcctHeader.DocumentType = 'IN' )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )