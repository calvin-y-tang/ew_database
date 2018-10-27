


ALTER TABLE [tblCase]
  ALTER COLUMN [RequestedDoc] VARCHAR(100)
GO


ALTER TABLE [tblCaseType]
  ALTER COLUMN [ShortDesc] VARCHAR(20)
GO



-----------------------------------------------------
--Changes for National Portal
-----------------------------------------------------


CREATE TABLE [tblEWClient] (
  [EWClientID] INTEGER NOT NULL,
  [EWCompanyID] INTEGER NOT NULL,
  [LastName] VARCHAR(50),
  [FirstName] VARCHAR(50),
  [Title] VARCHAR(50),
  [Prefix] VARCHAR(10),
  [Suffix] VARCHAR(50),
  [Addr1] VARCHAR(50),
  [Addr2] VARCHAR(50),
  [City] VARCHAR(50),
  [State] VARCHAR(2),
  [Zip] VARCHAR(10),
  [Country] VARCHAR(50),
  [Phone1] VARCHAR(15),
  [Phone1Ext] VARCHAR(15),
  [Phone2] VARCHAR(15),
  [Phone2Ext] VARCHAR(15),
  [Fax] VARCHAR(15),
  [Email] VARCHAR(70),
  [Status] VARCHAR(10),
  [TypeCode] INTEGER,
  [DateAdded] DATETIME,
  [UserIDAdded] VARCHAR(15),
  [DateEdited] DATETIME,
  [UserIDEdited] VARCHAR(15),
  [BillAddr1] VARCHAR(50),
  [BillAddr2] VARCHAR(50),
  [BillCity] VARCHAR(50),
  [BillState] VARCHAR(2),
  [BillZip] VARCHAR(10),
  [BillAttn] VARCHAR(70),
  CONSTRAINT [PK_EWClient] PRIMARY KEY CLUSTERED ([EWClientID])
)
GO

CREATE TABLE [tblEWCompany] (
  [EWCompanyID] INTEGER NOT NULL,
  [ExtName] VARCHAR(70),
  [IntName] VARCHAR(70),
  [Addr1] VARCHAR(50),
  [Addr2] VARCHAR(50),
  [City] VARCHAR(50),
  [State] VARCHAR(2),
  [Zip] VARCHAR(10),
  [Country] VARCHAR(50),
  [Phone] VARCHAR(15),
  [Status] VARCHAR(10),
  [CreditHold] BIT DEFAULT ((0)) NOT NULL,
  [EWFacilityID] INTEGER,
  [InvRemitEWFacilityID] INTEGER,
  [EWCompanyTypeID] INTEGER,
  [SecurityProfileID] INTEGER,
  [BulkBillingID] INTEGER,
  [ParentCompanyID] INTEGER,
  [DateAdded] DATETIME,
  [UserIDAdded] VARCHAR(20),
  [DateEdited] DATETIME,
  [UserIDEdited] VARCHAR(20),
  CONSTRAINT [PK_EWCompany] PRIMARY KEY CLUSTERED ([EWCompanyID])
)
GO

CREATE TABLE [tblEWWebUser] (
  [EWWebUserID] INTEGER NOT NULL,
  [UserID] VARCHAR(100),
  [Password] VARCHAR(200),
  [UserType] VARCHAR(2) NOT NULL,
  [EWEntityID] INTEGER NOT NULL,
  [ProviderSearch] BIT NOT NULL,
  [AutoPublishNewCases] BIT NOT NULL,
  [StatusID] INTEGER NOT NULL,
  [LastLoginDate] DATETIME,
  [FailedLoginAttempts] INTEGER NOT NULL,
  [LockoutDate] DATETIME,
  [LastPasswordChangeDate] DATETIME,
  [DateAdded] DATETIME,
  [UserIDAdded] VARCHAR(50),
  [DateEdited] DATETIME,
  [UserIDEdited] VARCHAR(50),
  CONSTRAINT [PK_EWWebUser] PRIMARY KEY CLUSTERED ([EWWebUserID])
)
GO

CREATE NONCLUSTERED INDEX [IX_EWWebUser_UserID] ON [tblEWWebUser]([UserID])
GO

CREATE NONCLUSTERED INDEX [IX_EWWebUser_UserTypeEntityID] ON [tblEWWebUser]([UserType],[EWEntityID])
GO


ALTER TABLE [tblClient]
  ADD [EWClientID] INTEGER
GO


ALTER TABLE [tblCompany]
  ADD [EWCompanyID] INTEGER
GO

ALTER TABLE [tblWebUser]
  ADD [EWWebUserID] INTEGER
GO


ALTER TABLE [tblControl]
  ADD [NAPSyncServiceAddress] VARCHAR(50)
GO

ALTER TABLE [tblControl]
  ADD [NAPSyncServiceBinding] VARCHAR(30)
GO

ALTER TABLE [tblControl]
  ADD [DBID] INTEGER
GO


DROP VIEW [vwCompany]
GO

CREATE VIEW [vwCompany]
AS
SELECT TOP 100 PERCENT tblCompany.*
    FROM tblCompany
    ORDER BY intname

GO



UPDATE tblControl SET DBVersion='1.56'
GO
