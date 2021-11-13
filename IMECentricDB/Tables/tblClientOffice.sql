CREATE TABLE [dbo].[tblClientOffice] (
    [ClientCode]  INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (15) NULL,
	[IsDefault]   BIT		   CONSTRAINT [DF_tblClientOffice_IsDefault] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblClientOffice] PRIMARY KEY CLUSTERED ([ClientCode] ASC, [OfficeCode] ASC)
);

