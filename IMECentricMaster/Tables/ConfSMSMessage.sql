CREATE TABLE [dbo].[ConfSMSMessage] (
    [DBID]         INT            NOT NULL,
    [SMSType]      INT            NOT NULL,
    [Message]      VARCHAR (2048) NOT NULL,
    [DateAdded]    DATETIME       NOT NULL,
    [DateEdited]   DATETIME       NOT NULL,
    [UserIDAdded]  VARCHAR (20)   NOT NULL,
    [UserIDEdited] VARCHAR (20)   NOT NULL,
    CONSTRAINT [PK_ConfSMSMessage] PRIMARY KEY CLUSTERED ([DBID] ASC, [SMSType] ASC)
);

