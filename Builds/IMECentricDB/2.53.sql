ALTER TABLE [tblControl]
  ADD [FeeScheduleSetting] INTEGER DEFAULT 1 NOT NULL
GO

ALTER TABLE [tblAcctDetail]
  ADD [GLNaturalAccount] VARCHAR(5)
GO

CREATE TABLE tblEWGLAcct
(
[GLNaturalAcct] [varchar] (5) NOT NULL,
[GLAcctCategoryID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [tblEWGLAcct] ADD CONSTRAINT [PK_tblEWGLAcct] PRIMARY KEY CLUSTERED  ([GLNaturalAcct]) ON [PRIMARY]
GO

CREATE TABLE [tblEWGLAcctCategory]
(
[GLAcctCategoryID] [int] NOT NULL,
[Name] [varchar] (50) NULL,
[IncludeOnFlashReport] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [tblEWGLAcctCategory] ADD CONSTRAINT [PK_tblEWGLAcctCategory] PRIMARY KEY CLUSTERED  ([GLAcctCategoryID]) ON [PRIMARY]
GO

ALTER TABLE tblEWFolderDef ADD
GroupCode varchar (15) NULL,
GroupDesc varchar (50) NULL,
ArchiveType INT NULL,
ArchiveAge INT NULL,
ArchiveFolder VARCHAR (260) NULL
GO

ALTER TABLE tblEWFolderType ADD
[SecurityType] [int] NULL
GO


UPDATE tblControl SET DBVersion='2.53'
GO
