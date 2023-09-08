CREATE TABLE [dbo].[Company] (
    [CompanyID]       INT           IDENTITY (1, 1) NOT NULL,
    [DataFeedID]      VARCHAR (15)  NULL,
    [GPEntityPrefix]  VARCHAR (3)   NULL,
    [GPCustomerID]    VARCHAR (15)  NULL,
    [IMECentricID]    INT           NULL,
    [SourceID]        INT           NULL,
    [ExtName]         VARCHAR (100) NULL,
    [IntName]         VARCHAR (70)  NULL,
    [Address1]        VARCHAR (50)  NULL,
    [Address2]        VARCHAR (50)  NULL,
    [Address3]        VARCHAR (50)  NULL,
    [City]            VARCHAR (35)  NULL,
    [State]           VARCHAR (3)   NULL,
    [Zip]             VARCHAR (10)  NULL,
    [Country]         VARCHAR (2)   NULL,
    [Phone]           VARCHAR (21)  NULL,
    [DateEdited]      DATETIME      NULL,
    [Active]          BIT           NULL,
    [EWCompanyTypeID] INT           NULL,
    [GPExportStatus]  INT           NULL,
    [ParentCompanyID] INT           NULL,
    [DateAdded]       DATETIME      CONSTRAINT [DF_Company_DateAdded] DEFAULT (getdate()) NULL,
    [AcctingEmail]    VARCHAR (70)  NULL,
    [CustomerType]    VARCHAR (100) NULL,
    CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED ([CompanyID] ASC)
);




GO



GO



GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_Company_GPEntityPrefixIMECentricID]
    ON [dbo].[Company]([GPEntityPrefix] ASC, [IMECentricID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_Company_GPEntityPrefixDataFeedID]
    ON [dbo].[Company]([GPEntityPrefix] ASC, [DataFeedID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Company_GPCustomerID]
    ON [dbo].[Company]([GPCustomerID] ASC);

