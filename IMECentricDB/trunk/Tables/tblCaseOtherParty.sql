CREATE TABLE [dbo].[tblCaseOtherParty] (
    [CaseNbr]           INT           NOT NULL,
    [OPCode]            INT           NOT NULL,
    [Type]              VARCHAR (15)  NULL,
    [DueDate]           DATETIME      NULL,
    [UserIDResponsible] VARCHAR (20)  NULL,
    [Status]            VARCHAR (15)  NULL,
    [DateAdded]         DATETIME      NULL,
    [UserIDAdded]       VARCHAR (20)  NULL,
    [DateEdited]        DATETIME      NULL,
    [UserIDEdited]      VARCHAR (20)  NULL,
    [Description]       VARCHAR (200) NULL,
    CONSTRAINT [PK_TblCaseOtherParty] PRIMARY KEY CLUSTERED ([CaseNbr] ASC, [OPCode] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblCaseOtherParty_StatusDueDate]
    ON [dbo].[tblCaseOtherParty]([Status] ASC, [DueDate] ASC)
    INCLUDE([CaseNbr], [OPCode]);

