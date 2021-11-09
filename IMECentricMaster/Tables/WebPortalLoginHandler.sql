CREATE TABLE [dbo].[WebPortalLoginHandler] (
    [WebPortalLoginHandlerID] INT              IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [GUID]                    UNIQUEIDENTIFIER NOT NULL,
    [DBID]                    INT              NOT NULL,
    [WebUserID]               INT              NOT NULL,
    [UserID]                  VARCHAR (100)    NOT NULL,
    [IMECentricCode]          INT              NOT NULL,
    [WebCompanyID]            INT              NOT NULL,
    [PortalVersion]           INT              NOT NULL,
    [DateAdded]               DATETIME         NOT NULL,
    [UserIDAdded]             VARCHAR (15)     NOT NULL,
    CONSTRAINT [PK_WebPortalLoginHandler] PRIMARY KEY CLUSTERED ([WebPortalLoginHandlerID] ASC)
);

