
ALTER TABLE [tblEWFacility]
  ADD [ParentEWFacilityID] INTEGER
GO



UPDATE tblControl SET DBVersion='1.59'
GO
