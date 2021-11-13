CREATE TABLE [dbo].[ConfListMessage] (
    [PrimaryKey]         INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ExtConfirmationID]  VARCHAR (64)    NULL,
    [MessageKey]         VARCHAR (30)    NULL,
    [Message]            NVARCHAR (2048) NULL,
    [ExtLanguageKey]     VARCHAR (10)    NULL,
    [NextAction]         VARCHAR (60)    NULL,
    [VMAction]           VARCHAR (60)    NULL,
    [Key1Action]         VARCHAR (60)    NULL,
    [Key2Action]         VARCHAR (60)    NULL,
    [Key3Action]         VARCHAR (60)    NULL,
    [Key4Action]         VARCHAR (60)    NULL,
    [Key5Action]         VARCHAR (60)    NULL,
    [Key6Action]         VARCHAR (60)    NULL,
    [Key7Action]         VARCHAR (60)    NULL,
    [Key8Action]         VARCHAR (60)    NULL,
    [Key9Action]         VARCHAR (60)    NULL,
    [TimeoutIntervalSec] INT             NULL,
    [Key0Action]         VARCHAR (60)    NULL,
    CONSTRAINT [PK_ConfListMessage] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_ConfListMessage_ExtConfirmationIDMessageKey]
    ON [dbo].[ConfListMessage]([ExtConfirmationID] ASC, [MessageKey] ASC) WHERE ([extConfirmationID] IS NOT NULL) WITH (FILLFACTOR = 90);

