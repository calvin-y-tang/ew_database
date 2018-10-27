CREATE TABLE [dbo].[SedgwickClientInformationRecord] (
    [SCMSClientId]           INT           NOT NULL,
    [SCMSClientAccount]      INT           NULL,
    [SCMSClientUnitLocation] VARCHAR (8)   NULL,
    [SCMSDatabaseOffice]     INT           NULL,
    [ClientName]             VARCHAR (100) NULL,
    [ClientAddressLine1]     VARCHAR (32)  NULL,
    [ClientAddressLine2]     VARCHAR (32)  NULL,
    [ClientCity]             VARCHAR (20)  NULL,
    [ClientState]            VARCHAR (2)   NULL,
    [ClientCountry]          VARCHAR (8)   NULL,
    [ClientPostalCode]       VARCHAR (32)  NULL,
    [ClientPhoneNumber]      VARCHAR (18)  NULL,
    [PaperFROI]              CHAR (1)      NULL,
    [ClientFEIN]             INT           NULL,
    [ClientSIC]              INT           NULL,
    [InceptionDate]          DATETIME      NULL,
    [ExpirationDate]         DATETIME      NULL,
    [EntityLevel]            CHAR (1)      NULL,
    [EntityName]             VARCHAR (100) NULL,
    [ClientContactStatus]    CHAR (1)      NULL,
    CONSTRAINT [PK_SedgwickClientInformationRecord_1] PRIMARY KEY CLUSTERED ([SCMSClientId] ASC)
);

