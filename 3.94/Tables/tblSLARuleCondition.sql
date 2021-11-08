CREATE TABLE [dbo].[tblSLARuleCondition] (
    [SLARuleConditionID] INT          IDENTITY (1, 1) NOT NULL,
    [SLARuleID]          INT          NOT NULL,
    [ConditionType]      VARCHAR (20) NULL,
    [ConditionValue]     VARCHAR (25) NULL,
    CONSTRAINT [PK_tblSLARuleCondition] PRIMARY KEY CLUSTERED ([SLARuleConditionID] ASC)
);





