CREATE TABLE [dbo].[tblReferralAssignmentRule] (
    [ReferralAssignmentRuleID] INT          IDENTITY (1, 1) NOT NULL,
    [ProcessOrder]             INT          NOT NULL,
    [Active]                   BIT          CONSTRAINT [DF_tblReferralAssignmentRule_Active] DEFAULT ((1)) NOT NULL,
    [ToOfficeCode]             INT          NOT NULL,
    [CompanyName]              VARCHAR (70) NULL,
    [CompanyNameMatchType]     VARCHAR (2)  NULL,
    [CompanyCode]              INT          NULL,
    [CompanyState]             VARCHAR (2)  NULL,
    [ExamineeState]            VARCHAR (15) NULL,
    [CaseType]                 INT          NULL,
    [Jurisdiction]             VARCHAR (2)  NULL,
    [DateAdded]                DATETIME     NULL,
    [UserIDAdded]              VARCHAR (15) NULL,
    [DateEdited]               DATETIME     NULL,
    [UserIDEdited]             VARCHAR (15) NULL,
    CONSTRAINT [PK_tblReferralAssignmentRule] PRIMARY KEY CLUSTERED ([ReferralAssignmentRuleID] ASC)
);



