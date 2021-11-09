CREATE TABLE [dbo].[WebNotification] (
    [PrimaryKey]   INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserType]     VARCHAR (2)  NULL,
    [EWEntityID]   INT          NULL,
    [WebEventID]   INT          NULL,
    [PublishOnWeb] BIT          CONSTRAINT [DF_WebNotification_PublishOnWeb] DEFAULT ((0)) NOT NULL,
    [PublishedTo]  VARCHAR (10) NULL,
    [NotifyTo]     VARCHAR (10) NULL,
    [DateAdded]    DATETIME     NULL,
    [UserAdded]    INT          NULL,
    [DateEdited]   DATETIME     NULL,
    [UserEdited]   INT          NULL,
    CONSTRAINT [PK_WebNotification] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_WebNotification_EWEntityIDUserType]
    ON [dbo].[WebNotification]([EWEntityID] ASC, [UserType] ASC);

