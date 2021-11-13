CREATE TABLE [dbo].[tblCaseDocType](
	[CaseDocTypeID] [int]        IDENTITY(1,1) NOT NULL,
	[ShortDesc]     [varchar](25) NOT NULL,
	[Description]   [varchar](50) NOT NULL,
	[TypeCategory]  [varchar](50) NOT NULL, 
    [PublishOnWeb]  BIT           CONSTRAINT [DF_tblCaseDocType_PublishOnWeb] DEFAULT 0  NOT NULL, 
    [FilterKey]     VARCHAR(10)   NULL, 
    CONSTRAINT [PK_tblCaseDocType] PRIMARY KEY ([CaseDocTypeID])
) ON [PRIMARY]

Go
