use [VAR_DBINSTANCE];

if object_id('VAR_DBINSTANCE.dbo.DCTableFieldAction') is null
begin

create table DCTableFieldAction (
	id uniqueidentifier primary key not null default(newid()),
	tablename varchar(500) not null,
    colname varchar(200) null,
	keycolname varchar(200) null,
	clean bit default(0),
    cleartable bit default(0),
    seq int default(0),
	replacevalue varchar(500),
	actionid int
);

end


if object_id('VAR_DBINSTANCE.dbo.DCAction') is null
begin

create table DCAction (
	actionid int primary key not null,
	actionname varchar(500) not null,
    code varchar(max),
    scriptfilename varchar(200)	
);

end







--// action scripts
insert into DCAction (actionid, actionname, scriptfilename) values
 (1, 'Direct Text Replace', 'code_directtext') 
,(2, 'Direct Integer Replace', 'code_directinteger') 
,(3, 'Direct Bit Replace', 'code_directbit') 
,(4, 'Email Partial', 'code_email_partial') 
,(5, 'Email Generate', 'code_email_generate') 
,(6, 'Phone (Formatted) Generate', 'code_phoneformatted') 
,(7, 'SSN Generate', 'code_ssn_generate') 
,(8, 'SSN PartialMask', 'code_ssn_partialmask') 
,(9, '16 AlphNumeric Generate', 'code_16alphanum') 
,(10, 'Pool Relative Text Replace', 'code_pooltext')
,(11, 'FSlash Left Replace', 'code_fslashleft') 
,(12, 'Special AcctDetail', 'code_spec_acctdetail') 
,(13, 'Special CaseNoteFields', 'code_spec_casenotefields') 
,(14, 'Special CaseDocumentFields', 'code_spec_casedocumentfields') 
,(15, 'ClaimNbr Generate', 'code_claimnbr_generate') 
,(16, 'Date Injury Generate', 'code_dateinjury_generate')  
,(17, 'Date Birth Generate', 'code_datebirth_generate') 
;



