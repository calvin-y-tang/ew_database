CREATE TABLE [dbo].[tblNotifyEvent]
(
	[NotifyEventID] INT IDENTITY (1,1) NOT NULL,
	[Description] VARCHAR(70) NULL,
	[Active] BIT CONSTRAINT [DF_tblNotifyEvent_Active] DEFAULT ((1)) NOT NULL,
	[DateAdded] DATETIME NULL,
	[UserIDAdded] VARCHAR(15) NULL,
	[DateEdited] DATETIME NULL,
	[UserIDEdited] VARCHAR(15) NULL,
    [DisplayOrder]           INT          NOT NULL,
	CONSTRAINT [PK_tblNotifyEvent] PRIMARY KEY CLUSTERED ([NotifyEventID] ASC)
)
