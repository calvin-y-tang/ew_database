CREATE TABLE [dbo].[tblTaxState] (
    [TaxCode]     VARCHAR (10) NOT NULL,
    [StateCode]   VARCHAR (5)  NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (30) NULL,
    CONSTRAINT [PK_tblTaxState] PRIMARY KEY CLUSTERED ([TaxCode] ASC, [StateCode] ASC)
);

