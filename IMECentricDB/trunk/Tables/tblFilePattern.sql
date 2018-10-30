CREATE TABLE [dbo].[tblFilePattern]
(
	[FilePatternID]   INT           IDENTITY (1, 1) NOT NULL,
	[FilePatternDesc] VARCHAR(50)   NOT NULL,
	[FilePattern]     VARCHAR(255)  NOT NULL,
	[CaseDocTypeID]   INT           NULL,
	[DocumentDescrip] VARCHAR(255)  NULL,
	CONSTRAINT [PK_tblFilePattern] PRIMARY KEY CLUSTERED ([FilePatternID] ASC)
)
