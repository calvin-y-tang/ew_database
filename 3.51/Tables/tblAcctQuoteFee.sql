CREATE TABLE [dbo].[tblAcctQuoteFee]
(
	[AcctQuoteFeeID] INT          IDENTITY (1, 1) NOT NULL,
	[AcctQuoteID]    INT          NOT NULL, 
	[FeeValueName]   VARCHAR (30) NOT NULL,
	[FeeAmount]      MONEY        NOT NULL, 
	[FeeUnit]        VARCHAR(10)  NULL,
    [DateAdded]      DATETIME     NOT NULL,
    [UserIDAdded]    VARCHAR (15) NOT NULL,
    [DateEdited]     DATETIME     NULL,
    [UserIDEdited]   VARCHAR (15) NULL,
	CONSTRAINT [PK_tblAcctQuoteFee] PRIMARY KEY CLUSTERED ([AcctQuoteFeeID] ASC)
)
