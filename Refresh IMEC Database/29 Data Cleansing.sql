Print 'tblAuditLog' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
TRUNCATE TABLE tblAuditLog;
GO
Print 'tblCaseHistory' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
TRUNCATE TABLE tblCaseHistory;
GO
Print 'tblLogUsage' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
TRUNCATE TABLE tblLogUsage;
GO
Print 'tblRelatedParty' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
TRUNCATE TABLE tblRelatedParty;
GO
Print 'tblRptMEINotification' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
TRUNCATE TABLE tblRptMEINotification;
GO
Print 'tblSession' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
TRUNCATE TABLE tblSession;
GO
Print 'tblTempData' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
TRUNCATE TABLE tblTempData;
GO
Print 'tblUserActivity' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
TRUNCATE TABLE tblUserActivity;
GO
Print 'tblWebReferral' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
TRUNCATE TABLE tblWebReferral;
GO
Print 'tblAcctHeader' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblAcctHeader SET  Examinee=IIF(Examinee IS NULL, NULL,  'Subject A'), ClaimNbr=IIF(ClaimNbr IS NULL, NULL,  '1234567890');
GO
Print 'tblAcctQuote' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblAcctQuote SET  Note=IIF(Note IS NULL, NULL,  'This is a Quote Note');
GO
Print 'tblCase' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblCase SET  CourtIndexNbr=IIF(CourtIndexNbr IS NULL, NULL,  '12345'), ScheduleNotes=IIF(ScheduleNotes IS NULL, NULL,  'This is a Schedule Notes'), SpecialInstructions=IIF(SpecialInstructions IS NULL, NULL,  'This is a Special Instructions'), Notes=IIF(Notes IS NULL, NULL,  'This is a Notes'), CaseCaption=IIF(CaseCaption IS NULL, NULL,  'A vs. B'), CertMailNbr=IIF(CertMailNbr IS NULL, NULL,  '1234567890123456789012'), AddlClaimNbrs=IIF(AddlClaimNbrs IS NULL, NULL,  '22222,33333'), AttorneyNote=IIF(AttorneyNote IS NULL, NULL,  'This is a Attorney Note'), BillingNote=IIF(BillingNote IS NULL, NULL,  'This is a Billing Note'), sInternalCaseNbr=IIF(sInternalCaseNbr IS NULL, NULL,  ''), Recommendation=IIF(Recommendation IS NULL, NULL,  'This is a Recommendation'), Allegation=IIF(Allegation IS NULL, NULL,  'This is a Allegation'), LitigationNotes=IIF(LitigationNotes IS NULL, NULL,  'This is a Litigation Notes'), CertMailNbr2=IIF(CertMailNbr2 IS NULL, NULL,  '2345678901234567890123'), ExpertComments=IIF(ExpertComments IS NULL, NULL,  'This is an Expert Comments');
GO
Print 'tblCaseContactRequest' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblCaseContactRequest SET  Phone=IIF(Phone IS NULL, NULL,  '(111) 222-3333'), Message=IIF(Message IS NULL, NULL,  'This is a contact message');
GO
Print 'tblCaseDocuments' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblCaseDocuments SET  Description=IIF(Description IS NULL, NULL,  'Sample File'), sFileName=IIF(sFileName IS NULL, NULL,  'SampleFile.txt');
GO
Print 'tblCaseDocumentsDicom' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblCaseDocumentsDicom SET  InstitutionName=IIF(InstitutionName IS NULL, NULL,  'ABC Facility'), PatientID=IIF(PatientID IS NULL, NULL,  '123456'), PatientName=IIF(PatientName IS NULL, NULL,  'Subject 1'), PatientBirthDate=IIF(PatientBirthDate IS NULL, NULL,  '01/02/1960');
GO
Print 'tblCaseNF10' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblCaseNF10 SET  ExamineeName=IIF(ExamineeName IS NULL, NULL,  'Subject 1'), ExamineeAddress=IIF(ExamineeAddress IS NULL, NULL,  'City, State Zip');
GO
Print 'tblCasePeerBill' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblCasePeerBill SET  BillNumber=IIF(BillNumber IS NULL, NULL,  '1122334455'), ProviderTIN=IIF(ProviderTIN IS NULL, NULL,  '2345678901'), ReferringProviderName=IIF(ReferringProviderName IS NULL, NULL,  'Provider1'), ProviderName=IIF(ProviderName IS NULL, NULL,  'Provider2'), ReferringProviderTIN=IIF(ReferringProviderTIN IS NULL, NULL,  '1234567890');
GO
Print 'tblCaseReviewItem' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblCaseReviewItem SET  Fax=IIF(Fax IS NULL, NULL,  '(123) 456-7890'), Phone=IIF(Phone IS NULL, NULL,  '(123) 456-7890'), Email=IIF(Email IS NULL, NULL,  'ewistest@examworks.com');
GO
Print 'tblCCAddress' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblCCAddress SET  Address1=IIF(Address1 IS NULL, NULL,  '123 Main St.'), Email=IIF(Email IS NULL, NULL,  'ewistest@examworks.com'), Phone=IIF(Phone IS NULL, NULL,  '(123) 456-7890'), Company=IIF(Company IS NULL, NULL,  'Smith, Smith, & Smith, PC.'), LastName=IIF(LastName IS NULL, NULL,  'Smith'), FirstName=IIF(FirstName IS NULL, NULL,  'John'), Fax=IIF(Fax IS NULL, NULL,  '(123) 456-7890');
GO
Print 'tblClient' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblClient SET  ProcessorEmail=IIF(ProcessorEmail IS NULL, NULL,  'ewistest@examworks.com'), ProcessorPhone=IIF(ProcessorPhone IS NULL, NULL,  '(123) 456-7890'), Email=IIF(Email IS NULL, NULL,  'ewistest@examworks.com'), ProcessorFax=IIF(ProcessorFax IS NULL, NULL,  '(123) 456-7890'), Notes=IIF(Notes IS NULL, NULL,  'These are Client Notes'), Fax=IIF(Fax IS NULL, NULL,  '(123) 456-7890'), Phone2=IIF(Phone2 IS NULL, NULL,  '(123) 456-7890'), HCAIInsurerID=IIF(HCAIInsurerID IS NULL, NULL,  ''), BillFax=IIF(BillFax IS NULL, NULL,  '(123) 456-7890'), Phone1=IIF(Phone1 IS NULL, NULL,  '(123) 456-7890'), DistributionNotes=IIF(DistributionNotes IS NULL, NULL,  'These are DistributionNotes'), SpecialReqNotes=IIF(SpecialReqNotes IS NULL, NULL,  'These are SpecialReqNotes'), HCAIBranchID=IIF(HCAIBranchID IS NULL, NULL,  '');
GO
Print 'tblCompany' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblCompany SET  Notes=IIF(Notes IS NULL, NULL,  'These are Company Notes'), SpecialReqNotes=IIF(SpecialReqNotes IS NULL, NULL,  'These are SpecialReqNotes'), Phone=IIF(Phone IS NULL, NULL,  '(123) 456-7890'), DistributionNotes=IIF(DistributionNotes IS NULL, NULL,  'These are DistributionNotes');
GO
Print 'tblConfirmationList' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblConfirmationList SET  Phone=IIF(Phone IS NULL, NULL,  '(123) 456-7890');
GO
Print 'tblDoctor' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblDoctor SET  Notes=IIF(Notes IS NULL, NULL,  'These are doctor notes'), Phone=IIF(Phone IS NULL, NULL,  '(123) 456-7890'), Cellphone=IIF(Cellphone IS NULL, NULL,  '(123) 456-7890'), FaxNbr=IIF(FaxNbr IS NULL, NULL,  '(123) 456-7890'), EmailAddr=IIF(EmailAddr IS NULL, NULL,  'ewistest@examworks.com'), Pager=IIF(Pager IS NULL, NULL,  '(123) 456-7890');
GO
Print 'tblDoctorCheckRequest' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblDoctorCheckRequest SET  Comment=IIF(Comment IS NULL, NULL,  'Check request comments');
GO
Print 'tblDPSBundleCaseDocument' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblDPSBundleCaseDocument SET  filename=IIF(filename IS NULL, NULL,  'MedRecFileName.pdf');
GO
Print 'tblDPSNote' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblDPSNote SET  Notes=IIF(Notes IS NULL, NULL,  'These are bundle notes');
GO
Print 'tblEmployerAddress' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblEmployerAddress SET  Fax=IIF(Fax IS NULL, NULL,  '(123) 456-7890'), Phone=IIF(Phone IS NULL, NULL,  '(123) 456-7890'), Email=IIF(Email IS NULL, NULL,  'ewistest@examworks.com');
GO
Print 'tblExaminee' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblExaminee SET  TreatingPhysicianFax=IIF(TreatingPhysicianFax IS NULL, NULL,  '(123) 456-7890'), SSN=IIF(SSN IS NULL, NULL,  '123-45-6789'), InsuredPhone=IIF(InsuredPhone IS NULL, NULL,  '(123) 456-7890'), PolicyNumber=IIF(PolicyNumber IS NULL, NULL,  '554433'), InsuredFax=IIF(InsuredFax IS NULL, NULL,  '(123) 456-7890'), Phone1=IIF(Phone1 IS NULL, NULL,  '(123) 456-7890'), TreatingPhysicianPhone=IIF(TreatingPhysicianPhone IS NULL, NULL,  '(123) 456-7890'), WorkPhone=IIF(WorkPhone IS NULL, NULL,  '(123) 456-7890'), Addr1=IIF(Addr1 IS NULL, NULL,  '55 Center St.'), InsuredAddr1=IIF(InsuredAddr1 IS NULL, NULL,  '3322 Washington Ave.'), TreatingPhysicianEmail=IIF(TreatingPhysicianEmail IS NULL, NULL,  'ewistest@examworks.com'), Phone2=IIF(Phone2 IS NULL, NULL,  '(123) 456-7890'), InsuredEmail=IIF(InsuredEmail IS NULL, NULL,  'ewistest@examworks.com'), EmployerPhone=IIF(EmployerPhone IS NULL, NULL,  '(123) 456-7890'), EmployerEmail=IIF(EmployerEmail IS NULL, NULL,  'ewistest@examworks.com'), MobilePhone=IIF(MobilePhone IS NULL, NULL,  '(123) 456-7890'), EmployerFax=IIF(EmployerFax IS NULL, NULL,  '(123) 456-7890'), Note=IIF(Note IS NULL, NULL,  'These are Examinee Notes'), Insured=IIF(Insured IS NULL, NULL,  'Insured Party Name');
GO
Print 'tblExamineeAddresses' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblExamineeAddresses SET  Addr1=IIF(Addr1 IS NULL, NULL,  '622 First St.');
GO
Print 'tblExternalCommunications' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblExternalCommunications SET  ClaimNbr=IIF(ClaimNbr IS NULL, NULL,  '123456789');
GO
Print 'tblFacility' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblFacility SET  Email=IIF(Email IS NULL, NULL,  'ewistest@examworks.com'), Fax=IIF(Fax IS NULL, NULL,  '(123) 456-7890'), Phone=IIF(Phone IS NULL, NULL,  '(123) 456-7890');
GO
Print 'tblLocation' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblLocation SET  Phone=IIF(Phone IS NULL, NULL,  '(123) 456-7890'), Email=IIF(Email IS NULL, NULL,  'ewistest@examworks.com'), Fax=IIF(Fax IS NULL, NULL,  '(123) 456-7890');
GO
Print 'tblRecordsObtainment' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblRecordsObtainment SET  ExtNotes=IIF(ExtNotes IS NULL, NULL,  'These are External Notes'), IntNotes=IIF(IntNotes IS NULL, NULL,  'These are Internal Notes');
GO
Print 'tblTreatingDoctor' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblTreatingDoctor SET  Fax=IIF(Fax IS NULL, NULL,  '(123) 456-7890'), Phone=IIF(Phone IS NULL, NULL,  '(123) 456-7890'), Email=IIF(Email IS NULL, NULL,  'ewistest@examworks.com');
GO
Print 'tblClient' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblClient SET  FldSupervisor=0;
GO
Print 'tblAcctDetail' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblAcctDetail SET  LongDesc=IIF(patindex('%Examinee:%', LongDesc)=0, LongDesc,
substring(
	left(LongDesc, patindex('%Examinee:%', LongDesc)-1) 
    + 'Examinee: ' + 'Subject A'
	+ ' '
    + 'Claim#: ' + '1234567890'
	,1, 1000))
