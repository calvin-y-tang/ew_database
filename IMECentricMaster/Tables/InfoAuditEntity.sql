CREATE TABLE [dbo].[InfoAuditEntity] (
    [EntityType]  VARCHAR (50)  NOT NULL,
    [DisplayName] VARCHAR (100) NULL,
    CONSTRAINT [PK_InfoAuditEntity] PRIMARY KEY CLUSTERED ([EntityType] ASC)
);

