CREATE TABLE [dbo].[tblBusinessRule] (
    [BusinessRuleID]   INT           NOT NULL,
    [Name]             VARCHAR (35)  NULL,
    [Category]         VARCHAR (20)  NULL,
    [Descrip]          VARCHAR (150) NULL,
    [IsActive]         BIT           CONSTRAINT [DF_tblBusinessRule_IsActive] DEFAULT ((1)) NOT NULL,
    [EventID]          INT           NULL,
    [AllowOverride]    BIT           CONSTRAINT [DF_tblBusinessRule_AllowOverride] DEFAULT ((0)) NOT NULL,
    [Param1Desc]       VARCHAR (20)  NULL,
    [Param2Desc]       VARCHAR (20)  NULL,
    [Param3Desc]       VARCHAR (20)  NULL,
    [Param4Desc]       VARCHAR (20)  NULL,
    [Param5Desc]       VARCHAR (20)  NULL,
    [BrokenRuleAction] INT           NOT NULL,
    [Param6Desc]       VARCHAR(20)   NULL, 
    CONSTRAINT [PK_tblBusinessRule] PRIMARY KEY CLUSTERED ([BusinessRuleID] ASC)
);

