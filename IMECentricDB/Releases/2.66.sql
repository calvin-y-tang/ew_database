DECLARE @tableName VARCHAR(MAX) = 'tblControl'
DECLARE @columnName VARCHAR(MAX) = 'UsePeerBill'
DECLARE @ConstraintName nvarchar(200)
SELECT @ConstraintName = Name 
FROM SYS.DEFAULT_CONSTRAINTS
WHERE PARENT_OBJECT_ID = OBJECT_ID(@tableName) 
AND PARENT_COLUMN_ID = (
    SELECT column_id FROM sys.columns
    WHERE NAME = @columnName AND object_id = OBJECT_ID(@tableName))
IF @ConstraintName IS NOT NULL
    EXEC('ALTER TABLE '+@tableName+' DROP CONSTRAINT ' + @ConstraintName)
GO

CREATE TABLE tblTempVendorVoucher
(
TempVendorVoucherID	Int	IDENTITY NOT NULL,
TempVendorVoucherNo	VarChar(15)	NOT NULL,
CaseNbr	Int	NOT NULL,
VendorID	Int	NOT NULL,
VendorType	VarChar(3)	NOT NULL,
DateAdded	DateTime	NOT NULL,
UserIDAdded	VarChar(20)	NOT NULL,
DateEdited	DateTime	NOT NULL,
UserIDEdited	VarChar(20)	NOT NULL,
ProdCode	Int	NOT NULL,
Amount	Money	NOT NULL,
Comment	VarChar(30)	NULL,
EWFacilityID	Int	NOT NULL,
BatchNbr	Int	NULL,
ExportDate	DateTime	NULL,
PayeeName	Varchar(64)	NOT NULL,
AddressLine1	Varchar(50)	NOT NULL,
AddressLine2	Varchar(50)	NULL,
AddressLine3	Varchar(50)	NULL,
City	Varchar(35)	NOT NULL,
State	Char(2)	NOT NULL,
Zip	VarChar(12)	NOT NULL,
PRIMARY KEY (TempVendorVoucherID)
)
GO

ALTER Table tblIMEDATA
ADD ExamineeReimbDefProdCode Int	NULL
GO

ALTER TABLE tblEWParentCompany ADD
 [FolderID] [int] NULL,
 [SLADocumentFileName] [varchar](80) NULL
GO



UPDATE tblDoctorCheckRequest
 SET GPCheckReqNbr=CheckRequestID
 WHERE GPCheckReqNbr IS NULL
GO

UPDATE tblCompany
 SET GPCustomerID=(SELECT TOP 1 FacilityID FROM tblControl)+'-'+CAST(CompanyCode AS VARCHAR)
 WHERE GPCustomerID IS NULL
GO

UPDATE AD
 SET HeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblAcctDetail AS AD ON AD.DocumentNbr = AH.DocumentNbr AND AD.DocumentType = AH.DocumentType
 WHERE AD.HeaderID IS NULL

UPDATE Vo
 SET RelatedInvHeaderID=Inv.HeaderID
 FROM tblAcctHeader AS Vo
 INNER JOIN tblAcctHeader AS Inv ON inv.DocumentNbr=vo.RelatedDocumentNbr AND Vo.DocumentType='VO' AND Inv.DocumentType='IN'
 WHERE Vo.RelatedInvHeaderID IS NULL

UPDATE CT
 SET HeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblCaseTrans AS CT ON CT.DocumentNbr = AH.DocumentNbr AND CT.Type = AH.DocumentType
 WHERE CT.HeaderID IS NULL

DELETE FROM tblClaimInfo
 WHERE InvoiceNbr NOT IN (SELECT DocumentNbr FROM tblAcctHeader WHERE DocumentType='IN')

UPDATE C
 SET InvHeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblClaimInfo AS C ON C.InvoiceNbr = AH.DocumentNbr AND AH.DocumentType='IN'
 WHERE C.InvHeaderID IS NULL

DELETE FROM tblGPInvoice
 WHERE InvoiceNbr NOT IN (SELECT DocumentNbr FROM tblAcctHeader WHERE DocumentType='IN')

DELETE FROM tblGPVoucher
 WHERE VoucherNbr NOT IN (SELECT DocumentNbr FROM tblAcctHeader WHERE DocumentType='VO')

