CREATE TABLE [dbo].[tblCompanyDocuments]
(
	[CompanyDocumentID] INT IDENTITY(1,1) NOT NULL,
	[CompanyCode] INT NOT NULL,
	[FolderID] INT NOT NULL,
	[DocumentType] INT NOT NULL,
	[DocumentFilename] VARCHAR (256) NOT NULL,
	[Description] VARCHAR (128),
	[DateAdded] DATETIME NOT NULL,
	[UserIDAdded] VARCHAR (15) NOT NULL,
	[DateEdited] DATETIME NOT NULL,
	[UserIDEdited] VARCHAR (15) NOT NULL,
	[Active] BIT NOT NULL
	CONSTRAINT [PK_tblCompanyDocuments] PRIMARY KEY CLUSTERED ([CompanyDocumentID] ASC)
)
