

--------------------------------------------------------------------------
--Changes for File Manager
--------------------------------------------------------------------------
CREATE TABLE [tblEWFolderDef] (
  [FolderID] INTEGER NOT NULL,
  [Name] VARCHAR(50),
  [FolderType] INTEGER NOT NULL,
  [PathName] VARCHAR(260),
  [SortBy] INTEGER,
  [SortOrder] INTEGER,
  [FunctionCode] VARCHAR(30),
  CONSTRAINT [PK_tblEWFolderDef] PRIMARY KEY ([FolderID])
)
GO

insert into tbluserfunction (functioncode, functiondesc)
 select 'FileManager', 'FileMgr - Run File Manager'
 where not exists (select functionCode from tblUserFunction where functionCode='FileManager')

GO

--------------------------------------------------------------------------
--Add Transcription Department
--------------------------------------------------------------------------

CREATE TABLE [tblEWTransDept] (
  [EWTransDeptID] INTEGER NOT NULL,
  [Name] VARCHAR(20),
  [DBID] INTEGER NOT NULL,
  [FolderPath] VARCHAR(260),
  [Active] BIT NOT NULL,
  CONSTRAINT [PK_tblEWTransDept] PRIMARY KEY ([EWTransDeptID])
)
GO

ALTER TABLE [tblOffice]
  ADD [EWTransDeptID] INTEGER
GO

ALTER TABLE [tblTranscriptionJob]
  ADD [EWTransDeptID] INTEGER
GO

--Add a new security function to determine if user can cancel a transcription job
insert into tbluserfunction (functioncode, functiondesc)
 select 'TransTrackerCancel', 'Transcription Tracker - Cancel Job'
 where not exists (select functionCode from tblUserFunction where functionCode='TransTrackerCancel')

GO

--Add a table to store most recently used value per user

CREATE TABLE [dbo].[tblMRU]
(
[RowID] [int] NOT NULL IDENTITY(1, 1),
[Type] [int] NOT NULL,
[UserID] [varchar] (15) NULL,
[LastUsed] [datetime] NULL,
[Value] [varchar] (25) NULL
)
GO
ALTER TABLE [dbo].[tblMRU] ADD PRIMARY KEY CLUSTERED  ([RowID])
GO
CREATE NONCLUSTERED INDEX [IX_tblMRU] ON [dbo].[tblMRU] ([Type], [UserID], [LastUsed])
GO

ALTER TABLE tblControl ADD MRUSize INT
GO
UPDATE tblControl SET MRUSize = 10
GO


/****** Object:  StoredProcedure [proc_GetIssueComboItems]    Script Date: 1/22/2007 1:30:43 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_GetIssueComboItems]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetIssueComboItems];
GO

CREATE PROCEDURE [proc_GetIssueComboItems]

AS

SELECT issuecode,description from tblIssue 
WHERE PublishOnWeb = 1
	AND Status = 'Active'
ORDER BY description

GO

/****** Object:  StoredProcedure [proc_GetDegreeComboItems]    Script Date: 1/22/2007 1:30:43 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_GetDegreeComboItems]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetDegreeComboItems];
GO

CREATE PROCEDURE [proc_GetDegreeComboItems]

@CountryID int

AS

SELECT [EWAccreditationID], [Name] + ' - ' + [Description] Description FROM [tblEWAccreditation] 
WHERE PublishOnWeb = 1
	AND (CountryID = @CountryID)
	OR (CountryID is null)
ORDER BY [SeqNo]

GO


UPDATE tblControl SET DBVersion='1.82'
GO
