
--Add a new field to determine if the parent company is a national company or not
ALTER TABLE [tblEWParentCompany]
  ADD [NationalAccount] BIT
GO
UPDATE tblEWParentCompany SET NationalAccount=0
GO
ALTER TABLE [tblEWParentCompany]
  ALTER COLUMN [NationalAccount] BIT NOT NULL
GO



UPDATE tblControl SET DBVersion='2.00'
GO
