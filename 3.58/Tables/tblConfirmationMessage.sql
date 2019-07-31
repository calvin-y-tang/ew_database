CREATE TABLE [dbo].[tblConfirmationMessage] (
    [ConfirmationMessageID] INT             IDENTITY (1, 1) NOT NULL,
    [ExtMessageID]          VARCHAR (30)  NULL,
    [Description]           VARCHAR (35)    NULL,
    [DateAdded]             DATETIME        NULL,
    [UserIDAdded]           VARCHAR (15)    NULL,
    [DateEdited]            DATETIME        NULL,
    [UserIDEdited]          VARCHAR (15)    NULL,
    [Message]               NVARCHAR (1000) NULL,
    [ConfirmationSystemID]  INT           CONSTRAINT [DF_tblConfirmationMessage_ConfirmationSystemID] DEFAULT ((1)) NOT NULL,
    [MasterExtMessageID]    VARCHAR (30)  NULL,
    [ExtLanguageKey]        VARCHAR (10)  NULL,
    [NextAction]            VARCHAR (60)  NULL,
    [VMAction]              VARCHAR (60)  NULL,
    [Key1Action]            VARCHAR (60)  NULL,
    [Key2Action]            VARCHAR (60)  NULL,
    [Key3Action]            VARCHAR (60)  NULL,
    [Key4Action]            VARCHAR (60)  NULL,
    [Key5Action]            VARCHAR (60)  NULL,
    [Key6Action]            VARCHAR (60)  NULL,
    [Key7Action]            VARCHAR (60)  NULL,
    [Key8Action]            VARCHAR (60)  NULL,
    [Key9Action]            VARCHAR (60)  NULL,
    [Key0Action]            VARCHAR (60)  NULL,
    [TimeoutIntervalSec]    INT           NULL,
    CONSTRAINT [PK_tblConfirmationMessage] PRIMARY KEY CLUSTERED ([ConfirmationMessageID] ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblConfirmationMessage_ConfirmationSystemIDExtMessageID]
    ON [dbo].[tblConfirmationMessage]([ConfirmationSystemID] ASC, [ExtMessageID] ASC);
GO




