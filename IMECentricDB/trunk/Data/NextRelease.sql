
--// add new data fields values for IMEC-11200 (Create TAT fields and setup calculations in IMEC)
insert into tblDataField (DataFieldID, TableName, FieldName, Descrip) values
(117, 'tblCase', 'TATDateLossToApptDate', '')
,(118, 'tblCase', 'TATInitialApptDateToApptDate', '')
,(119, 'tblCase', 'TATDateReceivedToInitialApptDate', '')
,(212, 'tblCase', 'DateOfInjury', 'Date of Loss')
,(213, 'tblCase', 'OrigApptTime', 'Initial Appt Date')
;


--// inserting new calc method details for IMEC-11200 (Create TAT fields and setup calculations in IMEC)
insert into tblTATCalculationMethod (TATCalculationMethodID, StartDateFieldID, EndDateFieldID, Unit, TATDataFieldID, UseTrend)
select 
	17,
	212,
	208, 
	'Day', 
	117, 
	0
union all
select 
	18,
	213, 
	208, 
	'Day', 
	118, 
	0
union all
select 
	19,
	201, 
	213, 
	'Day', 
	119, 
	0
;

--// insert new calc group details for IMEC-11200 (Create TAT fields and setup calculations in IMEC)
insert into tblTATCalculationGroupDetail (TATCalculationGroupID, TATCalculationMethodID, DisplayOrder) values
	(1, 17, 13)
	,(1, 18, 14)
	,(1, 19, 15)

	,(2, 17, 13)
	,(2, 18, 14)
	,(2, 19, 15)
	
	,(3, 17, 13)
	,(3, 18, 14)
	,(3, 19, 15)
	
	,(4, 17, 13)
	,(4, 18, 14)
	,(4, 19, 15)
;

--// insert some new values into tblCodes IMEC-11210
insert into tblCodes values ('WALI CAC', 'ServiceCode', 170)
insert into tblCodes values ('WALI CAC', 'ServiceCode', 180)
insert into tblCodes values ('WALI CAC', 'ServiceCode', 190)
insert into tblCodes values ('WALI CAC', 'ServiceCode', 200)
insert into tblCodes values ('WALI CAC', 'ServiceCode', 210)



-- Insert security tokens for Issue 11186 (sub issues of 11168).  Used for DICOM Storage retention rules 
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded) Values('StorRetRuleSet', 'Storage Retention Rule - Set', getdate())
GO
INSERT INTO tblGroupFunction VALUES ('8-CorpAdmin', 'StorRetRuleSet')
GO



