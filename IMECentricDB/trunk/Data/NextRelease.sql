
-- Issue 11718 - Add business rule and condition for Hartford quotes - BCC email
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(112, 'HartfordQuoteBCC', 'Case', 'BCC Hartford for all Invoice Quotes generated thru generate docs form', 1, 1201, 0, 'BccEmailAddress', NULL, NULL, NULL, NULL, 0)

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('PC', 30, 2, 1, 112, GetDate(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, 'HartfordQuotes@ExamWorks.com', NULL, NULL, NULL, NULL)
GO



-- Issue 11702 - populate new DPSImportConfig table with configuration details
INSERT INTO tblDPSResultFileConfig (EWServiceTypeID, FileIndex, Description, CombinedFileName, CombineFileSeqNo)
VALUES(-1, 1, 'Sorted Document 1', 'MedIndex - Final', 1),
      (-1, 2, 'Exclusion Document', 'MedIndex - Final', 99),
      (-1, 3, 'Sorted Document 2', 'MedIndex - Final', 2),
      (-1, 4, 'Sorted Document 3', 'MedIndex - Final', 3),
      (-1, 5, 'Sorted Document 4', 'MedIndex - Final', 4),
      (-1, 6, 'Sorted Document 5', 'MedIndex - Final', 5),
      (-1, 7, 'Sorted Document 6', 'MedIndex - Final', 6),
      (-1, 8, 'Sorted Document 7', 'MedIndex - Final', 7),
      (-1, 9, 'Sorted Document 8', 'MedIndex - Final', 8),
      (-1, 10, 'Sorted Document 9', 'MedIndex - Final', 9), 
	  (11, 1, 'MedIndex - Final', '', 0)
GO


INSERT INTO tblUserFunction
(
    FunctionCode,
    FunctionDesc
)
VALUES ( 'RecRetrieval', 'Record Retrieval' )
GO

DELETE FROM tblQuoteStatus
GO
SET IDENTITY_INSERT [dbo].[tblQuoteStatus] ON
INSERT INTO [dbo].[tblQuoteStatus] ([QuoteStatusID], [QuoteType], [Description], [IsClosed], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [QuoteHandlingID]) VALUES (1, 'VO', 'Awaiting Quote', 0, '2018-08-05 22:57:31.333', 'Admin', NULL, NULL, 1)
INSERT INTO [dbo].[tblQuoteStatus] ([QuoteStatusID], [QuoteType], [Description], [IsClosed], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [QuoteHandlingID]) VALUES (2, 'VO', 'Quote Received', 1, '2018-08-05 22:57:31.337', 'Admin', NULL, NULL, 1)
INSERT INTO [dbo].[tblQuoteStatus] ([QuoteStatusID], [QuoteType], [Description], [IsClosed], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [QuoteHandlingID]) VALUES (3, 'VO', 'Cancelled', 1, '2018-08-05 22:57:31.337', 'Admin', NULL, NULL, 1)
INSERT INTO [dbo].[tblQuoteStatus] ([QuoteStatusID], [QuoteType], [Description], [IsClosed], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [QuoteHandlingID]) VALUES (4, 'IN', 'Awaiting Approval', 0, '2018-08-05 22:57:31.337', 'Admin', NULL, NULL, 2)
INSERT INTO [dbo].[tblQuoteStatus] ([QuoteStatusID], [QuoteType], [Description], [IsClosed], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [QuoteHandlingID]) VALUES (5, 'IN', 'Approved', 1, '2018-08-05 22:57:31.337', 'Admin', NULL, NULL, 2)
INSERT INTO [dbo].[tblQuoteStatus] ([QuoteStatusID], [QuoteType], [Description], [IsClosed], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [QuoteHandlingID]) VALUES (6, 'IN', 'No Approval Needed', 1, '2018-08-05 22:57:31.337', 'Admin', NULL, NULL, 1)
INSERT INTO [dbo].[tblQuoteStatus] ([QuoteStatusID], [QuoteType], [Description], [IsClosed], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [QuoteHandlingID]) VALUES (7, 'IN', 'Cancelled', 1, '2018-08-05 22:57:31.337', 'Admin', NULL, NULL, NULL)
INSERT INTO [dbo].[tblQuoteStatus] ([QuoteStatusID], [QuoteType], [Description], [IsClosed], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [QuoteHandlingID]) VALUES (8, 'IN', 'Awaiting Distribution', 0, '2020-07-09 17:36:32.083', 'Admin', NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[tblQuoteStatus] OFF

GO
