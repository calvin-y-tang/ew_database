CREATE TABLE [dbo].[tblCaseType] (
    [Code]                INT          IDENTITY (1, 1) NOT NULL,
    [Description]         VARCHAR (60) NULL,
    [DateAdded]           DATETIME     NULL,
    [UserIDAdded]         VARCHAR (15) NULL,
    [DateEdited]          DATETIME     NULL,
    [UserIDEdited]        VARCHAR (15) NULL,
    [InstructionFilename] VARCHAR (50) NULL,
    [OfficeCode]          INT          NULL,
    [Status]              VARCHAR (15) NULL,
    [PublishOnWeb]        BIT          NULL,
    [WebSynchDate]        DATETIME     NULL,
    [WebID]               INT          NULL,
    [ShortDesc]           VARCHAR (20) NULL,
    [GPCaseType]          VARCHAR (2)  NULL,
    [EWBusLineID]         INT          NULL,
    [ExternalDesc]        VARCHAR(40)  NULL, 
    CONSTRAINT [PK_tblCaseType] PRIMARY KEY CLUSTERED ([Code] ASC)
);

