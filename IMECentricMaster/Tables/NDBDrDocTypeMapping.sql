CREATE TABLE [dbo].[NDBDrDocTypeMapping] (
    [FromDrDocType]   VARCHAR (50) NOT NULL,
    [ToDrDocType]     VARCHAR (50) NULL,
    [ToEWDrDocTypeID] INT          NULL,
    CONSTRAINT [PK_NDBDrDocTypeMapping] PRIMARY KEY CLUSTERED ([FromDrDocType] ASC)
);

