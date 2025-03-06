------------------------------------------------
--Increase the field size for tblEWBusLine.Name
------------------------------------------------

ALTER TABLE [tblEWBusLine]
  ALTER COLUMN [Name] VARCHAR(20)
GO


-------------------------------------------------
--Change EWFacility and EWFacilityGroupSummary tables
-------------------------------------------------

ALTER TABLE [dbo].[tblEWFacility] ADD
[DRDataFeed] [int] NULL,
[DRHistory] [int] NULL
GO
ALTER TABLE [dbo].[tblEWFacility] ALTER COLUMN [ShortName] [varchar] (20) NULL
GO
ALTER TABLE [dbo].[tblEWFacilityGroupSummary] ALTER COLUMN [Facility] [varchar] (20) NULL
GO


-------------------------------------------------
--Change by Gary for Ricwel problem
-------------------------------------------------

ALTER TABLE [dbo].[tblCase]
ADD [ReminderNotifyDays] int NULL
GO

-------------------------------------------------
--New date fields to track TAT
-------------------------------------------------

ALTER TABLE [tblCase]
  ADD [OrigApptTime] DATETIME
GO

ALTER TABLE [tblCase]
  ADD [RptFinalizedDate] DATETIME
GO

ALTER TABLE [tblCase]
  ADD [ApptMadeDate] DATETIME
GO

update tblControl set DBVersion='1.48'
GO
