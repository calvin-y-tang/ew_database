CREATE VIEW vwPDFDoctorData
AS
    SELECT  DoctorCode ,
			LTRIM(RTRIM(ISNULL(firstName,'') + ' ' + ISNULL(lastName,'') + ' ' + ISNULL(credentials,''))) AS DoctorFullName ,
			[Credentials] AS DoctorDegree ,

			WCNbr AS DoctorWCNbr ,
            NPINbr AS DoctorNPINbr ,
			B.BlankValue AS	DoctorWALINbr ,
            LicenseNbr AS DoctorLicense ,
			CASE WHEN ISNULL(LicenseNbr,'')='' THEN '' ELSE '0B' END AS DoctorLicenseQualID ,
			CASE WHEN ISNULL(LicenseNbr,'')='' THEN '' ELSE '0B ' + LicenseNbr END AS DoctorLicenseWithQualPrefix ,
			LEFT(LicenseNbr, 2) + RIGHT(LicenseNbr, 2) AS TexasDoctorLicenseType ,
            
			Addr1 AS DoctorCorrespAddr1 ,
            Addr2 AS DoctorCorrespAddr2 ,
            City + ', ' + UPPER(State) + '  ' + Zip AS DoctorCorrespCityStateZip ,

			B.BlankValueLong AS DoctorCorrespFullAddress ,

			USDVarchar1 AS DoctorUSDVarchar1 ,
			USDVarchar2 AS DoctorUSDVarchar2 ,
			USDText1 AS DoctorUSDText1 ,
			USDText2 AS DoctorUSDText2 ,

            
			Phone + ' ' + ISNULL(PhoneExt, '') AS DoctorCorrespPhone ,
			Phone AS DoctorCorrespPhoneAreaCode ,
			Phone AS DoctorCorrespPhoneNumber , 

			TXMTaxID AS DoctorTXMTaxID , 
			SORMTaxID AS DoctorSORMTaxID , 
			TXMProviderName AS DoctorTXMProviderName , 
			SORMProviderName AS DoctorSORMProviderName 

    FROM    tblDoctor
			LEFT OUTER JOIN tblBlank AS B ON 1=1
