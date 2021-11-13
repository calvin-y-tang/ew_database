CREATE TABLE [dbo].[tblEWCompanyType] (
    [EWCompanyTypeID] INT          NOT NULL,
    [SeqNo]           INT          NULL,
    [Name]            VARCHAR (20) NULL,
    CONSTRAINT [PK_tblEWCompanyType] PRIMARY KEY CLUSTERED ([EWCompanyTypeID] ASC)
);

