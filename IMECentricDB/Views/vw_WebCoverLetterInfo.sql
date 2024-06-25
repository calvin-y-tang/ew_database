CREATE VIEW vw_WebCoverLetterInfo

AS

SELECT
	--case
	tblCase.casenbr AS Casenbr,
	tblCase.chartnbr AS Chartnbr,
	tblCase.doctorlocation AS Doctorlocation,
	tblCase.clientcode AS clientcode,
	tblCase.Appttime AS Appttime,
	tblCase.dateofinjury AS DOI,
	tblCase.dateofinjury AS DOI2,
	tblCase.dateofinjury2 AS DOISecond,
	tblCase.dateofinjury3 AS DOIThird,
	tblCase.dateofinjury4 AS DOIFourth,
	tblCase.notes AS Casenotes,
	tblCase.DoctorName AS doctorformalname,
	tblCase.ClaimNbrExt AS ClaimNbrExt,
	tblCase.Jurisdiction AS Jurisdiction,
	tblCase.ApptDate AS Apptdate,
	tblCase.claimnbr AS claimnbr,
	tblCase.doctorspecialty AS Specialtydesc,

	--examinee
	tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename,
	tblExaminee.addr1 AS examineeaddr1,
	tblExaminee.addr2 AS examineeaddr2,
	tblExaminee.city AS ExamineeCity,
	tblExaminee.state AS ExamineeState,
	tblExaminee.zip AS ExamineeZip,
	tblExaminee.phone1 AS examineephone,
	tblExaminee.SSN AS ExamineeSSN,
	tblExaminee.sex AS ExamineeSex,
	tblExaminee.DOB AS ExamineeDOB,
	tblExaminee.insured AS insured,

	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.Employer  
		ELSE tblEmployer.Name  
		END) AS Employer,  

	tblExaminee.treatingphysician AS TreatingPhysician,

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerAddr1  
		ELSE tblEmployerAddress.Address1 
		END) AS EmployerAddr1,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerCity  
		ELSE tblEmployerAddress.City  
		END) AS EmployerCity,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerState  
		ELSE tblEmployerAddress.State  
		END) AS EmployerState,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerZip  
		ELSE tblEmployerAddress.Zip  
		END) AS EmployerZip,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerPhone  
		ELSE tblEmployerAddress.Phone  
		END) AS EmployerPhone,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerFax  
		ELSE tblEmployerAddress.Fax  
		END) AS EmployerFax,  
            
	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerEmail  
		ELSE tblEmployerAddress.Email  
		END) AS EmployerEmail,  

	--case type
	tblCaseType.description AS Casetype,

	--service
	tblServices.description AS servicedesc,

	--client
	tblClient.firstname + ' ' + tblClient.lastname AS clientname,
	tblClient.firstname + ' ' + tblClient.lastname AS clientname2,
	tblClient.phone1 AS clientphone,
	tblClient.fax AS Clientfax,

	--company
	tblCompany.intname company,

	--defense attorney
	cc1.firstname + ' ' + cc1.lastname AS dattorneyname,
	cc1.company AS dattorneycompany,
	cc1.address1 AS dattorneyaddr1,
	cc1.address2 AS dattorneyaddr2,
	cc1.phone AS dattorneyphone,
	cc1.fax AS dattorneyfax,
	cc1.email AS dattorneyemail,

	--plaintiff attorney
	cc2.firstname + ' ' + cc2.lastname AS pattorneyname,
	cc2.company AS pattorneycompany,
	cc2.address1 AS pattorneyaddr1,
	cc2.address2 AS pattorneyaddr2,
	cc2.phone AS pattorneyphone,
	cc2.fax AS pattorneyfax,
	cc2.email AS pattorneyemail,

	--doctor
	'Dr. ' + tblDoctor.firstname + ' ' + tblDoctor.lastname AS doctorsalutation,

	--problems
	tblProblem.description AS Problems

FROM  tblCase
	INNER JOIN vwtblExaminee AS tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
	LEFT OUTER JOIN	tblCaseType ON tblCase.casetype = tblCaseType.code
	LEFT OUTER JOIN	tblServices ON tblCase.servicecode = tblServices.servicecode
	LEFT OUTER JOIN	tblOffice ON tblCase.officecode = tblOffice.officecode
	LEFT OUTER JOIN	tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode
	LEFT OUTER JOIN	tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
	LEFT OUTER JOIN	tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
	LEFT OUTER JOIN	tblCaseProblem ON tblCase.casenbr = tblCaseProblem.casenbr
	LEFT OUTER JOIN	tblProblem ON tblCaseProblem.problemcode = tblProblem.problemcode
    LEFT OUTER JOIN tblEmployer on tblcase.EmployerID = tblEmployer.EmployerID 
    LEFT OUTER JOIN tblEmployerAddress on tblcase.EmployerAddressID = tblEmployerAddress.EmployerAddressID 
