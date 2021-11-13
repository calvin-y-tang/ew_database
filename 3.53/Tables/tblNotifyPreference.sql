CREATE TABLE [dbo].[tblNotifyPreference]
(
	[NotifyPreferenceID] INT IDENTITY (1,1) NOT NULL,
    [WebUserID]          INT          NOT NULL,
	[NotifyEventID] INT NOT NULL,
	[NotifyMethodID] INT NOT NULL,
	[DateEdited] DATETIME NULL,
	[UserIDEdited] VARCHAR(15) NULL,
    [PreferenceValue]    BIT          NOT NULL,
	CONSTRAINT [PK_tblNotifyPreference] PRIMARY KEY CLUSTERED ([NotifyPreferenceID] ASC)
)
