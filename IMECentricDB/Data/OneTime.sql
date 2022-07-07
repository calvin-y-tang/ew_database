-- Sprint 88


-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricMaster
-- Table   : ISExtIntegration
-- Issue   : IMEC-12881/12882 - add Vendor ID and name and DBID for Vendor Drop File
USE IMECentricMaster
GO
UPDATE E
	SET E.Param = 'VendorName="ExamWorks";VendorId="EXW";' + E.Param, E.Type = 'DocTransferSedgwick23'
FROM ISExtIntegration as E
WHERE E.ExtIntegrationID = 1041

GO

-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricMaster
-- Table   : ISOperation
-- Issue   : IMEC-12879 - add DBID to ISOperation Persist to DB
USE IMECentricMaster
GO
UPDATE O
	SET O.Param = O.Param + ';DBID=23'
  FROM ISOperation as O
WHERE O.OperationID = 5

GO
