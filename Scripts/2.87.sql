PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [ReferralAssignmentRuleID] INT NULL;


GO
PRINT N'Altering [dbo].[tblEWParentCompany]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
ALTER TABLE [dbo].[tblEWParentCompany]
    ADD [BulkBillingID] INT NULL;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[tblReferralAssignmentRule]...';


GO
ALTER TABLE [dbo].[tblReferralAssignmentRule] ALTER COLUMN [CompanyName] VARCHAR (70) NULL;

ALTER TABLE [dbo].[tblReferralAssignmentRule] ALTER COLUMN [CompanyNameMatchType] VARCHAR (2) NULL;


GO
ALTER TABLE [dbo].[tblReferralAssignmentRule]
    ADD [DateAdded]    DATETIME     NULL,
        [UserIDAdded]  VARCHAR (15) NULL,
        [DateEdited]   DATETIME     NULL,
        [UserIDEdited] VARCHAR (15) NULL;


GO
PRINT N'Creating [dbo].[DF_tblDoctor_SchedulePriority]...';


GO
ALTER TABLE [dbo].[tblDoctor]
    ADD CONSTRAINT [DF_tblDoctor_SchedulePriority] DEFAULT ((3)) FOR [SchedulePriority];


GO


UPDATE tblControl SET DBVersion='2.87'
GO