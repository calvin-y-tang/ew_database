CREATE TABLE [dbo].[tblWebActivation] (
    [ActivationID]    VARCHAR (40)  NOT NULL,
    [WebUserID]       INT           NULL,
    [Type]            VARCHAR (15)  NULL,
    [Status]          VARCHAR (10)  NULL,
    [DateAdded]       DATETIME      NULL,
    [UserIDAdded]     VARCHAR (50)  NULL,
    [SentDate]        DATETIME      NULL,
    [ExpirationDate]  DATETIME      NULL,
    [ActivatedDate]   DATETIME      NULL,
    [WebUserFullName] VARCHAR (35)  NULL,
    [EmailAddress]    VARCHAR (150) NULL,
    [RequestedFrom]   VARCHAR (1)   NULL,
    CONSTRAINT [PK_tblWebActivation] PRIMARY KEY CLUSTERED ([ActivationID] ASC)
);

