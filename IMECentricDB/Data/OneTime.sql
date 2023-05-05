--
-- Sprint 110
--

/* Execute this section against SQLSERVER7 */

-- ExamWorks US
USE [IMECentricEW]
UPDATE tblControl SET VendorGPEntityPrefix = 999, OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

-- FirstChoice
USE [IMECentricFCE]
UPDATE tblControl SET VendorGPEntityPrefix = 999, OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

-- Landmark
USE [IMECentricLandMark]
UPDATE tblControl SET VendorGPEntityPrefix = 999, OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

-- MCMC
USE [IMECentricMCMC]
UPDATE tblControl SET VendorGPEntityPrefix = 999, OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

-- IMECentricMedicolegal
USE [IMECentricMedicolegal]
UPDATE tblControl SET VendorGPEntityPrefix = 999, OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

USE [IMECentricPOPB]
UPDATE tblControl SET VendorGPEntityPrefix = 999, OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

/* Execute this section against SQLSERVER3-CA */
USE [IMECentricCVS]
UPDATE tblControl SET OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

USE [IMECentricDirectIME]
UPDATE tblControl SET OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

USE [IMECentricIMAS]
UPDATE tblControl SET OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

USE [IMECentricKRA]
UPDATE tblControl SET OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

USE [IMECentricMakos]
UPDATE tblControl SET OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

USE [IMECentricMatrix]
UPDATE tblControl SET OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

USE [IMECentricNYRC]
UPDATE tblControl SET OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

USE [IMECentricMedylex]
UPDATE tblControl SET OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

USE [IMECentricSOMA]
UPDATE tblControl SET OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

USE [IMECentricMedaca]
UPDATE tblControl SET OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO

USE [IMECentricEWCA]
UPDATE tblControl SET OPVendorGPEntityPrefix = (SELECT VendorGPEntityPrefix FROM tblControl)
GO




