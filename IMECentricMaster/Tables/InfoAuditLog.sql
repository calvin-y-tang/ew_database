CREATE TABLE [dbo].[InfoAuditLog] (
    [PrimaryKey]       INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [LogDate]          DATETIME      NOT NULL,
    [UserID]           INT           NOT NULL,
    [Module]           VARCHAR (100) NULL,
    [Action]           INT           NOT NULL,
    [MasterEntityType] VARCHAR (50)  NULL,
    [MasterEntityID]   VARCHAR (50)  NULL,
    [EntityType]       VARCHAR (50)  NULL,
    [EntityID]         VARCHAR (50)  NULL,
    [EntityDescrip]    VARCHAR (100) NULL,
    [FieldName]        VARCHAR (50)  NULL,
    [OldValue]         VARCHAR (100) NULL,
    [NewValue]         VARCHAR (100) NULL,
    CONSTRAINT [PK_InfoAuditLog] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);

