-- **********************************************************************************************************
--
--   Description:
--        First of a group of scripts that are used to purge/split/clean an IMEC DB.
--        This script creates a temporary table, function, and indexes that will be used throughout
--        the process to track items that are "OK" to delete from the database being processed.
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- create a temporary table to store items to delete
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpDelete](
     [PrimaryKey] [INT] IDENTITY(1,1) NOT NULL,
     [Type] [VARCHAR](20) NOT NULL,
     [ID] [INT] NOT NULL,
     [OkToDelete] [BIT] NULL,
 CONSTRAINT [PK_tmpDelete] PRIMARY KEY CLUSTERED
(
     [PrimaryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-- create an index on our table to speed lookups
SET ANSI_PADDING OFF
GO
CREATE INDEX IX_tmpDelete ON tmpDelete (Type, ID)
GO

-- create a simple function that we can call to return us a list of IDs for a given type that
-- have been flagged for deletion
CREATE FUNCTION dbo.getID
(
  @DataType varchar(100)
)
RETURNS TABLE
AS
RETURN
(
 SELECT ID FROM tmpDelete WHERE TYPE=@DataType AND OkToDelete=1
);
GO

-- create some addtional indexes on existing tables to speed up our processing
CREATE INDEX [IdxtblDoctorSchedule_BY_CaseNbr1] ON [tblDoctorSchedule]([CaseNbr1])
GO
CREATE INDEX [IdxtblDoctorSchedule_BY_CaseNbr2] ON [tblDoctorSchedule]([CaseNbr2])
GO
CREATE INDEX [IdxtblDoctorSchedule_BY_CaseNbr3] ON [tblDoctorSchedule]([CaseNbr3])
GO