insert into DCTableFieldAction (tablename, keycolname, colname, replacevalue, actionid) values
('ctFSAllState', null, null, null, null)
,('ctFSAllStateBase', null, null, null, null)
,('dht_tblClient', 'ClientCode', null, null, null)
,('dht_tblWebUser', null, null, null, null)
,('tblAcctDetail', 'DetailID', 'LongDesc', 'Subject A, 1234567890', 12) ---- issue wwhere the text is larger than the allocated slot
,('tblAcctHeader', 'HeaderID', 'ClaimNbr', '1234567890', 1)
,('tblAcctHeader', 'HeaderID', 'Examinee', 'Subject A', 1)
,('tblAcctQuote', 'AcctQuoteID', 'Note', 'This is a Quote Note', 1)
,('tblCase', 'CaseNbr', 'ClaimNbr', null, 15)
,('tblCase', 'CaseNbr', 'DateOfInjury', null, 16)
,('tblCase', 'CaseNbr', 'sInternalCaseNbr', '', 1)
,('tblCase', 'CaseNbr', 'CertMailNbr', '1234567890123456789012', 1)
,('tblCase', 'CaseNbr', 'CertMailNbr2', '2345678901234567890123', 1)
,('tblCase', 'CaseNbr', 'CourtIndexNbr', '12345', 1)
,('tblCase', 'CaseNbr', 'CaseCaption', 'A vs. B', 1)
,('tblCase', 'CaseNbr', 'AddlClaimNbrs', '22222,33333', 1)
,('tblCase', 'CaseNbr', null, null, 13)
,('tblCaseContactRequest', 'CaseContactReqID', 'Phone', '(111) 222-3333', 1)
,('tblCaseContactRequest', 'CaseContactReqID', 'Message', 'This is a contact message', 1)
,('tblCaseDocuments', 'SeqNo', null, null, 14)
,('tblCaseDocumentsDicom', 'CaseDocDicomID', 'PatientName', 'Subject 1', 1)
,('tblCaseDocumentsDicom', 'CaseDocDicomID', 'PatientID', '123456', 1)
,('tblCaseDocumentsDicom', 'CaseDocDicomID', 'PatientBirthDate', '01/02/1960', 1)
,('tblCaseDocumentsDicom', 'CaseDocDicomID', 'InstitutionName', 'ABC Facility', 1)
,('tblCaseHistory', null, null, null, null)
,('tblCaseNF10', 'CaseNbr', 'ExamineeName', 'Subject 1', 1)
,('tblCaseNF10', 'CaseNbr', 'ExamineeAddress', 'City, State Zip', 1)
,('tblCasePeerBill', 'PeerBillID', 'ReferringProviderName', 'Provider1', 1)
,('tblCasePeerBill', 'PeerBillID', 'ReferringProviderTIN', '1234567890', 1)
,('tblCasePeerBill', 'PeerBillID', 'ProviderName', 'Provider2', 1)
,('tblCasePeerBill', 'PeerBillID', 'ProviderTIN', '2345678901', 1)
,('tblCasePeerBill', 'PeerBillID', 'BillNumber', '1122334455', 1)
,('tblCaseReviewItem', 'CaseReviewItemID', 'Phone', '(123) 456-7890', 1)
,('tblCaseReviewItem', 'CaseReviewItemID', 'Fax', '(123) 456-7890', 1)
,('tblCaseReviewItem', 'CaseReviewItemID', 'Email', 'ewistest@examworks.com', 1)
,('tblCCAddress', 'ccCode', 'LastName', 'Smith', 1)
,('tblCCAddress', 'ccCode', 'FirstName', 'John', 1)
,('tblCCAddress', 'ccCode', 'Company', 'Smith, Smith, & Smith, PC.', 1)
,('tblCCAddress', 'ccCode', 'Address1', '123 Main St.', 1)
,('tblCCAddress', 'ccCode', 'Phone', '(123) 456-7890', 1)
,('tblCCAddress', 'ccCode', 'Fax', '(123) 456-7890', 1)
,('tblCCAddress', 'ccCode', 'Email', 'ewistest@examworks.com', 1)
,('tblClient', 'ClientCode', 'Phone1', '(123) 456-7890', 1)
,('tblClient', 'ClientCode', 'Phone2', '(123) 456-7890', 1)
,('tblClient', 'ClientCode', 'Fax', '(123) 456-7890', 1)
,('tblClient', 'ClientCode', 'Email', 'ewistest@examworks.com', 1)
,('tblClient', 'ClientCode', 'Notes', 'These are Client Notes', 1)
,('tblClient', 'ClientCode', 'BillFax', '(123) 456-7890', 1)
,('tblClient', 'ClientCode', 'ProcessorPhone', '(123) 456-7890', 1)
,('tblClient', 'ClientCode', 'ProcessorFax', '(123) 456-7890', 1)
,('tblClient', 'ClientCode', 'ProcessorEmail', 'ewistest@examworks.com', 1)
,('tblClient', 'ClientCode', 'FldSupervisor', '0', 3)
,('tblClient', 'ClientCode', 'HCAIInsurerID', '', 1)
,('tblClient', 'ClientCode', 'HCAIBranchID', '', 1)
,('tblClient', 'ClientCode', 'SpecialReqNotes', 'These are SpecialReqNotes', 1)
,('tblClient', 'ClientCode', 'DistributionNotes', 'These are DistributionNotes', 1)
,('tblCompany', 'CompanyCode', 'Phone', '(123) 456-7890', 1)
,('tblCompany', 'CompanyCode', 'Notes', 'These are Company Notes', 1)
,('tblCompany', 'CompanyCode', 'SpecialReqNotes', 'These are SpecialReqNotes', 1)
,('tblCompany', 'CompanyCode', 'DistributionNotes', 'These are DistributionNotes', 1)
,('tblConfirmationList', 'ConfirmationListID', 'Phone', '(123) 456-7890', 1)
,('tblDoctor', 'DoctorCode', 'Notes', 'These are doctor notes', 1)
,('tblDoctor', 'DoctorCode', 'Phone', '(123) 456-7890', 1)
,('tblDoctor', 'DoctorCode', 'Cellphone', '(123) 456-7890', 1)
,('tblDoctor', 'DoctorCode', 'Pager', '(123) 456-7890', 1)
,('tblDoctor', 'DoctorCode', 'FaxNbr', '(123) 456-7890', 1)
,('tblDoctor', 'DoctorCode', 'EmailAddr', 'ewistest@examworks.com', 1)
,('tblDoctorCheckRequest', 'CheckRequestID', 'Comment', 'Check request comments', 1)
,('tblDoctorSchedule', 'SchedCode', 'CaseNbr1Desc', 'Examinee Name', 11) 
,('tblDoctorSchedule', 'SchedCode', 'CaseNbr2Desc', 'Examinee Name', 11)
,('tblDoctorSchedule', 'SchedCode', 'CaseNbr3Desc', 'Examinee Name', 11)
,('tblDoctorSchedule', 'SchedCode', 'CaseNbr4Desc', 'Examinee Name', 11)
,('tblDoctorSchedule', 'SchedCode', 'CaseNbr5Desc', 'Examinee Name', 11)
,('tblDoctorSchedule', 'SchedCode', 'CaseNbr6Desc', 'Examinee Name', 11)
,('tblDPSBundleCaseDocument', 'DPSBundleID', 'filename', 'MedRecFileName.pdf', 1)
,('tblDPSNote', 'DPSNoteID', 'Notes', 'These are bundle notes', 1)
,('tblEmployerAddress', 'EmployerAddressID', 'Phone', '(123) 456-7890', 1)
,('tblEmployerAddress', 'EmployerAddressID', 'Fax', '(123) 456-7890', 1)
,('tblEmployerAddress', 'EmployerAddressID', 'Email', 'ewistest@examworks.com', 1)
,('tblExaminee', 'ChartNbr', 'LastName', null, 10)
,('tblExaminee', 'ChartNbr', 'FirstName', null, 10)
,('tblExaminee', 'ChartNbr', 'Addr1', '55 Center St.', 1)
,('tblExaminee', 'ChartNbr', 'Phone1', '(123) 456-7890', 1)
,('tblExaminee', 'ChartNbr', 'Phone2', '(123) 456-7890', 1)
,('tblExaminee', 'ChartNbr', 'SSN', 'ABCXXXXXXXXX', 1)
,('tblExaminee', 'ChartNbr', 'DOB', null, 17)
,('tblExaminee', 'ChartNbr', 'Note', 'These are Examinee Notes', 1)
,('tblExaminee', 'ChartNbr', 'Insured', 'Insured Party Name', 1)
,('tblExaminee', 'ChartNbr', 'InsuredAddr1', '3322 Washington Ave.', 1)
,('tblExaminee', 'ChartNbr', 'InsuredPhone', '(123) 456-7890', 1)
,('tblExaminee', 'ChartNbr', 'InsuredFax', '(123) 456-7890', 1)
,('tblExaminee', 'ChartNbr', 'InsuredEmail', 'ewistest@examworks.com', 1)
,('tblExaminee', 'ChartNbr', 'TreatingPhysicianPhone', '(123) 456-7890', 1)
,('tblExaminee', 'ChartNbr', 'TreatingPhysicianFax', '(123) 456-7890', 1)
,('tblExaminee', 'ChartNbr', 'TreatingPhysicianEmail', 'ewistest@examworks.com', 1)
,('tblExaminee', 'ChartNbr', 'EmployerPhone', '(123) 456-7890', 1)
,('tblExaminee', 'ChartNbr', 'EmployerFax', '(123) 456-7890', 1)
,('tblExaminee', 'ChartNbr', 'EmployerEmail', 'ewistest@examworks.com', 1)
,('tblExaminee', 'ChartNbr', 'PolicyNumber', '554433', 1)
,('tblExaminee', 'ChartNbr', 'MobilePhone', '(123) 456-7890', 1)
,('tblExaminee', 'ChartNbr', 'WorkPhone', '(123) 456-7890', 1)
,('tblExamineeAddresses', 'ExamineeAddressID', 'Addr1', '622 First St.', 1)
,('tblExternalCommunications', 'CommunicationID', 'ClaimNbr', '123456789', 1)
,('tblFacility', 'FacilityID', 'Phone', '(123) 456-7890', 1)
,('tblFacility', 'FacilityID', 'Fax', '(123) 456-7890', 1)
,('tblFacility', 'FacilityID', 'Email', 'ewistest@examworks.com', 1)
,('tblLocation', 'LocationCode', 'Phone', '(123) 456-7890', 1)
,('tblLocation', 'LocationCode', 'Fax', '(123) 456-7890', 1)
,('tblLocation', 'LocationCode', 'Email', 'ewistest@examworks.com', 1)
,('tblLogUsage', null, null, null, null)
,('tblRecordsObtainment', 'RecordsID', 'ExtNotes', 'These are External Notes', 1)
,('tblRecordsObtainment', 'RecordsID', 'IntNotes', 'These are Internal Notes', 1)
,('tblRelatedParty', null, null, null, null)
,('tblRptMEINotification', null, null, null, null)
,('tblTreatingDoctor', 'TreatingDoctorID', 'Phone', '(123) 456-7890', 1)
,('tblTreatingDoctor', 'TreatingDoctorID','Fax', '(123) 456-7890', 1)
,('tblTreatingDoctor', 'TreatingDoctorID','Email', 'ewistest@examworks.com', 1)
,('tblWebReferral', null, null, null, null)
,('tmpWestfield', null, null, null, null)
,('tblBrickstreetReferral', null, null, null, null)
,('tblDupeExaminee', null, null, null, null)
;


--// update the list of tables to be cleared  / truncated / reseeded
update DCTableFieldAction set cleartable = 1 where tablename in (
	'ctFSAllState',
	'ctFSAllStateBase',
	'dht_tblClient',
	'dht_tblWebUser',
	'tblCaseHistory',
	'tblLogUsage',
	'tblRelatedParty',
	'tblRptMEINotification',
	'tblWebReferral',
	'tmpWestfield',
	'tblBrickstreetReferral',
	'tblDupeExaminee'
);

--// set all of the entries to be cleaned
update DCTableFieldAction set clean = 1;


--// add in the order / sequence based on table name and colname
with
x as (
	select id, tablename, colname, ROW_NUMBER() over (order by tablename, colname) as rn from DCTableFieldAction
)
update DCTableFieldAction set Seq = x.rn
from DCTableFieldAction y join x on y.id = x.id;