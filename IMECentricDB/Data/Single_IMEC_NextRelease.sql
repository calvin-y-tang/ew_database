-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------

-- Sprint 134

USE [EWDataRepository]
GO

-- // IMEC-14211 - Add ReleaseType field to Acctheader table in the data repository
-- // Dev: Sam Chiang
alter table EWDataRepository.dbo.AcctHeader
add ReleaseType varchar(100) null
go
