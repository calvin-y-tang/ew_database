CREATE TABLE [dbo].[tblConfirmationRule]
(
	[ConfirmationRuleID] INT IDENTITY (1, 1) NOT NULL, 
    [ProcessOrder] INT NULL, 
    [OfficeCode] INT NULL, 
    [CaseType] INT NULL, 
    [ServiceCode] INT NULL, 
    [Jurisdiction] VARCHAR(2) NULL, 
    [EmployerID] INT NULL, 
    [CompanyCode] INT NULL, 
    [ClientCode] INT NULL, 
    [DateAdded] DATETIME NULL, 
    [UserIDAdded] VARCHAR(15) NULL, 
    [DateEdited] DATETIME NULL, 
    [UserIDEdited] VARCHAR(15) NULL,
	[ParentCompanyID] INT NULL,
	[ExcludeFromList] BIT CONSTRAINT [DF_tblConfirmationRule_ExcludeFromList] DEFAULT ((0)) NOT NULL,
	CONSTRAINT [PK_tblConfirmationRule] PRIMARY KEY CLUSTERED ([ConfirmationRuleID] ASC)
)
