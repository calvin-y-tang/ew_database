CREATE TABLE [dbo].[tblWebActionLink]
(
	[WebActionLinkID] INT          IDENTITY (1, 1) NOT NULL,
	[UniqueKey]       VARCHAR(36)  CONSTRAINT [DF_tblWebActionLink_UniqueKey] DEFAULT (NEWID()) NOT NULL,
	[ActionType]      VARCHAR(20)  NULL, 
	[UserType]        VARCHAR(2)   NULL, 
	[UserCode]        INT          NULL, 
	[Param]           VARCHAR(100) NULL, 
	[ExpirationDate]  DATETIME     NULL, 
	[DateUsed]        DATETIME     NULL, 
	[DateAdded]       DATETIME     NOT NULL, 
	[UserIDAdded]     VARCHAR(15)  NOT NULL, 
	CONSTRAINT [PK_tblWebActionLink] PRIMARY KEY CLUSTERED ([WebActionLinkID] ASC)
)
