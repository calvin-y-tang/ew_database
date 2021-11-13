CREATE TABLE [dbo].[tblNotifyDetail]
(
	[NotifyID] INT NOT NULL,
	[Details] VARCHAR(MAX) NULL,
	CONSTRAINT [PK_tblNotifyDetail] PRIMARY KEY CLUSTERED ([NotifyID] ASC)
)
