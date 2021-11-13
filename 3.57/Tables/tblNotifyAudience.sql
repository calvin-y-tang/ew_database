CREATE TABLE [dbo].[tblNotifyAudience]
(
	[NotifyAudienceID] INT IDENTITY (1,1) NOT NULL,
	[NotifyEventID] INT NOT NULL,
	[NotifyMethodID] INT NOT NULL,
	[UserType] VARCHAR(2) NULL,
	[ActionType] VARCHAR(20) NULL,
	[DateAdded] DATETIME NULL,
	[UserIDAdded] VARCHAR(15) NULL,
	[DateEdited] DATETIME NULL,
	[UserIDEdited] VARCHAR(15) NULL,
    [DefaultPreferenceValue] BIT          CONSTRAINT [DF_tblNotifyAudience_DefaultValue] DEFAULT ((0)) NOT NULL,
	[TableType] VARCHAR(50) NULL, 
    CONSTRAINT [PK_tblNotifyAudience] PRIMARY KEY CLUSTERED ([NotifyAudienceID] ASC)
)




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblNotifyAudience_UserTypeNotifyEventIDNotifyMethodID]
    ON [dbo].[tblNotifyAudience]([UserType] ASC, [NotifyEventID] ASC, [NotifyMethodID] ASC);
GO


