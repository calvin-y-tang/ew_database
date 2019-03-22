CREATE TABLE [dbo].[tblQuoteStatus] (
    [QuoteStatusID]   INT          IDENTITY (1, 1) NOT NULL,
    [QuoteType]       VARCHAR (2)  NOT NULL,
    [Description]     VARCHAR (30) NOT NULL,
    [IsClosed]        BIT          NOT NULL,
    [DateAdded]       DATETIME     NOT NULL,
    [UserIDAdded]     VARCHAR (15) NOT NULL,
    [DateEdited]      DATETIME     NULL,
    [UserIDEdited]    VARCHAR (15) NULL,
    [QuoteHandlingID] INT          NULL, 
    CONSTRAINT [PK_tblQuoteStatus] PRIMARY KEY CLUSTERED ([QuoteStatusID] ASC)
);

