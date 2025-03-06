
-----------------------------------------------------------------
--Adding new fields to EWFacility and EWLocation
-----------------------------------------------------------------

ALTER TABLE [tblEWFacility]
  ADD [DateGP] DATETIME
GO

ALTER TABLE [tblEWFacility]
  ADD [Logo] VARCHAR(60)
GO


ALTER TABLE [tblEWLocation]
  ADD [Accting] VARCHAR(5)
GO

update tblControl set DBVersion='1.19'
GO