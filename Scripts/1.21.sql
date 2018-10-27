--------------------------------------------------
--Add new column to override remit address for a Facility,
--and change the existing Company override field name
--------------------------------------------------

EXEC sp_rename '[tblCompany].[EWInvAddrEWFacilityID]', 'InvRemitEWFacilityID', 'COLUMN'
GO


ALTER TABLE [tblEWFacility]
  ADD [InvRemitEWFacilityID] INTEGER
GO

DROP VIEW [dbo].[vwcompany]
GO

CREATE VIEW [dbo].[vwcompany]
AS
SELECT      TOP 100 PERCENT dbo.tblCompany.*
FROM          dbo.tblCompany
ORDER BY intname
GO

update tblControl set DBVersion='1.21'
GO