CREATE TABLE [dbo].[tblCaseICDRequest] (
    [SeqNo]        INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]      INT           NOT NULL,
    [ICDCode]      VARCHAR (10)  NULL,
    [Status]       VARCHAR (50)  NULL,
    [Description]  VARCHAR (200) NULL,
    [DateAdded]    DATETIME      NULL,
    [UserIDAdded]  VARCHAR (50)  NULL,
    [DateEdited]   DATETIME      NULL,
    [UserIDEdited] VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblCaseICDRequest] PRIMARY KEY CLUSTERED ([SeqNo] ASC)
);