UPDATE I
 SET InvHeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblGPInvoice AS I ON I.InvoiceNbr = AH.DocumentNbr AND AH.DocumentType='IN'
 WHERE I.InvHeaderID IS NULL

UPDATE V
 SET VoHeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblGPVoucher AS V ON V.VoucherNbr = AH.DocumentNbr AND AH.DocumentType='VO'
 WHERE V.VoHeaderID IS NULL

UPDATE RO
 SET InvHeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblRecordsObtainment AS RO ON Ro.InvoiceNbr = AH.DocumentNbr AND AH.DocumentType='IN'
 WHERE RO.InvHeaderID IS NULL

UPDATE I
 SET InvHeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblInvoiceAttachments AS I ON I.DocumentNbr = AH.DocumentNbr AND AH.DocumentType=I.DocumentType
 WHERE I.InvHeaderID IS NULL

UPDATE I
 SET InvHeaderID=AH.HeaderID
 FROM tblAcctHeader AS AH
 INNER JOIN tblGPInvoiceEDIStatus AS I ON I.InvoiceNbr = AH.DocumentNbr AND AH.DocumentType='IN'
 WHERE I.InvHeaderID IS NULL

GO


ALTER TABLE [dbo].[tblClaimInfo]
  ALTER COLUMN [InvHeaderID] [int] NOT NULL
GO

ALTER TABLE [tblGPInvoice]
  ALTER COLUMN [InvHeaderID] INTEGER NOT NULL
GO

ALTER TABLE [tblGPInvoiceEDIStatus]
  ALTER COLUMN [InvHeaderID] INTEGER NOT NULL
GO

ALTER TABLE [tblGPVoucher]
  ALTER COLUMN [VoHeaderID] INTEGER NOT NULL
GO


INSERT INTO tblUserSecurity
        ( UserID, GroupCode, OfficeCode )
SELECT DISTINCT UserID ,
       GroupCode ,
       -1 FROM tblUserSecurity
GO
DELETE FROM tblUserSecurity WHERE OfficeCode<>-1
GO
UPDATE tblUserSecurity SET OfficeCode=1
GO

ALTER TABLE tblUserSecurity
  DROP CONSTRAINT PK_usersecurity
GO

DROP INDEX IX_tblusersecurity_officecode ON tblUserSecurity
GO

ALTER TABLE tblUserSecurity
  ADD CONSTRAINT [PK_tblUserSecurity] PRIMARY KEY (UserID, GroupCode)
GO

DROP TABLE tblUserOfficeFunction
GO
DROP PROC sp_buildUserOfficeTables
GO

ALTER TABLE tblUserSecurity
  DROP CONSTRAINT DF_tblUserSecurity_officecode
GO

ALTER TABLE tblUserSecurity
  DROP COLUMN OfficeCode
GO


ALTER TABLE [tblAcctDetail]
  DROP CONSTRAINT [PK_TblInvoiceDetail]
GO

ALTER TABLE [tblAcctHeader]
  DROP CONSTRAINT [PK_TblAcctHeader]
GO

ALTER TABLE [tblAcctHeader]
  ADD CONSTRAINT [PK_tblAcctHeader] PRIMARY KEY ([HeaderID])
GO

ALTER TABLE [tblAcctDetail]
  ADD CONSTRAINT [PK_tblAcctDetail] PRIMARY KEY ([DetailID])
GO

ALTER TABLE [dbo].[tblClaimInfo] DROP CONSTRAINT [PK_tblClaimInfo]
GO
ALTER TABLE [dbo].[tblClaimInfo] ADD CONSTRAINT [PK_tblClaimInfo] PRIMARY KEY CLUSTERED  ([InvHeaderID])
GO

CREATE INDEX [IdxtblAcctHeader_BY_EWFacilityIDDocumentTypeDocumentNbr] ON [tblAcctHeader]([EWFacilityID],[DocumentType],[DocumentNbr])
GO

CREATE INDEX [IdxtblAcctDetail_BY_HeaderIDLineNbr] ON [tblAcctDetail]([HeaderID],[LineNbr])
GO


CREATE INDEX [IdxtblLogUsage_BY_DateAddedModuleName] ON [tblLogUsage]([DateAdded],[ModuleName])
GO

UPDATE tblControl SET DBVersion='2.66'
GO
