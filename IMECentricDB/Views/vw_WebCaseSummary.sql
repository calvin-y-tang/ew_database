CREATE VIEW vw_WebCaseSummary

AS

SELECT
	--case
	tblCase.casenbr,
	tblCase.ExtCaseNbr,
	tblCase.chartnbr,
	tblCase.doctorlocation,
	tblCase.clientcode,
	tblCase.Appttime,
	tblCase.dateofinjury,
	tblCase.dateofinjury2,
	tblCase.dateofinjury3,
	tblCase.dateofinjury4,
	tblCase.notes,
	tblCase.DoctorName,
	tblCase.ClaimNbrExt,
	tblCase.ApptDate,
	tblCase.claimnbr,
	tblCase.jurisdiction,
	tblCase.WCBNbr,
	tblCase.specialinstructions,
	tblCase.HearingDate,
	tblCase.requesteddoc,
	tblCase.sreqspecialty,
	tblCase.schedulenotes,
	tblCase.AttorneyNote,
	tblCase.BillingNote,
	tblCase.InsuringCompany,

	--examinee
	tblExaminee.lastname,
	tblExaminee.firstname,
	tblExaminee.addr1,
	tblExaminee.addr2,
	tblExaminee.city,
	tblExaminee.state,
	tblExaminee.zip,
	tblExaminee.phone1,
	tblExaminee.phone2,
	tblExaminee.mobilephone,
	tblExaminee.SSN,
	tblExaminee.sex,
	tblExaminee.DOB,
	tblExaminee.note,
	tblExaminee.county,
	tblExaminee.prefix,
	tblExaminee.fax,
	tblExaminee.email,
	tblExaminee.insured,

	(Case ISNULL(tblcase.EmployerID, 0)
    WHEN 0
    THEN tblExaminee.Employer  
	ELSE tblEmployer.Name  
	END) AS Employer,  


	tblExaminee.treatingphysician,
	tblExaminee.InsuredAddr1,
	tblExaminee.InsuredCity,
	tblExaminee.InsuredState,
	tblExaminee.InsuredZip,
	tblExaminee.InsuredSex,
	tblExaminee.InsuredRelationship,
	tblExaminee.InsuredPhone,
	tblExaminee.InsuredPhoneExt,
	tblExaminee.InsuredFax,
	tblExaminee.InsuredEmail,
	tblExaminee.ExamineeStatus,
	tblExaminee.TreatingPhysicianAddr1,
	tblExaminee.TreatingPhysicianCity,
	tblExaminee.TreatingPhysicianState,
	tblExaminee.TreatingPhysicianZip,
	tblExaminee.TreatingPhysicianPhone,
	tblExaminee.TreatingPhysicianPhoneExt,
	tblExaminee.TreatingPhysicianFax,
	tblExaminee.TreatingPhysicianEmail,

	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.EmployerAddr1  
		ELSE tblEmployerAddress.Address1 
		END) AS EmployerAddr1,  

	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.EmployerCity  
		ELSE tblEmployerAddress.City  
		END) AS EmployerCity,  

	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.EmployerState  
		ELSE tblEmployerAddress.State  
		END) AS EmployerState,  

	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.EmployerZip  
		ELSE tblEmployerAddress.Zip  
		END) AS EmployerZip,  
			  
	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.EmployerPhone  
		ELSE tblEmployerAddress.Phone  
		END) AS EmployerPhone,  

	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.EmployerPhoneExt  
		ELSE tblEmployerAddress.PhoneExt   
		END) AS EmployerPhoneExt,  

	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.EmployerFax  
		ELSE tblEmployerAddress.Fax  
		END) AS EmployerFax,  
            
	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.EmployerEmail  
		ELSE tblEmployerAddress.Email  
		END) AS EmployerEmail,  

	tblExaminee.Country,
	tblExaminee.policynumber,
	
	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.EmployerContactFirstName  
		ELSE tblEmployerAddress.ContactFirst  
		END) AS EmployerContactFirstName,  
            
	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.EmployerContactLastName  
		ELSE tblEmployerAddress.ContactLast  
		END) AS EmployerContactLastName,  
	
	tblExaminee.TreatingPhysicianLicenseNbr,
	tblExaminee.TreatingPhysicianTaxID,

	--case type
	tblCaseType.code,
	tblCaseType.description,
	tblCaseType.instructionfilename,
	tblCaseType.WebID,
	tblCaseType.ShortDesc,

	--services
	tblServices.description AS servicedescription,
	tblServices.DaysToCommitDate,
	tblServices.CalcFrom,
	tblServices.ServiceType,

	--office
	tblOffice.description AS officedesc,

	--client
	tblClient.companycode,
	tblClient.clientnbrold,
	tblClient.lastname AS clientlname,
	tblClient.firstname AS clientfname,

	--defense attorney
	cc1.cccode,
	cc1.lastname AS defattlastname,
	cc1.firstname AS defattfirstname,
	cc1.company AS defattcompany,
	cc1.address1 AS defattadd1,
	cc1.address2 AS defattadd2,
	cc1.city AS defattcity,
	cc1.state AS defattstate,
	cc1.zip AS defattzip,
	cc1.phone AS defattphone,
	cc1.phoneextension AS defattphonext,
	cc1.fax AS defattfax,
	cc1.email AS defattemail,
	cc1.prefix AS defattprefix,

	--plaintiff attorney
	cc2.lastname AS plaintattlastname,
	cc2.firstname AS plaintattfirstname,
	cc2.company AS plaintattcompany,
	cc2.address1 AS plaintattadd1,
	cc2.address2 AS plaintattadd2,
	cc2.city AS plaintattcity,
	cc2.state AS plaintattstate,
	cc2.zip AS plaintattzip,
	cc2.phone AS plaintattphone,
	cc2.phoneextension AS plaintattphonext,
	cc2.fax AS plaintattfax,
	cc2.email AS plaintattemail,
	cc2.prefix AS plaintattprefix

FROM tblCase
	INNER JOIN vwtblExaminee AS tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
	LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
	LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
	LEFT OUTER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
	LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode
	LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
    LEFT OUTER JOIN tblEmployer on tblcase.EmployerID = tblEmployer.EmployerID 
    LEFT OUTER JOIN tblEmployerAddress on tblcase.EmployerAddressID = tblEmployerAddress.EmployerAddressID 
