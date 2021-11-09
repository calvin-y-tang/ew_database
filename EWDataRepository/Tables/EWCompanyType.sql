CREATE TABLE [dbo].[EWCompanyType] (
    [EWCompanyTypeID] INT          NOT NULL,
    [SeqNo]           INT          NULL,
    [Name]            VARCHAR (20) NULL,
    CONSTRAINT [PK_EWCompanyType] PRIMARY KEY CLUSTERED ([EWCompanyTypeID] ASC)
);

