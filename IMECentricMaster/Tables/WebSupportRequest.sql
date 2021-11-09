CREATE TABLE [dbo].[WebSupportRequest] (
    [WebSupportRequestID] INT              IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [GUID]                UNIQUEIDENTIFIER NOT NULL,
    [DBID]                INT              NOT NULL,
    [WebUserID]           INT              NULL,
    [EWWebUserID]         INT              NULL,
    [WebCompanyID]        INT              NULL,
    [DateAdded]           DATETIME         NULL,
    [UserIDAdded]         VARCHAR (15)     NULL,
    CONSTRAINT [PK_WebSupportRequest] PRIMARY KEY CLUSTERED ([WebSupportRequestID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_WebSupportRequest_GUID]
    ON [dbo].[WebSupportRequest]([GUID] ASC);

