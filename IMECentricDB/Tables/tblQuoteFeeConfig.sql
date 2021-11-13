CREATE TABLE [dbo].[tblQuoteFeeConfig]
(
	[QuoteFeeConfigID] INT            IDENTITY (1, 1) NOT NULL,
	[FeeValueName]     VARCHAR (30)   NOT NULL,
	[QuoteType]        VARCHAR (2)    NULL, 
	[DisplayOrder]     INT            NOT NULL, 
    [DateAdded]        DATETIME       NOT NULL,
    [UserIDAdded]      VARCHAR (15)   NOT NULL,
    [DateEdited]       DATETIME       NULL,
    [UserIDEdited]     VARCHAR (15)   NULL,
	[ProdCode]         INT            NULL, 
	CONSTRAINT [PK_tblQuoteFeeConfig] PRIMARY KEY CLUSTERED ([QuoteFeeConfigID] ASC)
)
