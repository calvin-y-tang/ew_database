
-- IMEC-12523
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (162, 'DynamicBookmarks', 'Case', 'Dynamic Bookmarks used for Generate Documents', 1, 1801, 0, 'BookmarkName', 'NeedInterpreter', 'NeedTransportation', NULL, NULL, 0, 'TextForBookmark')
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES(162, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, 'BusinessRuleBookmark1', 'True', NULL, NULL, NULL, 0, 'Transportation and/or Translation services have been requested for this appointment - you will be contacted by the vendor HealtheSystems for coordination of these services.  If you have questions regarding this/these service(s), please contact HealtheSystems at 844-451-9665.'),
      (162, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, 'BusinessRuleBookmark1', NULL, 'True', NULL, NULL, 0, 'Transportation and/or Translation services have been requested for this appointment - you will be contacted by the vendor HealtheSystems for coordination of these services.  If you have questions regarding this/these service(s), please contact HealtheSystems at 844-451-9665.'),
      (162, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, 'BusinessRuleBookmark1', 'True', 'True', NULL, NULL, 0, 'Transportation and/or Translation services have been requested for this appointment - you will be contacted by the vendor HealtheSystems for coordination of these services.  If you have questions regarding this/these service(s), please contact HealtheSystems at 844-451-9665.'),
      (162, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'BusinessRuleBookmark1', 'True', NULL, NULL, NULL, 0, 'Transportation and/or Translation services have been requested for this appointment - you will be contacted by the vendor Albors & Alnet for coordination of these services.  If you have questions regarding this/these service(s), please contact Albors & Alnet at 800-785-8634.'),
      (162, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'BusinessRuleBookmark1', NULL, 'True', NULL, NULL, 0, 'Transportation and/or Translation services have been requested for this appointment - you will be contacted by the vendor Albors & Alnet for coordination of these services.  If you have questions regarding this/these service(s), please contact Albors & Alnet at 800-785-8634.'),
      (162, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'BusinessRuleBookmark1', 'True', 'True', NULL, NULL, 0, 'Transportation and/or Translation services have been requested for this appointment - you will be contacted by the vendor Albors & Alnet for coordination of these services.  If you have questions regarding this/these service(s), please contact Albors & Alnet at 800-785-8634.')
GO

-- IMEC-12531
INSERT INTO tblUserFunction 
VALUES('DynamicBookmarkAddEdit', 'Dynamic Bookmarks - Add/Edit', GetDate())
GO
