CREATE TABLE [dbo].[GeicoRequestContext] (
    [Id]              INT           IDENTITY (1, 1) NOT NULL,
    [ApplicationName] VARCHAR (255) NULL,
    [OSName]          VARCHAR (64)  NULL,
    [UniqueRequestId] VARCHAR (128) NULL,
    [UserName]        VARCHAR (128) NULL,
    [MachineName]     VARCHAR (128) NULL,
    [UserRegion]      VARCHAR (64)  NULL,
    [EchoField]       VARCHAR (128) NULL,
    CONSTRAINT [PK_GeicoRequestContext] PRIMARY KEY CLUSTERED ([Id] ASC)
);

