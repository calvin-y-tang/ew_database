CREATE TABLE [dbo].[tblAddressAbbreviation] (
    [PrimaryKey]     INT          IDENTITY (1, 1) NOT NULL,
    [Abbreviation]   VARCHAR (10) NULL,
    [FullForm]       VARCHAR (30) NULL,
    [ForAddressLine] BIT          CONSTRAINT [DF_tblAddressAbbreviation_ForAddressLine] DEFAULT ((0)) NOT NULL,
    [ForCity]        BIT          CONSTRAINT [DF_tblAddressAbbreviation_ForCity] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblAddressAbbreviation] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);



