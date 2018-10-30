CREATE TABLE [dbo].[tblCaseReviewItem]
(
	[CaseReviewItemID] INT IDENTITY(1, 1) NOT NULL, 
    [CaseNbr]          INT                NULL, 
    [Type]             VARCHAR(10)         NULL, 
    [CompanyName]      VARCHAR(70)        NULL, 
    [Address1]         VARCHAR(50)        NULL, 
    [Address2]         VARCHAR(50)        NULL, 
    [City]             VARCHAR(50)        NULL, 
    [State]            VARCHAR(2)         NULL, 
    [Zip]              VARCHAR(10)        NULL, 
    [Phone]            VARCHAR(15)        NULL, 
    [PhoneExt]         VARCHAR(10)        NULL, 
    [Fax]              VARCHAR(15)        NULL, 
	[ContactFirstName] VARCHAR(50)        NULL,
	[ContactLastName]  VARCHAR(50)        NULL,
    [Email]            VARCHAR(70)        NULL, 
    [ActionTaken]      INT                NULL CONSTRAINT [DF_tblCaseReviewItem_ActionTaken] DEFAULT 0, 
    [DateAdded]        DATETIME           NULL, 
    [UserIDAdded]      VARCHAR(15)        NULL, 
    [DateEdited]       DATETIME           NULL, 
    [UserIDEdited]     VARCHAR(15)        NULL 
	CONSTRAINT [PK_tblCaseReviewItem] PRIMARY KEY CLUSTERED ([CaseReviewItemID] ASC)
)
