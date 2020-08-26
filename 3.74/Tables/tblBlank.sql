CREATE TABLE [dbo].[tblBlank] (
    [PrimaryKey]     INT           IDENTITY (1, 1) NOT NULL,
    [BlankValue]     VARCHAR (75)  NULL,
    [BlankValueLong] VARCHAR (300) NULL,
    CONSTRAINT [PK_tblBlank] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);

