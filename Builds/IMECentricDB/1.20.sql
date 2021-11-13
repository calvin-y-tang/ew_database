
-----------------------------------------------------------------
--Changes to EWFacility
-----------------------------------------------------------------

ALTER TABLE [tblEWFacility]
  ADD [ContactOps] VARCHAR(30)
GO

ALTER TABLE [tblEWFacility]
  ADD [ContactAcct] VARCHAR(30)
GO

ALTER TABLE [tblEWFacility]
  ALTER COLUMN [Region] VARCHAR(15)
GO

ALTER TABLE [tblEWFacility]
  ALTER COLUMN [Logo] VARCHAR(80)
GO

update tblControl set DBVersion='1.20'
GO