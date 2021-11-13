CREATE TABLE [dbo].[tblWebEventsOverride] (
    [SeqNo]          INT          IDENTITY (1, 1) NOT NULL,
    [IMECentricCode] INT          NULL,
    [UserType]       VARCHAR (10) NULL,
    [WebEventsCode]  INT          NULL,
    [Description]    VARCHAR (50) NULL,
    [Type]           VARCHAR (20) NULL,
    [PublishOnWeb]   BIT          NULL,
    [PublishedTo]    VARCHAR (50) NULL,
    [NotifyTo]       VARCHAR (50) NULL,
    [DateAdded]      DATETIME     NULL,
    [UserIDAdded]    VARCHAR (30) NULL,
    [DateEdited]     DATETIME     NULL,
    [UserIDEdited]   VARCHAR (30) NULL,
    CONSTRAINT [PK_tblWebEventsOverride] PRIMARY KEY CLUSTERED ([SeqNo] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblWebEventsOverride_IMECentricCode]
    ON [dbo].[tblWebEventsOverride]([IMECentricCode] ASC);

