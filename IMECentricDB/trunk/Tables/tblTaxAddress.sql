CREATE TABLE [dbo].[tblTaxAddress]
(
	[TaxAddressID] INT IDENTITY (1, 1) NOT NULL,
	[TableType]    VARCHAR(2)    NULL, 
	[TableKey]     INT           NULL, 
	[TaxCode]      VARCHAR(20)   NOT NULL, 
	[DateAdded]    DATETIME      NOT NULL,
	[UserIDAdded]  VARCHAR (15)  NOT NULL,
	[DateEdited]   DATETIME      NULL,
	[UserIDEdited] VARCHAR (15)  NULL,
	CONSTRAINT [PK_TblTaxAddress] PRIMARY KEY CLUSTERED ([TaxAddressID] ASC)
)
GO

CREATE UNIQUE INDEX [IX_tblTaxAddress_TableTypeKeyCode]
	ON [dbo].[tblTaxAddress]([TableType] ASC, [TableKey] ASC, [TaxCode] ASC);


