CREATE TABLE [dbo].[tblTaxTable] (
    [TaxCode]      VARCHAR (10) NOT NULL,
    [Description]  VARCHAR (50) NULL,
    [GLAcct]       VARCHAR (50) NULL,
    [Rate]         REAL         NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (20) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (20) NULL,
    [Vendor]       VARCHAR (70) NULL,
    CONSTRAINT [PK_TblTaxTable] PRIMARY KEY CLUSTERED ([TaxCode] ASC)
);

