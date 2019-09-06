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



-- DEV NOTE: this business rule condition will need to adjusted for the target deployment DB
--INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
--VALUES('CO', 6741, 2, 1, 104, '2019-08-12', 'Admin', '2019-08-12', 'Admin', NULL, NULL, NULL, NULL, '000808', NULL, '525', NULL, 'ClaimEmployerOverride')
--GO

-- DEV NOTE: these business rule conditions will need to adjusted for the target deployment DB. Need to set the EntityCode to the
--		desired CompanyCode Value in the target DB
--INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
--VALUES('CO', 0, 2, 2, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', NULL, NULL, NULL, NULL, '', '', '', NULL, NULL),
--	  ('CO', 0, 2, 2, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', NULL, NULL, NULL, NULL, '', '', '', NULL, NULL),
--	  ('CO', 0, 2, 2, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', NULL, NULL, NULL, NULL, '', '', '', NULL, NULL),

--    ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 12, NULL, NULL, NULL, 'COIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 12, NULL, NULL, NULL, 'COIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 12, NULL, NULL, NULL, 'COIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 29, NULL, NULL, NULL, 'WVIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 29, NULL, NULL, NULL, 'WVIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 29, NULL, NULL, NULL, 'WVIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 32, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 32, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 33, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 33, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 33, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 33, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 34, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 34, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 34, NULL, NULL, NULL, 'TXIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 36, NULL, NULL, NULL, 'ILIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 36, NULL, NULL, NULL, 'ILIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 36, NULL, NULL, NULL, 'ILIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 22, NULL, NULL, NULL, 'MidwestIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 22, NULL, NULL, NULL, 'MidwestIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 22, NULL, NULL, NULL, 'MidwestIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 20, NULL, NULL, NULL, 'DEIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 20, NULL, NULL, NULL, 'DEIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 20, NULL, NULL, NULL, 'DEIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 26, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 26, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 26, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 27, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 27, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 27, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 28, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 28, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 28, NULL, NULL, NULL, 'NYIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
	   
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 31, NULL, NULL, NULL, 'PAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 31, NULL, NULL, NULL, 'PAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 31, NULL, NULL, NULL, 'PAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 30, NULL, NULL, NULL, 'ORIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 30, NULL, NULL, NULL, 'ORIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 30, NULL, NULL, NULL, 'ORIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 35, NULL, NULL, NULL, 'ORIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 35, NULL, NULL, NULL, 'ORIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 35, NULL, NULL, NULL, 'ORIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 13, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 13, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 13, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 14, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 14, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 14, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 15, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 15, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 15, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 16, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 16, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 16, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 38, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 38, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 38, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 39, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 39, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 39, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 40, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 40, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 40, NULL, NULL, NULL, 'CAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 23, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 23, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 23, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 24, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 24, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 24, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 25, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 25, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 25, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 41, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 41, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 41, NULL, NULL, NULL, 'NJIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 

--	  ('CO', 0, 2, 1, 105, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 19, NULL, NULL, NULL, 'MAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 106, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 19, NULL, NULL, NULL, 'MAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL), 
--	  ('CO', 0, 2, 1, 107, '2019-08-13', 'Admin', '2019-08-13', 'Admin', 19, NULL, NULL, NULL, 'MAIME@stradix.com', 'IMEStatus@strdix.com', ' imereports@stradix.com', NULL, NULL)
--GO 

