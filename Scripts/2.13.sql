UPDATE tblCaseHistory
 SET Type='ACCT'
 WHERE (Eventdesc='For PreInv' OR Eventdesc='For PrePay') AND ISNULL(Type,'')=''
GO

UPDATE tblDocument
 SET FaxCoverDemographics=2
 WHERE FaxCoverDemographics IS NULL
GO
UPDATE tblDocument
 SET FaxCoverPageID=2
 WHERE FaxCoverPageID IS NULL
GO

ALTER TABLE tblDocument
 ADD FaxEWFacilityID INT
GO

ALTER TABLE tblEWFaxCoverPage
 ALTER COLUMN DeviceName VARCHAR(50)
GO

UPDATE tblControl SET DBVersion='2.13'
GO
