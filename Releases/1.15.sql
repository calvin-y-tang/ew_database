

-----------------------------------------------
--Update system tables to latest schema
-----------------------------------------------

DROP TABLE tblEWFacility
GO

CREATE TABLE [tblEWFacility] (
  [EWFacilityID] INTEGER NOT NULL,
  [FacilityName] VARCHAR(40),
  [LegalName] VARCHAR(40),
  [SeqNo] INTEGER,
  [DBID] INTEGER,
  [ShortName] VARCHAR(10),
  [Accting] VARCHAR(5),
  [GPFacility] VARCHAR(3),
  [GPEntityPrefix] VARCHAR(3),
  [GPUserID] VARCHAR(10),
  [Address] VARCHAR(50),
  [City] VARCHAR(20),
  [State] VARCHAR(2),
  [Zip] VARCHAR(10),
  [Phone] VARCHAR(15),
  [Fax] VARCHAR(15),
  [FedTaxID] VARCHAR(20),
  [Region] VARCHAR(10),
  [DateAquired] DATETIME,
  [Active] BIT,
  CONSTRAINT [PK_EWFacility] PRIMARY KEY CLUSTERED ([EWFacilityID])
)
GO

ALTER TABLE [tblOffice]
  DROP COLUMN [GPLocation]
GO

ALTER TABLE [tblOffice]
  DROP COLUMN [GPUserID]
GO

ALTER TABLE [tblCompany]
  ADD [EWCompanyTypeID] INTEGER
GO


---------------------------------------------
--Added new ApptBased bool field to replace ServiceType
---------------------------------------------

ALTER TABLE [tblServices]
  ADD [ApptBased] BIT
GO
UPDATE tblServices SET apptBased=1
GO
UPDATE tblServices SET apptBased=0 WHERE ServiceType='Non Appt Based'
GO


---------------------------------------------
--Added two options for Claim form processing
---------------------------------------------

ALTER TABLE [tblIMEData]
  ADD [ShowProductDescOnClaimForm] BIT DEFAULT 0 NOT NULL
GO

ALTER TABLE [tblIMEData]
  ADD [ShowClientAsReferringProvider] BIT DEFAULT 0 NOT NULL
GO

---------------------------------------------
--Reset vwCompany after adding new column
---------------------------------------------

DROP VIEW vwcompany
GO
CREATE VIEW [dbo].[vwcompany]
AS
SELECT     TOP 100 PERCENT dbo.tblCompany.*
FROM         dbo.tblCompany
ORDER BY intname
GO

---------------------------------------------
--Add new tblClaimInfo for claim form type invoice
---------------------------------------------

CREATE TABLE [tblClaimInfo] (
  [InvoiceNbr] INTEGER,
  [PriorAuthNbr] VARCHAR(30),
  [DoctorNameWithDegree] VARCHAR(50),
  [DoctorSpecialty] VARCHAR(30),
  [DoctorNonNPINbr] VARCHAR(20),
  CONSTRAINT [PK_tblClaimInfo] PRIMARY KEY ([InvoiceNbr])
)
GO


ALTER TABLE [tblAcctDetail]
  ADD [SuppInfo] VARCHAR(100)
GO

update tblControl set DBVersion='1.15'
GO
