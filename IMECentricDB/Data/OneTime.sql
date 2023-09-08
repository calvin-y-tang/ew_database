-- Sprint 118

-- ABI - add columns - issue 13800
USE IMECentricMaster
GO

  ALTER TABLE GPInvoice 
  ADD 
  [InsuredName] VARCHAR(100) NULL, 
  [CaseName] VARCHAR(200) NULL, 
  [LitCaseNo] VARCHAR(100) NULL, 
  [LocationName] VARCHAR(100) NULL, 
  [LocationState] VARCHAR(2) NULL, 
  [LocationType] VARCHAR(30) NULL

GO

  ALTER TABLE GPCompany 
  ADD 
  [CustomerType] VARCHAR(100) NULL

GO

USE EWDataRepository
GO

  ALTER TABLE AcctHeader 
  ADD 
  [InsuredName] VARCHAR(100) NULL, 
  [CaseName] VARCHAR(200) NULL, 
  [LitCaseNo] VARCHAR(100) NULL, 
  [LocationName] VARCHAR(100) NULL, 
  [LocationState] VARCHAR(2) NULL, 
  [LocationType] VARCHAR(30) NULL

GO
  ALTER TABLE Company 
  ADD 
  [CustomerType] VARCHAR(100) NULL

GO
