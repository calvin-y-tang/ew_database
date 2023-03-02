CREATE TABLE [dbo].[ISMapping]
(
	[ID]          [int]          IDENTITY(1,1) NOT NULL,
	[MappingType] [varchar](30)  NULL,
	[MappingName] [varchar](30)  NULL,
	[SrcValue]    [varchar](100) NULL,
	[SrcDescrip]  [varchar](500) NULL,
	[DstValue]    [varchar](500) NULL,
	[DstDescrip]  [varchar](500) NULL,
    CONSTRAINT [PK_ISMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);

