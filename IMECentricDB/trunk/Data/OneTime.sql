USE [IMECentricMaster]
GO
/****** Object:  Table [dbo].[ConfSMSMessage]    Script Date: 8/29/2019 2:44:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* add new column to ConfList */
ALTER TABLE ConfList ADD CallToPhone VarChar(15) NULL;

/* create new table */
CREATE TABLE [dbo].[ConfSMSMessage](
	[DBID] [int] NOT NULL,
	[SMSType] [int] NOT NULL,
	[Message] [varchar](2048) NOT NULL,
	[DateAdded] [datetime] NOT NULL,
	[DateEdited] [datetime] NOT NULL,
	[UserIDAdded] [varchar](20) NOT NULL,
	[UserIDEdited] [varchar](20) NOT NULL,
 CONSTRAINT [PK_ConfSMSMessage_1] PRIMARY KEY CLUSTERED 
(
	[DBID] ASC,
	[SMSType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/* insert text messages into newly created table */
INSERT INTO ConfSMSMessage (DBID, SMSType, Message, DateAdded, DateEdited, UserIDAdded, UserIDEdited)
	values (0, 1, 'Appt reminder message alerts. 1 msgs/appointment. Msg&Data rates may apply. Reply STOP to cancel.', getdate(), getdate(), 'Admin', 'Admin')
INSERT INTO ConfSMSMessage (DBID, SMSType, Message, DateAdded, DateEdited, UserIDAdded, UserIDEdited)
	values (0, 2, 'You are unsubscribed from Appt Reminder Message alerts. No more messages will be sent. Reply HELP for help.', getdate(), getdate(), 'Admin', 'Admin')
INSERT INTO ConfSMSMessage (DBID, SMSType, Message, DateAdded, DateEdited, UserIDAdded, UserIDEdited)
	values (0, 3, 'You are subscribed to Appt Reminder Message alerts. Msg & Data rates may apply. Help for Help, STOP to cancel.', getdate(), getdate(), 'Admin', 'Admin')
INSERT INTO ConfSMSMessage (DBID, SMSType, Message, DateAdded, DateEdited, UserIDAdded, UserIDEdited)
	values (23, 1, 'ExamWorks Reminder Message alerts. More help at ISTwilioSupport@examworks.com or 877-339-7520. 1 msgs/appointment. Msg&Data rates may apply. Reply STOP to cancel.', getdate(), getdate(), 'Admin', 'Admin')
INSERT INTO ConfSMSMessage (DBID, SMSType, Message, DateAdded, DateEdited, UserIDAdded, UserIDEdited)
	values (23, 2, 'You are unsubscribed from ExamWorks Reminder Message alerts. No more messages will be sent. Reply HELP for help or ISTwilioSupport@examworks.com.', getdate(), getdate(), 'Admin', 'Admin')
INSERT INTO ConfSMSMessage (DBID, SMSType, Message, DateAdded, DateEdited, UserIDAdded, UserIDEdited)
	values (23, 3, 'You are subscribed to ExamWorks Reminder Message alerts. Msg & Data rates may apply. 1 msgs / appointment.Reply HELP for help, STOP to cancel.', getdate(), getdate(), 'Admin', 'Admin')


GO


--// EWIS schedule job entry for Client First Case: IMEC-11177
insert into ISSchedule (Name, Task, Type, Interval, WeekDays, Time, StartDate, EndDate, RunTimeStart, RunTimeEnd, Param, GroupNo, SeqNo)
values (
	'Client First Case',
	'RunSQL',
	'D',
	1,
	'0111110',
	'1900-01-01 23:45:00',
	'2019-08-30 00:00:00',
	null,
	'2019-08-30 22:30:00',
	null,
	'SQLFile=C:\EWIntegrationServer\SQLScripts\Client_FirstCaseNbr_Update.sql;DBType=23;AlwaysEmailLog=True',
	null,
	null
)
GO


UPDATE DPSJobFile SET JobTrackingID=SUBSTRING(JobID, CHARINDEX('-', JobID, 7)+1, LEN(JobID)-CHARINDEX('-', JobID, 7)), JobType='Process' WHERE SourceID=1

GO




--Issue 11118 - Add a setting to tblSetting to hide the Cancel DPS Bundle button.  Doug L says they are ready for this functionality yet
INSERT INTO tblSetting (Name, Value) VALUES ('DPSCancelBundleSendFile', 'True')
GO

