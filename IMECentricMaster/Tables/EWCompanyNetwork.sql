CREATE TABLE [dbo].[EWCompanyNetwork] (
    [EWCompanyID] INT          NOT NULL,
    [EWNetworkID] INT          NOT NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    [DateAdded]   DATETIME     NULL,
    CONSTRAINT [PK_EWCompanyNetwork] PRIMARY KEY CLUSTERED ([EWCompanyID] ASC, [EWNetworkID] ASC)
);

