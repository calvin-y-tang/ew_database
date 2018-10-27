ALTER TABLE [tblCompany]
  ADD Prompt3rdPartyBill BIT NOT NULL DEFAULT 0
GO

ALTER TABLE tblIMEData
 ADD UsePeerBill BIT NOT NULL DEFAULT 0
GO

UPDATE tblIMEData SET UsePeerBill=(SELECT UsePeerBill FROM tblControl)
GO

UPDATE tblDoctor SET PrintOnCheckAs = CompanyName WHERE (OPType = 'OP') 
	AND (LEN(RTRIM(LTRIM(PrintOnCheckAs))) = 0 or PrintOnCheckAs IS NULL)
GO

DROP VIEW vwCaseAppt
GO
CREATE VIEW vwCaseAppt
AS
WITH allDoctors AS (
          SELECT  
               CA.CaseApptID ,
               ISNULL(CA.DoctorCode, CAP.DoctorCode) AS DoctorCode,
               CASE WHEN CA.DoctorCode IS NULL THEN
               LTRIM(RTRIM(ISNULL(DP.FirstName,'')+' '+ISNULL(DP.LastName,'')+' '+ISNULL(DP.Credentials,'')))
               ELSE
               LTRIM(RTRIM(ISNULL(D.FirstName,'')+' '+ISNULL(D.LastName,'')+' '+ISNULL(D.Credentials,'')))
               END AS DoctorName,
               ISNULL(CA.SpecialtyCode, CAP.SpecialtyCode) AS SpecialtyCode
           FROM tblCaseAppt AS CA
           LEFT OUTER JOIN tblDoctor AS D ON CA.DoctorCode=D.DoctorCode
           LEFT OUTER JOIN tblCaseApptPanel AS CAP ON CA.CaseApptID=CAP.CaseApptID
           LEFT OUTER JOIN tblDoctor AS DP ON CAP.DoctorCode=DP.DoctorCode
)
SELECT  DISTINCT
        CA.CaseApptID ,
        CA.CaseNbr ,
        CA.ApptStatusID ,
        S.Name AS ApptStatus,

        CA.ApptTime ,
        CA.LocationCode ,
        L.Location,

        CA.CanceledByID ,
        CB.Name AS CanceledBy ,
        CB.ExtName AS CanceledByExtName ,
        CA.Reason ,
        
        CA.DateAdded ,
        CA.UserIDAdded ,
        CA.DateEdited ,
        CA.UserIDEdited ,
        CA.LastStatusChg ,
        CAST(CASE WHEN CA.DoctorCode IS NULL THEN 1 ELSE 0 END AS BIT) AS IsPanel,
        (STUFF((
        SELECT '\'+ CAST(DoctorCode AS VARCHAR) FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(100)'),1,1,'')) AS DoctorCodes,
        (STUFF((
        SELECT '\'+DoctorName FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')) AS DoctorNames,
        (STUFF((
        SELECT '\'+ SpecialtyCode FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')) AS Specialties,
          CA.DateReceived, 
          FZ.Name AS FeeZoneName,
		  C.OfficeCode
     FROM tblCaseAppt AS CA
	 INNER JOIN tblCase AS C ON C.CaseNbr = CA.CaseNbr
     INNER JOIN tblApptStatus AS S ON CA.ApptStatusID = S.ApptStatusID
     LEFT OUTER JOIN tblCanceledBy AS CB ON CA.CanceledByID=CB.CanceledByID
     LEFT OUTER JOIN tblLocation AS L ON CA.LocationCode=L.LocationCode
     LEFT OUTER JOIN tblEWFeeZone AS FZ ON CA.EWFeeZoneID = FZ.EWFeeZoneID

GO


DROP VIEW vwPDFCaseData
GO
CREATE VIEW vwPDFCaseData
AS
    SELECT  C.CaseNbr ,
			C.PanelNbr ,
			C.OfficeCode ,
            C.ClaimNbr ,
            C.Jurisdiction ,
            C.WCBNbr ,
            
			C.DoctorCode AS CaseDoctorCode ,
            C.DoctorLocation AS CaseLocationCode ,
			C.DoctorSpecialty AS CaseDoctorSpecialty ,
            C.DoctorName ,
            C.ApptDate ,
            C.ApptTime ,

			C.MasterCaseNbr ,
			C.MasterSubCase ,
			B.BlankValue AS MasterCaseDoctorName ,
			B.BlankValue AS MasterCaseDoctorNPINbr ,
			B.BlankValue AS MasterCaseDoctorLicense ,
			B.BlankValue AS MasterCaseDoctorLicQualID ,
            
			C.DateOfInjury AS DOIValue ,
			B.BlankValue AS DOI ,
			B.BlankValue AS InjuryCurrentDateMM ,
			B.BlankValue AS InjuryCurrentDateDD ,
			B.BlankValue AS InjuryCurrentDateYYYY ,
			CASE WHEN C.DateOfInjury IS NULL THEN '' ELSE '431' END AS InjuryCurrentDateQual ,

			B.BlankValue AS ICD9Code1a ,
			B.BlankValue AS ICD9Code1b ,
			B.BlankValue AS ICD9Code1c ,
			B.BlankValue AS ICD9Code2a ,
			B.BlankValue AS ICD9Code2b ,
			B.BlankValue AS ICD9Code2c ,
			B.BlankValue AS ICD9Code3a ,
			B.BlankValue AS ICD9Code3b ,
			B.BlankValue AS ICD9Code3c ,
			B.BlankValue AS ICD9Code4a ,
			B.BlankValue AS ICD9Code4b ,
			B.BlankValue AS ICD9Code4c ,

            C.ICDCodeA AS ICD9Code1 ,
            C.ICDCodeB AS ICD9Code2 ,
            C.ICDCodeC AS ICD9Code3 ,
            C.ICDCodeD AS ICD9Code4 ,
			C.ICDCodeA ,
			C.ICDCodeB ,
			C.ICDCodeC ,
			C.ICDCodeD ,
			C.ICDCodeE ,
			C.ICDCodeF ,
			C.ICDCodeG ,
			C.ICDCodeH ,
			C.ICDCodeI ,
			C.ICDCodeJ ,
			C.ICDCodeK ,
			C.ICDCodeL ,

			C.ICDFormat ,
			B.BlankValue AS ICDIndicator ,


			B.BlankValueLong AS ProblemList ,
            
			CO.ExtName AS Company ,
            
			CL.FirstName + ' ' + CL.LastName AS ClientName ,
			B.BlankValue AS ReferringProvider,	--Fill by system option

            CL.Addr1 AS ClientAddr1 ,
            CL.Addr2 AS ClientAddr2 ,
            CL.City + ', ' + CL.State + '  ' + CL.Zip AS ClientCityStateZip ,
            B.BlankValue AS ClientFullAddress ,
            CL.Phone1 + ' ' + ISNULL(CL.Phone1ext, ' ') AS ClientPhone , --Need Extension?
            CL.Fax AS ClientFax ,
            CL.Email AS ClientEmail ,
			CL.Phone1 AS ClientPhoneAreaCode ,
			CL.Phone1 AS ClientPhoneNumber ,
			CL.Fax AS ClientFaxAreaCode ,
			CL.Fax AS ClientFaxNumber ,

            EE.LastName AS ExamineeLastName ,
            EE.FirstName AS ExamineeFirstName ,
            EE.MiddleInitial AS ExamineeMiddleInitial ,
			B.BlankValue AS ExamineeNameLFMI ,
			B.BlankValue AS ExamineeNameFMIL ,

            EE.SSN AS ExamineeSSN ,
            EE.SSN AS ExamineeSSNLast4Digits ,

            EE.Addr1 AS ExamineeAddr1 ,
            EE.Addr2 AS ExamineeAddr2 ,
            EE.City + ', ' + EE.State + '  ' + EE.Zip AS ExamineeCityStateZip ,
            EE.City AS ExamineeCity ,
            EE.State AS ExamineeState ,
            EE.Zip AS ExamineeZip ,
			B.BlankValue AS ExamineeAddress ,
			B.BlankValue AS ExamineeFullAddress ,
            EE.County AS ExamineeCounty ,

            EE.Phone1 AS ExamineePhone ,
            EE.Phone1 AS ExamineePhoneAreaCode ,
            EE.Phone1 AS ExamineePhoneNumber ,

            EE.DOB AS ExamineeDOBValue ,
			B.BlankValue AS ExamineeDOB ,
			B.BlankValue AS ExamineeDOBMM ,
			B.BlankValue AS ExamineeDOBDD ,
			B.BlankValue AS ExamineeDOBYYYY ,

            EE.Sex AS ExamineeSex ,
			EE.Sex AS ExamineeSexM ,
			EE.Sex AS ExamineeSexF ,
            EE.Employer ,
            EE.EmployerAddr1 ,
            EE.EmployerCity ,
            EE.EmployerState ,
            EE.EmployerZip ,
			B.BlankValue AS EmployerFullAddress ,

            EE.EmployerPhone ,
            EE.EmployerPhone AS EmployerPhoneAreaCode ,
            EE.EmployerPhone AS EmployerPhoneNumber ,

            EE.EmployerFax ,
            EE.EmployerEmail ,

            EE.TreatingPhysicianAddr1 ,
            EE.TreatingPhysicianCity ,
            EE.TreatingPhysicianState ,
            EE.TreatingPhysicianZip ,
			B.BlankValue AS TreatingPhysicianFullAddress ,

            EE.TreatingPhysicianPhone ,
            EE.TreatingPhysicianPhone AS TreatingPhysicianPhoneAreaCode ,
            EE.TreatingPhysicianPhone AS TreatingPhysicianPhoneNumber ,
            EE.TreatingPhysicianFax ,
            EE.TreatingPhysicianFax AS TreatingPhysicianFaxAreaCode ,
            EE.TreatingPhysicianFax AS TreatingPhysicianFaxNumber ,

            EE.TreatingPhysicianLicenseNbr ,
            EE.TreatingPhysician ,
            EE.TreatingPhysicianCredentials AS TreatingPhysicianDegree ,

            PA.FirstName + ' ' + PA.LastName AS PAttorneyName ,
            PA.Address1 AS PAttorneyAddr1 ,
            PA.Address2 AS PAttorneyAddr2 ,
            PA.City + ', ' + PA.State + '  ' + PA.Zip AS PAttorneyCityStateZip ,
			B.BlankValue AS PAttorneyFullAddress ,

            PA.Phone + ' ' + ISNULL(PA.Phoneextension, '') AS PAttorneyPhone , --Need Extension?
			PA.Phone AS PAttorneyPhoneAreaCode ,
			PA.Phone AS PAttorneyPhoneNumber ,
            PA.Fax AS PAttorneyFax ,
			PA.Fax AS PAttorneyFaxAreaCode ,
			PA.Fax AS PAttorneyFaxNumber ,
            PA.Email AS PAttorneyEmail ,

			CT.EWBusLineID ,
			O.BillingProviderNonNPINbr AS OfficeBillingProviderNonNPINbr

    FROM    tblCase AS C
            INNER JOIN tblExaminee AS EE ON EE.chartNbr = C.chartNbr
            INNER JOIN tblClient AS CL ON C.clientCode = CL.clientCode
            INNER JOIN tblCompany AS CO ON CL.companyCode = CO.companyCode
			INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
			INNER JOIN tblOffice AS O ON C.OfficeCode = O.OfficeCode
            LEFT OUTER JOIN tblCCAddress AS PA ON C.plaintiffAttorneyCode = PA.ccCode
			LEFT OUTER JOIN tblBlank AS B ON 1=1
GO


DROP VIEW vwLibertyExport
GO
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
              WHERE     ( DocumentNbr = tblAcctHeader.DocumentNbr )
                        AND ( DocumentType = tblAcctHeader.DocumentType )
              ORDER BY  LineNbr
            ) AS CPTCode ,
            ( SELECT TOP ( 1 )
                        Modifier
              FROM      tblAcctDetail AS TblAcctDetail_1
              WHERE     ( DocumentNbr = tblAcctHeader.DocumentNbr )
                        AND ( DocumentType = tblAcctHeader.DocumentType )
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
			tblEWFacility.Zip AS EWFacilityZip
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
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_Client_IsPhotoRqd]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_Client_IsPhotoRqd];
GO

CREATE PROCEDURE [proc_Client_IsPhotoRqd]
(
	@clientcode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT ISNULL(dbo.tblClient.PhotoRqd, dbo.tblCompany.PhotoRqd) AS photoRqd
		FROM tblClient INNER JOIN dbo.tblCompany ON dbo.tblClient.CompanyCode = dbo.tblCompany.CompanyCode
        WHERE tblClient.ClientCode = @clientcode

	SET @Err = @@Error

	RETURN @Err
END
GO


UPDATE tblControl SET DBVersion='2.64'
GO
