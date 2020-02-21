CREATE TABLE [dbo].[tblWebEvents] (
    [Code]         INT          IDENTITY (1, 1) NOT NULL,
    [Description]  VARCHAR (50) NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (30) NULL,
    [Type]         VARCHAR (20) NULL,
    [PublishOnWeb] BIT          CONSTRAINT [DF_tblWebEvents_publishonweb] DEFAULT ((0)) NULL,
    [PublishedTo]  VARCHAR (50) NULL,
    [NotifyTo]     VARCHAR (50) NULL,
    CONSTRAINT [PK_tblWebEvents] PRIMARY KEY CLUSTERED ([Code] ASC)
);

