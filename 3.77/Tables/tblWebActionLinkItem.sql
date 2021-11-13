CREATE TABLE [dbo].[tblWebActionLinkItem]
(
	[WebActionLinkItemID] INT          IDENTITY (1, 1) NOT NULL,
	[WebActionLinkID]     INT          NOT NULL,
	[ActionTable]         VARCHAR(100) NOT NULL,
	[ActionKey]           INT          NULL, 
	[DateAdded]           DATETIME     NOT NULL, 
	[UserIDAdded]         VARCHAR(15)  NOT NULL, 
	CONSTRAINT [PK_tblWebActionLinkItem] PRIMARY KEY CLUSTERED ([WebActionLinkItemID] ASC)
)
