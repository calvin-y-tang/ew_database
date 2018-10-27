------------------------------------------------------------------------------------------------
--New system table
------------------------------------------------------------------------------------------------

CREATE TABLE [tblEWFlashCategory] (
  [EWBusUnitID] INTEGER NOT NULL,
  [EWServiceTypeID] INTEGER NOT NULL,
  [Category] VARCHAR(25) COLLATE SQL_Latin1_General_CP1_CI_AS,
  CONSTRAINT [PK_EWFlashCategory] PRIMARY KEY CLUSTERED ([EWBusUnitID],[EWServiceTypeID])
)
GO


------------------------------------------------------------------------------------------------
--New indices to speed up flash report
------------------------------------------------------------------------------------------------

CREATE INDEX [IdxtblAcctingTrans_BY_documentnbrtype] ON [tblAcctingTrans]([documentnbr],[type])
GO

CREATE INDEX [IdxtblCase_BY_ForecastDate] ON [tblCase]([ForecastDate])
GO

CREATE INDEX [IdxtblAcctHeader_BY_documentdatedocumentstatus] ON [tblAcctHeader]([documentdate],[documentstatus])
GO

update tblControl set DBVersion='1.35'
GO