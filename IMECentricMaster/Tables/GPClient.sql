CREATE TABLE [dbo].[GPClient] (
    [PrimaryKey]     INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FormatVersion]  INT           NOT NULL,
    [ProcessedFlag]  BIT           NOT NULL,
    [ExportDate]     DATETIME      NOT NULL,
    [GPEntityPrefix] VARCHAR (3)   NOT NULL,
    [GPCustomerID]   VARCHAR (15)  NOT NULL,
    [ClientID]       INT           NOT NULL,
    [ClientName]     VARCHAR (100) NOT NULL,
    [Address1]       VARCHAR (50)  NULL,
    [Address2]       VARCHAR (50)  NULL,
    [Address3]       VARCHAR (50)  NULL,
    [City]           VARCHAR (35)  NULL,
    [State]          VARCHAR (2)   NULL,
    [Zip]            VARCHAR (10)  NULL,
    [Country]        VARCHAR (2)   NOT NULL,
    [Phone]          VARCHAR (21)  NULL,
    [Fax]            VARCHAR (21)  NULL,
    [Email]          VARCHAR (150) NULL,
    [Cell]           VARCHAR (21)  NULL,
    [SourceID]       INT           NULL,
    CONSTRAINT [PK_GPClient] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_GPClient_ProcessedFlagClientID]
    ON [dbo].[GPClient]([ProcessedFlag] ASC, [ClientID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_GPClient_ExportDate]
    ON [dbo].[GPClient]([ExportDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_GPClient_GPEntityPrefixFormatVersionProcessedFlag]
    ON [dbo].[GPClient]([GPEntityPrefix] ASC, [FormatVersion] ASC, [ProcessedFlag] ASC);

