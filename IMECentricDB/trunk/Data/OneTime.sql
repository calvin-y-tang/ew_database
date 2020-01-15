INSERT INTO tblUserFunction VALUES ('AckNewPortalAcct', 'Acknowledge - New Portal Accts Auto Provision', '2019-12-12')

--// IMEC-11382 - adding record into the tblMessageToken for the examinee last name, first name, and middle inital
insert into tblMessageToken (Name, Description)
values ('@ExamineeLastName@',''), ('@ExamineeFirstName@',''), ('@ExamineeMiddleInitial@','')
;