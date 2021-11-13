CREATE TABLE [dbo].[tblQuoteHandling]
(
	[QuoteHandlingID] INT          IDENTITY (1, 1) NOT NULL,
	[Description]     VARCHAR (20) NOT NULL,
    [DateAdded]       DATETIME     NOT NULL,
    [UserIDAdded]     VARCHAR (15) NOT NULL,
    [DateEdited]      DATETIME     NULL,
    [UserIDEdited]    VARCHAR (15) NULL,
	CONSTRAINT [PK_tblQuoteHandling] PRIMARY KEY CLUSTERED ([QuoteHandlingID] ASC)
)
