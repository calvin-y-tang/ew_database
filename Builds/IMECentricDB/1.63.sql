
--------------------------------------------------------------------------
--Added nocheck foreign key for references purpose only
--------------------------------------------------------------------------

ALTER TABLE [dbo].[tblCase]  WITH NOCHECK ADD  CONSTRAINT [FK_tblCase_tblClient] FOREIGN KEY([ClientCode])
REFERENCES [dbo].[tblClient] ([ClientCode])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[tblCase] NOCHECK CONSTRAINT [FK_tblCase_tblClient]
GO


ALTER TABLE [dbo].[tblCase]  WITH NOCHECK ADD  CONSTRAINT [FK_tblCase_tblExaminee] FOREIGN KEY([ChartNbr])
REFERENCES [dbo].[tblExaminee] ([ChartNbr])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[tblCase] NOCHECK CONSTRAINT [FK_tblCase_tblExaminee]
GO


ALTER TABLE [dbo].[tblClient]  WITH NOCHECK ADD  CONSTRAINT [FK_tblClient_tblCompany] FOREIGN KEY([CompanyCode])
REFERENCES [dbo].[tblCompany] ([CompanyCode])
GO

ALTER TABLE [dbo].[tblClient] NOCHECK CONSTRAINT [FK_tblClient_tblCompany]
GO


--------------------------------------------------------------------------
--New tables to store merged entity information
--------------------------------------------------------------------------


CREATE TABLE [tblMerge] (
  [MergeID] INTEGER IDENTITY(1,1) NOT NULL,
  [MergeDate] DATETIME NOT NULL,
  [MergeByUser] VARCHAR(25),
  [EntityType] VARCHAR(15),
  [MergeFromID] INTEGER NOT NULL,
  [MergeToID] INTEGER NOT NULL,
  [Descrip] VARCHAR(100),
  CONSTRAINT [PK_tblMerge] PRIMARY KEY CLUSTERED ([MergeID])
)
GO

CREATE TABLE [tblMergeLog] (
  [MergeLogID] INTEGER IDENTITY(1,1) NOT NULL,
  [MergeID] INTEGER NOT NULL,
  [Action] VARCHAR(50),
  [TableName] VARCHAR(50),
  [PrimaryKeyName] VARCHAR(75),
  [PrimaryKeyValue] VARCHAR(75),
  [Details] TEXT,
  CONSTRAINT [PK_tblMergeLog] PRIMARY KEY CLUSTERED ([MergeLogID])
)
GO


UPDATE tblControl SET DBVersion='1.63'
GO