;
GO
Print 'tblCase' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblCase SET  DateOfInjury=dateadd(day,abs(checksum(newid())) % ( 1 + datediff(day,dateadd(year, -10, getdate()),dateadd(month, -1, getdate()))),dateadd(year, -10, getdate())), ClaimNbr=convert(varchar(4), (cast(rand(checksum(newid())) * 8998 as int) + 1000)) + '-' + convert(varchar(4), (cast(rand(checksum(newid())) * 8998 as int) + 1000));
GO
Print 'tblDoctorSchedule' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblDoctorSchedule SET  CaseNbr5Desc=case 
				when patindex('%\%', CaseNbr5Desc) > 0 then substring('Examinee Name' + substring(CaseNbr5Desc, patindex('%\%', CaseNbr5Desc), len(CaseNbr5Desc)), 1, 70)
				when patindex('%/%', CaseNbr5Desc) > 0 then substring('Examinee Name' + substring(CaseNbr5Desc, patindex('%/%', CaseNbr5Desc), len(CaseNbr5Desc)), 1, 70)
				else CaseNbr5Desc
				end, CaseNbr4Desc=case 
				when patindex('%\%', CaseNbr4Desc) > 0 then substring('Examinee Name' + substring(CaseNbr4Desc, patindex('%\%', CaseNbr4Desc), len(CaseNbr4Desc)), 1, 70)
				when patindex('%/%', CaseNbr4Desc) > 0 then substring('Examinee Name' + substring(CaseNbr4Desc, patindex('%/%', CaseNbr4Desc), len(CaseNbr4Desc)), 1, 70)
				else CaseNbr4Desc
				end, CaseNbr3Desc=case 
				when patindex('%\%', CaseNbr3Desc) > 0 then substring('Examinee Name' + substring(CaseNbr3Desc, patindex('%\%', CaseNbr3Desc), len(CaseNbr3Desc)), 1, 70)
				when patindex('%/%', CaseNbr3Desc) > 0 then substring('Examinee Name' + substring(CaseNbr3Desc, patindex('%/%', CaseNbr3Desc), len(CaseNbr3Desc)), 1, 70)
				else CaseNbr3Desc
				end, CaseNbr1Desc=case 
				when patindex('%\%', CaseNbr1Desc) > 0 then substring('Examinee Name' + substring(CaseNbr1Desc, patindex('%\%', CaseNbr1Desc), len(CaseNbr1Desc)), 1, 70)
				when patindex('%/%', CaseNbr1Desc) > 0 then substring('Examinee Name' + substring(CaseNbr1Desc, patindex('%/%', CaseNbr1Desc), len(CaseNbr1Desc)), 1, 70)
				else CaseNbr1Desc
				end, CaseNbr6Desc=case 
				when patindex('%\%', CaseNbr6Desc) > 0 then substring('Examinee Name' + substring(CaseNbr6Desc, patindex('%\%', CaseNbr6Desc), len(CaseNbr6Desc)), 1, 70)
				when patindex('%/%', CaseNbr6Desc) > 0 then substring('Examinee Name' + substring(CaseNbr6Desc, patindex('%/%', CaseNbr6Desc), len(CaseNbr6Desc)), 1, 70)
				else CaseNbr6Desc
				end, CaseNbr2Desc=case 
				when patindex('%\%', CaseNbr2Desc) > 0 then substring('Examinee Name' + substring(CaseNbr2Desc, patindex('%\%', CaseNbr2Desc), len(CaseNbr2Desc)), 1, 70)
				when patindex('%/%', CaseNbr2Desc) > 0 then substring('Examinee Name' + substring(CaseNbr2Desc, patindex('%/%', CaseNbr2Desc), len(CaseNbr2Desc)), 1, 70)
				else CaseNbr2Desc
				end;
GO
Print 'tblExaminee' + ' - ' + CAST(GETDATE() AS VARCHAR);
GO
UPDATE tblExaminee SET  LastName=(SELECT LastName FROM IMECentricMaster.dbo.DCName WHERE PrimaryKey = (ChartNbr % 5000)), DOB=dateadd(day,abs(checksum(newid())) % ( 1 + datediff(day,'1950-01-01',dateadd(year, -10, getdate()))),'1950-01-01'), FirstName=(SELECT FirstName FROM IMECentricMaster.dbo.DCName WHERE PrimaryKey = (ChartNbr % 5000)), MiddleInitial=(SELECT MiddleInitial FROM IMECentricMaster.dbo.DCName WHERE PrimaryKey = (ChartNbr % 5000));
GO