CREATE TABLE [dbo].[Client] (
    [ClientID]       INT           IDENTITY (1, 1) NOT NULL,
    [CompanyID]      INT           NULL,
    [DataFeedID]     VARCHAR (15)  NULL,
    [GPEntityPrefix] VARCHAR (3)   NULL,
    [IMECentricID]   INT           NULL,
    [SourceID]       INT           NULL,
    [FirstName]      VARCHAR (50)  NULL,
    [LastName]       VARCHAR (50)  NULL,
    [Address1]       VARCHAR (50)  NULL,
    [Address2]       VARCHAR (50)  NULL,
    [Address3]       VARCHAR (50)  NULL,
    [City]           VARCHAR (35)  NULL,
    [State]          VARCHAR (3)   NULL,
    [Zip]            VARCHAR (10)  NULL,
    [Country]        VARCHAR (2)   NULL,
    [Phone]          VARCHAR (21)  NULL,
    [PhoneExt]       VARCHAR (15)  NULL,
    [Fax]            VARCHAR (21)  NULL,
    [Email]          VARCHAR (150) NULL,
    [DateEdited]     DATETIME      NULL,
    [Active]         BIT           NULL,
    [GPExportStatus] INT           NULL,
    [DateAdded]      DATETIME      CONSTRAINT [DF_Client_DateAdded] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED ([ClientID] ASC)
);




GO



GO



GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_Client_GPEntityPrefixIMECentricID]
    ON [dbo].[Client]([GPEntityPrefix] ASC, [IMECentricID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_Client_GPEntityPrefixDataFeedID]
    ON [dbo].[Client]([GPEntityPrefix] ASC, [DataFeedID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Client_ClientID]
    ON [dbo].[Client]([ClientID] ASC);

