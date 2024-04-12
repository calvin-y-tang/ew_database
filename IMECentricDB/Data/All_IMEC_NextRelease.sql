-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 133

-- IMEC-14048 - add timeout to allow time for Helper to resize the image, save the file, and write to tblTempData
INSERT INTO tblSetting ([Name], [Value]) VALUES ('TimeOutResizeImage', '9000')

-- IMEC-14144 - add new bizRule condition for sending new case acknowledgements for Chubb Insurance
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
VALUES (116, 'PC', 16, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'NewCase;', 'EntityType=PC;EntityID=16', NULL, NULL, NULL, 0, NULL, 0)
GO

