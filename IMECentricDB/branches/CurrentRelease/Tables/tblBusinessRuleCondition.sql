CREATE TABLE [dbo].[tblBusinessRuleCondition] (
    [BusinessRuleConditionID] INT          IDENTITY (1, 1) NOT NULL,
    [EntityType]              VARCHAR (2)  NULL,
    [EntityID]                INT          NULL,
    [BillingEntity]           INT          CONSTRAINT [DF_tblBusinessRuleCondition_BillingEntity] DEFAULT ((0)) NOT NULL,
    [ProcessOrder]            INT          NULL,
    [BusinessRuleID]          INT          NOT NULL,
    [DateAdded]               DATETIME     NULL,
    [UserIDAdded]             VARCHAR (20) NULL,
    [DateEdited]              DATETIME     NULL,
    [UserIDEdited]            VARCHAR (20) NULL,
    [OfficeCode]              INT          NULL,
    [EWBusLineID]             INT          NULL,
    [EWServiceTypeID]         INT          NULL,
    [Jurisdiction]            VARCHAR (5)  NULL,
    [Param1]                  VARCHAR (20) NULL,
    [Param2]                  VARCHAR (20) NULL,
    [Param3]                  VARCHAR (20) NULL,
    [Param4]                  VARCHAR (20) NULL,
    [Param5]                  VARCHAR (20) NULL,
    CONSTRAINT [PK_tblBusinessRuleCondition] PRIMARY KEY CLUSTERED ([BusinessRuleConditionID] ASC)
);

