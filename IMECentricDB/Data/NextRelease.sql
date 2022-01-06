
-- IMEC-12318 - parent company patch existing data
UPDATE IMECentricMaster.dbo.EWParentCompany
SET RequireInOutNetworkInvoice = ISNULL(RequireInOutNetworkInvoice, 0), 
    RequireOutofNetworkReason = ISNULL(RequireOutofNetworkReason, 0)
GO

UPDATE tblEWParentCompany
SET RequireInOutNetworkInvoice = ISNULL(RequireInOutNetworkInvoice, 0), 
    RequireOutofNetworkReason = ISNULL(RequireOutofNetworkReason, 0)
GO


