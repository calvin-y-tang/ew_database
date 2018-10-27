UPDATE tblDocument SET Status='Active'
GO


INSERT INTO 
     tblExceptionList
     VALUES('Distribute Document', 'Active', CURRENT_TIMESTAMP, 'Admin', CURRENT_TIMESTAMP, 'Admin');
GO
INSERT INTO 
     tblExceptionList
     VALUES('Distribute Report', 'Active', CURRENT_TIMESTAMP, 'Admin', CURRENT_TIMESTAMP, 'Admin');
GO
INSERT INTO 
     tblExceptionList
     VALUES('Generate Document', 'Active', CURRENT_TIMESTAMP, 'Admin', CURRENT_TIMESTAMP, 'Admin');
GO

ALTER TABLE tblEWBulkBilling
 ADD EDIERPCaseRequired BIT
GO


UPDATE tblControl SET DBVersion='2.38'
GO
