/*
This is another way to move data from tmp table, but it involves more manual fixes when schema is changed on the table.
*/

/*
This script can be skipped if Data Cleansing will run, since that will truncate tblCaseHistory anyway
*/

--Delete CH before 2020
--SELECT TOP 1 ID FROM tblCaseHistory WHERE EventDate>='2020-01-01' ORDER BY ID
--SELECT * INTO tmpCaseHistory FROM tblCaseHistory WHERE ID>=22424183
SELECT * INTO tmpCaseHistory FROM tblCaseHistory WHERE ID=0
DROP TABLE tblCaseHistory
EXEC sp_rename 'tmpCaseHistory', 'tblCaseHistory'
GO


SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
PRINT N'Creating primary key [PK_tblCaseHistory] on [dbo].[tblCaseHistory]'
GO
ALTER TABLE [dbo].[tblCaseHistory] ADD CONSTRAINT [PK_tblCaseHistory] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_tblCaseHistory_CaseNbrEventDate] on [dbo].[tblCaseHistory]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_CaseNbrEventDate] ON [dbo].[tblCaseHistory] ([CaseNbr], [EventDate])
GO
PRINT N'Creating index [IX_tblCaseHistory_CaseNbrFollowUpDate] on [dbo].[tblCaseHistory]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_CaseNbrFollowUpDate] ON [dbo].[tblCaseHistory] ([CaseNbr], [FollowUpDate]) INCLUDE ([EventDate], [Eventdesc], [ID], [OtherInfo], [UserID])
GO
PRINT N'Creating index [IX_tblCaseHistory_EventDate] on [dbo].[tblCaseHistory]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_EventDate] ON [dbo].[tblCaseHistory] ([EventDate])
GO
PRINT N'Creating index [IX_tblCaseHistory_FollowUpDate] on [dbo].[tblCaseHistory]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_FollowUpDate] ON [dbo].[tblCaseHistory] ([FollowUpDate])
GO
PRINT N'Creating index [IX_tblCaseHistory_Type] on [dbo].[tblCaseHistory]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_Type] ON [dbo].[tblCaseHistory] ([Type])
GO
PRINT N'Adding constraints to [dbo].[tblCaseHistory]'
GO
ALTER TABLE [dbo].[tblCaseHistory] ADD CONSTRAINT [DF_tblCaseHistory_PublishOnWeb] DEFAULT ((0)) FOR [PublishOnWeb]
GO
ALTER TABLE [dbo].[tblCaseHistory] ADD CONSTRAINT [DF_tblCaseHistory_Viewed] DEFAULT ((0)) FOR [Viewed]
GO
ALTER TABLE [dbo].[tblCaseHistory] ADD CONSTRAINT [DF_tblCaseHistory_Locked] DEFAULT ((0)) FOR [Locked]
GO
ALTER TABLE [dbo].[tblCaseHistory] ADD CONSTRAINT [DF_tblCaseHistory_ConversationLog] DEFAULT ((0)) FOR [ConversationLog]
GO
ALTER TABLE [dbo].[tblCaseHistory] ADD CONSTRAINT [DF_tblCaseHistory_ExceptionAlert] DEFAULT ((0)) FOR [ExceptionAlert]
GO
ALTER TABLE [dbo].[tblCaseHistory] ADD CONSTRAINT [DF_tblCaseHistory_AlertType] DEFAULT ((0)) FOR [AlertType]
GO
