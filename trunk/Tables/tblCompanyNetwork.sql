CREATE TABLE [dbo].[tblCompanyNetwork] (
    [CompanyCode] INT          NOT NULL,
    [EWNetworkID] INT          NOT NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    [DateAdded]   DATETIME     NULL,
    CONSTRAINT [PK_tblCompanyNetwork] PRIMARY KEY CLUSTERED ([CompanyCode] ASC, [EWNetworkID] ASC)
);

