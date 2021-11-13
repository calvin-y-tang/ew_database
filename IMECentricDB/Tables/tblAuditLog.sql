CREATE TABLE [dbo].[tblAuditLog] (
    [PrimaryKey]       INT           IDENTITY (1, 1) NOT NULL,
    [LogDate]          DATETIME      NOT NULL,
    [UserID]           VARCHAR (20)  NULL,
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
    CONSTRAINT [PK_tblAuditLog] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);

