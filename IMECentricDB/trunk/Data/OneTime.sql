
--// 11281 - adding new records into the tblMessageToken table
insert into tblMessageToken (Name, Description)
values ('@ThirdPartyBillingCompany@',''), ('@ThirdPartyBillingClient@','')
;


-- Issue 11454 - add company email to GP feed
  ALTER TABLE IMECentricMaster.dbo.GPCompany ADD AcctingEmail varchar(70) NULL
  ALTER TABLE EWDataRepository.dbo.Company ADD AcctingEmail varchar(70) NULL

